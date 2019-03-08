#!/usr/bin/env python3
''''
Paloaltonetworks deploy.py

This software is provided without support, warranty, or guarantee.
Use at your own risk.

Usage

python deploy.py -u <fwusername> -p'<fwpassword> -k <aws_key> -s <aws_secret> -r <aws_region>

Outputs to file deployment_status

Contents of json dict

{"WebInDeploy": "Success", "WebInFWConf": "Success", "waf_conf": "Success"}
'''

import argparse
import json
import logging
import ssl
import time
import urllib.error
import urllib.request
import urllib.response
import xml
import xml.etree.ElementTree as et

from pandevice import firewall
from pandevice import updater
from python_terraform import Terraform

gcontext = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)

# logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger()
handler = logging.StreamHandler()
formatter = logging.Formatter('%(levelname)-8s %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.INFO)


# global var to keep status output
status_output = dict()


def getApiKey(hostname, username, password):
    '''Generate the API key from username / password
    '''

    data = {
        'type': 'keygen',
        'user': username,
        'password': password
    }
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    url = "https://" + hostname + "/api"
    encoded_data = urllib.parse.urlencode(data).encode('utf-8')
    api_key = ""
    while (True):
        try:
            response = urllib.request.urlopen(url, data=encoded_data, context=ctx).read()
            api_key = xml.etree.ElementTree.XML(response)[0][0].text
        except urllib.error.URLError:
            logger.info("No response from FW. Wait 20 secs before retry")
            time.sleep(20)
            continue
        else:
            logger.info("FW Management plane is Responding so checking if Dataplane is ready")
            logger.debug("Response to get_api is {}".format(response))
            return api_key


def getFirewallStatus(fwMgtIP, api_key):
    """
    Gets the firewall status by sending the API request show chassis status.
    :param fwMgtIP:  IP Address of firewall interface to be probed
    :param api_key:  Panos API key
    """
    global gcontext

    cmd = urllib.request.Request(
        "https://" + fwMgtIP + "/api/?type=op&cmd=<show><chassis-ready></chassis-ready></show>&key=" + api_key)
    # Send command to fw and see if it times out or we get a response
    logger.info("Sending command 'show chassis status' to firewall")
    try:
        response = urllib.request.urlopen(cmd, data=None, context=gcontext, timeout=5).read()

    except urllib.error.URLError:
        logger.debug("No response from FW. So maybe not up!")
        return 'no'
        # sleep and check again?
    else:
        logger.debug("Got response to 'show chassis status' {}".format(response))

    resp_header = et.fromstring(response)
    logger.debug('Response header is {}'.format(resp_header))

    if resp_header.tag != 'response':
        logger.debug("Did not get a valid 'response' string...maybe a timeout")
        return 'cmd_error'

    if resp_header.attrib['status'] == 'error':
        logger.debug("Got an error for the command")
        return 'cmd_error'

    if resp_header.attrib['status'] == 'success':
        # The fw responded with a successful command execution. So is it ready?
        for element in resp_header:
            if element.text.rstrip() == 'yes':
                logger.info("FW Chassis is ready to accept configuration and connections")
                return 'yes'
            else:
                logger.info("FW Chassis not ready, still waiting for dataplane")
                time.sleep(10)
                return 'almost'


def write_status_file(message_dict):
    '''
    Writes the deployment state to a dict and outputs to file for status tracking
    '''
    # abuse global vars :-/
    global status_output

    # FIXME - make this additive and sprinkle throughout to get all tf outputs
    status_file_path = './deployment_status.json'

    with open(status_file_path, 'w+') as f:
        fs = f.read()
        if fs != '':
            try:
                fso = json.loads(fs)
            except ValueError as ve:
                logger.error('Could not load status file!')
                fso = dict()
        else:
            fso = dict()

        print('updating fso')
        print(fso)
        # update the dict with our new message
        print(message_dict)
        fso.update(message_dict)
        status_output = fso
        f.write(json.dumps(fso))


def getServerStatus(IP):
    """
    Gets the server status by sending an HTTP request and checking for a 200 response code
    """
    global gcontext

    cmd = urllib.request.Request("http://" + IP + "/")
    logger.info('URL request is {}'.format(cmd))
    # Send command to fw and see if it times out or we get a response
    count = 0
    max_count = 15
    while True:
        if count < max_count:
            try:
                count = count + 1
                urllib.request.urlopen(cmd, data=None, timeout=5).read()

            except urllib.error.URLError:
                logger.info("[INFO]: No response from FW. Wait 60 secs before retry")
                time.sleep(30)
                continue
            except urllib.error.HTTPError as e:
                # Return code error (e.g. 404, 501, ...)
                logger.info('Jenkins Server Returned HTTPError: {}'.format(e.code))
                time.sleep(30)
            except Exception as e:
                logger.info('Got generic exceptiomn {}'.format(e))

            else:
                logger.info('Jenkins Server responded with HTTP 200 code')
                return ('server_up')
        else:
            break
    return ('server_down')


def main(username, password, aws_access_key, aws_secret_key, aws_region, ec2_key_pair, bootstrap_bucket):
    username = username
    password = password
    aws_access_key = aws_access_key
    aws_secret_key = aws_secret_key
    aws_region = aws_region
    ec2_key_pair = ec2_key_pair
    albDns = ''
    nlbDns = ''
    fwMgt = ''

    default_vars = {
        'aws_access_key': aws_access_key,
        'aws_secret_key': aws_secret_key,
        'aws_region': aws_region
    }

    WebInDeploy_vars = {
        'aws_access_key': aws_access_key,
        'aws_secret_key': aws_secret_key,
        'aws_region': aws_region,
        'ServerKeyName': ec2_key_pair,
        'bootstrap_s3bucket': bootstrap_bucket
    }

    waf_conf_vars = {
        'aws_access_key': aws_access_key,
        'aws_secret_key': aws_secret_key,
        'aws_region': aws_region,
        'ServerKeyName': ec2_key_pair,
        'alb_arn': albDns,
        'nlb-dns': nlbDns
    }

    WebInFWConf_vars = {
        'aws_access_key': aws_access_key,
        'aws_secret_key': aws_secret_key,
        'aws_region': aws_region,
        'ServerKeyName': ec2_key_pair,
        'mgt-ipaddress-fw1': fwMgt,
        'nlb-dns': nlbDns,
        'username': username,
        'password': password
    }

    # Set run_plan to TRUE is you wish to run terraform plan before apply
    run_plan = False
    deployment_status = {}
    kwargs = {"auto-approve": True}

    # Class Terraform uses subprocess and setting capture_output to True will capture output
    # capture_output = kwargs.pop('capture_output', True)

    # if capture_output is True:
    #     stderr = subprocess.PIPE
    #     stdout = subprocess.PIPE
    # else:
    #     stderr = sys.stderr
    #     stdout = sys.stdou

    # Build Infrastructure

    tf = Terraform(working_dir='./WebInDeploy')

    tf.cmd('init')
    if run_plan:
        # print('Calling tf.plan')
        tf.plan(capture_output=False, var=WebInDeploy_vars)

    # return_code1, stdout, stderr = tf.apply(var=WebInDeploy_vars, capture_output=True, skip_plan=True, **kwargs)

    web_in_deploy_output = tf.output()

    print(type(web_in_deploy_output))

    print('='*80)
    # write_status_file({'webindeploy_stdout', stdout})
    # write_status_file({'webindeploy_stderr', stderr})
    status_out = dict()
    status_out['webindepoy'] = web_in_deploy_output
    write_status_file(status_out)

    # return_code1 = 0
    # logger.debug('Got Return code for deploy WebInDeploy {}'.format(return_code1))

    # if return_code1 != 0:
    #     logger.info("WebInDeploy failed")
    #     deployment_status = {'WebInDeploy': 'Fail'}
    #     write_status_file(deployment_status)
    #     exit()
    # else:
    #     deployment_status = {'WebInDeploy': 'Success'}
    #     write_status_file(deployment_status)

    albDns = tf.output('ALB-DNS')
    fwMgt = tf.output('MGT-IP-FW-1')
    nlbDns = tf.output('NLB-DNS')
    fw_trust_ip = fwMgt

    #
    # Apply WAF Rules
    #

    tf = Terraform(working_dir='./waf_conf')
    tf.cmd('init')
    kwargs = {"auto-approve": True}
    logger.info("Applying WAF config to App LB")
    vars = WebInDeploy_vars.update({'alb_arn': albDns, 'nlb-dns': nlbDns})
    if run_plan:
        tf.plan(capture_output=False, var=vars, **kwargs)
    # return_code3, stdout, stderr = tf.apply(capture_output=True, skip_plan=True,
    #                                         var=waf_conf_vars, **kwargs)

    waf_conf_out = tf.output()

    # write_status_file({'waf_conf_stdout', stdout})
    # write_status_file({'waf_conf_stderr', stderr})
    status_out = dict()
    status_out['waf_conf_output'] = waf_conf_out
    write_status_file(status_out)

    # logger.debug('Got Return code to deploy waf_conf {}'.format(return_code3))

    # if return_code3 != 0:
    #     logger.info("waf_conf failed")
    #     deployment_status.update({'waf_conf': 'Fail'})
    #     write_status_file(deployment_status)
    #     exit()
    # else:
    #     deployment_status.update({'waf_conf': 'Success'})
    #     write_status_file(deployment_status)

    logger.info("Got these values from output of first run\n\n")
    logger.info("ALB address is {}".format(albDns))
    logger.info("nlb address is {}".format(nlbDns))
    logger.info("Firewall Mgt address is {}".format(fwMgt))

    #
    # Check firewall is up and running
    # #

    api_key = getApiKey(fw_trust_ip, username, password)

    # while True:
    #     err = getFirewallStatus(fw_trust_ip, api_key)
    #     if err == 'cmd_error':
    #         logger.info("Command error from fw ")
    #
    #     elif err == 'no':
    #         logger.info("FW is not up...yet")
    #         print("FW is not up...yet")
    #         time.sleep(60)
    #         continue
    #
    #     elif err == 'almost':
    #         logger.info("MGT up waiting for dataplane")
    #         time.sleep(20)
    #         continue
    #
    #     elif err == 'yes':
    #         logger.info("FW is up")
    #         break

    fw = firewall.Firewall(hostname=fw_trust_ip, api_username=username, api_password=password)
    logger.info("Updating firewall with latest content pack")
    updateHandle = updater.ContentUpdater(fw)

    updateHandle.download(fw)
    logger.info("Waiting 3 minutes for content update to download")
    time.sleep(210)
    updateHandle.install()

    #
    # Configure Firewall
    #

    tf = Terraform(working_dir='./WebInFWConf')
    tf.cmd('init')
    kwargs = {"auto-approve": True}

    logger.info("Applying addtional config to firewall")

    if run_plan:
        tf.plan(capture_output=False, var=WebInFWConf_vars)

    return_code2, stdout, stderr = tf.apply(capture_output=True, skip_plan=True,
                                            var={'mgt-ipaddress-fw1': fwMgt, 'nlb-dns': nlbDns}, **kwargs)

    web_in_fw_conf_out = tf.output()

    print(web_in_fw_conf_out)

    # write_status_file({'web_in_conf_apply_out', stdout})

    # status_out = dict()
    # status_out['web_in_conf_outputs'] = web_in_fw_conf_out
    # write_status_file(status_out)

    logger.debug('Got Return code for deploy WebInFwConf {}'.format(return_code2))

    if return_code2 != 0:
        logger.info("WebFWConfy failed")
        deployment_status.update({'WebFWConfy': 'Fail'})
        write_status_file(deployment_status)
        exit()
    else:
        deployment_status.update({'WebFWConf': 'Success'})
        write_status_file(deployment_status)

    logger.info("Commit changes to firewall")

    fw.commit()
    logger.info("waiting for commit")
    time.sleep(60)
    logger.info("waiting for commit")

    #
    # Check Jenkins
    #

    logger.info('Checking if Jenkins Server is ready')

    # FIXME - add outputs for all 3 dirs

    res = getServerStatus(albDns)

    if res == 'server_up':
        logger.info('Jenkins Server is ready')
        logger.info('\n\n   ### Deployment Complete ###')
        logger.info('\n\n   Connect to Jenkins Server at http://{}'.format(albDns))
    else:
        logger.info('Jenkins Server is down')
        logger.info('\n\n   ### Deployment Complete ###')

    # FIXME - add function to dump out status file to stdout (print())

    print(status_output)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Get Terraform Params')
    parser.add_argument('-u', '--username', help='Firewall Username', required=True)
    parser.add_argument('-p', '--password', help='Firewall Password', required=True)
    parser.add_argument('-k', '--aws_access_key', help='AWS Key', required=True)
    parser.add_argument('-s', '--aws_secret_key', help='AWS Secret', required=True)
    parser.add_argument('-r', '--aws_region', help='AWS Region', required=True)
    parser.add_argument('-c', '--aws_key_pair', help='AWS EC2 Key Pair', required=True)
    parser.add_argument('-b', '--s3_bootstrap_bucket', help='AWS S3 Bootstrap bucket', required=True)

    args = parser.parse_args()
    username = args.username
    password = args.password
    aws_access_key = args.aws_access_key
    aws_secret_key = args.aws_secret_key
    aws_region = args.aws_region
    ec2_key_pair = args.aws_key_pair
    bootstrap_s3bucket = args.s3_bootstrap_bucket

    main(username, password, aws_access_key, aws_secret_key, aws_region, ec2_key_pair, bootstrap_s3bucket)
