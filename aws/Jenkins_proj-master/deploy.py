#!/usr/bin/env python3
"""
Paloaltonetworks Deploy_Jenkins_Hack_Demo.py

This software is provided without support, warranty, or guarantee.
Use at your own risk.
"""

'''
Outputs to file deployment_status

Contents of json dict

{"WebInDeploy": "Success", "WebInFWConf": "Success", "waf_conf": "Success"}
'''

import logging
import ssl
import urllib
import xml.etree.ElementTree as et
import xml
import time
import argparse
import json
import sys

from pandevice import firewall
from pandevice import updater
from  python_terraform import Terraform

gcontext = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)


#logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger()
handler = logging.StreamHandler()
formatter = logging.Formatter('%(levelname)-8s %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.INFO)

aws_access_key = 'AKIAIM562M6SMYAYRXBQ'
aws_secret_key = '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'





def getApiKey(hostname,username, password):
    '''Generate the API key from username / password
    '''

    data = {
        'type' : 'keygen',
        'user' : username,
        'password' : password
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
            logger.info("[INFO]: No response from FW. Wait 60 secs before retry")
            time.sleep(60)
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

    cmd = urllib.request.Request("https://" + fwMgtIP + "/api/?type=op&cmd=<show><chassis-ready></chassis-ready></show>&key=" + api_key)
    # Send command to fw and see if it times out or we get a response
    logger.info("Sending command 'show chassis status' to firewall")
    try:
        response = urllib.request.urlopen(cmd, data=None, context=gcontext, timeout=5).read()

    except urllib.error.URLError:
        logger.debug("No response from FW. So maybe not up!")
        return 'no'
        #sleep and check again?
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

def write_status_file(dict):

    out = json.dumps(dict)
    f = open("./deployment_status.json", "w")
    f.write(out)
    f.close()


def getServerStatus(IP) :
    """
    Gets the firewall status by sending the API request show chassis status.
    :param fwMgtIP:  IP Address of firewall interface to be probed
    :param api_key:  Panos API key
    """
    global gcontext

    cmd = urllib.request.Request("http://" + IP + "/")
    # Send command to fw and see if it times out or we get a response

    try:
        response = urllib.request.urlopen(cmd, data=None, timeout=5).read()
    except urllib.error.HTTPError as e:
        # Return code error (e.g. 404, 501, ...)
        logger.info('Jenkins Server Returned HTTPError: {}'.format(e.code))
        return ('server_down')
    except urllib.error.URLError as e:
        # Not an HTTP-specific error (e.g. connection refused)
        logger.info('Jenkins Server Did not respond to HTTP request: {}'.format(e.reason))
        return ('server_down')
    except Exception as e:
                logger.info('Got generic exceptiomn {}'.format(e))
    else:
        # 200
        logger.info('Jenkins Server responded with HTTP 200 code')
        return ('server_up')


def main(fwUsername, fwPasswd):

    albDns = ''
    nlbDns = ''
    fwMgt = ''

    # Set run_plan to TRUE is you wish to run terraform plan before apply
    run_plan = False
    deployment_status = {}
    kwargs = {"auto-approve": True}

    # Class Terraform uses subprocess and setting capture_output to True will capture output
    # capture_output = kwargs.pop('capture_output', True)
    #
    # if capture_output is True:
    #     stderr = subprocess.PIPE
    #     stdout = subprocess.PIPE
    # else:
    #     stderr = sys.stderr
    #     stdout = sys.stdout

    #
    # Build Infrastructure
    #




    tf = Terraform(working_dir='./WebInDeploy')
    tf.cmd('init')
    if run_plan:
        print('Calling tf.plan')
        tf.plan(capture_output=False)


    return_code1, stdout, stderr = tf.apply(capture_output=False,skip_plan=True,**kwargs)
    #return_code1 =0
    print('Got return code {}'.format(return_code1))

    if return_code1 != 0:
        logger.info("WebInDeploy failed")
        deployment_status = {'WebInDeploy': 'Fail'}
        write_status_file(deployment_status)
        exit()
    else:
        deployment_status = {'WebInDeploy':'Success'}
        write_status_file(deployment_status)




    albDns = tf.output('ALB-DNS')
    fwMgt = tf.output('MGT-IP-FW-1')
    nlbDns = tf.output('NLB-DNS')
    # fwUsername = "admin"
    # fwPasswd = "PaloAlt0!123!!"
    fw_trust_ip = fwMgt

    #
    # Apply WAF Rules
    #

    tf = Terraform(working_dir='./waf_conf')
    tf.cmd('init')
    kwargs = {"auto-approve": True }

    logger.info("Applying WAF config to App LB")

    if run_plan:
        tf.plan(capture_output=False,var={'alb_arn':nlbDns},**kwargs)

    return_code3, stdout, stderr = tf.apply(capture_output=False,skip_plan=True,var={'alb_arn':nlbDns,'int-nlb-fqdn':nlbDns},**kwargs)

    if return_code3 != 0:
        logger.info("waf_conf failed")
        deployment_status.update({'waf_conf': 'Fail'})
        write_status_file(deployment_status)
        exit()
    else:
        deployment_status.update({'waf_conf': 'Success'})
        write_status_file(deployment_status)

    logger.info("Got these values from output of first run\n\n")
    logger.info("ALB address is {}".format(albDns))
    logger.info("nlb address is {}".format(nlbDns))
    logger.info("Firewall Mgt address is {}".format(fwMgt))

    #
    # Check firewall is up and running
    #


    class FWNotUpException(Exception):
        pass
    err = 'no'
    api_key =''
    api_key = getApiKey(fw_trust_ip,fwUsername,fwPasswd)

    while True:
        err = getFirewallStatus(fw_trust_ip,api_key)
        if err == 'cmd_error':
            logger.info("Command error from fw ")
            #raise FWNotUpException('FW is not up!  Request Timeout')

        elif err == 'no':
            logger.info("FW is not up...yet")
            print("FW is not up...yet")
            time.sleep(60)
            continue
            #raise FWNotUpException('FW is not up!')
        elif err == 'almost':
            logger.info("MGT up waiting for dataplane")
            time.sleep(20)
            continue
        elif err == 'yes':
            logger.info("[INFO]: FW is up")
            break

    fw = firewall.Firewall(hostname=fw_trust_ip,api_username=fwUsername,api_password=fwPasswd)
    logger.info("Updating firewall with latest content pack")
    updateHandle = updater.ContentUpdater(fw)

    updateHandle.download()

    logger.info("Waiting 3 minutes for content update to download")
    time.sleep(210)
    updateHandle.install()



    #
    # Configure Firewall
    #

    tf = Terraform(working_dir='./WebInFWConf')
    tf.cmd('init')
    kwargs = {"auto-approve": True }

    logger.info("Applying addtional config to firewall")

    if run_plan:
        tf.plan(capture_output=False,var={'mgt-ipaddress-fw1':fwMgt, 'int-nlb-fqdn':nlbDns})

    return_code2, stdout, stderr = tf.apply(capture_output=False,skip_plan=True,var={'mgt-ipaddress-fw1':fwMgt, 'nlb-dns':nlbDns,'aws_access_key':aws_access_key,'aws_secret_key':aws_secret_key},**kwargs)
    #return_code2 = 0
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

    logger.info('Checking if Jenkins Server is ready')

#    tf = Terraform(working_dir='./WebInDeploy')
#   albDns = tf.output('ALB-DNS')
    count = 0
    max_tries = 3
    while True:
        if count < max_tries:
            res =getServerStatus(albDns)
            if res == 'server_down':
                count = count + 1
                time.sleep(2)
                continue
            elif res == 'server_up':
                break
        else:
            break
    logger.info('Jenkins Server is ready')
    logger.info('\n\n   ### Deployment Complete ###')
    logger.info('\n\n   Connect to Jenkins Server at http://{}'.format(albDns))


if __name__ == '__main__':


    main(sys.argv[1], sys.argv[2])









