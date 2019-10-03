#!/usr/bin/env python3
"""
# Copyright (c) 2018, Palo Alto Networks
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# Author: Justin Harris jharris@paloaltonetworks.com

Usage

python deploy.py -u <fwusername> -p'<fwpassword> -k <aws_key> -s <aws_secret> -r <aws_region>
"""
import argparse
import json
import logging
import ssl
import subprocess
import sys
import time
import xml.etree.ElementTree as ET
import shutil
import pathlib
import os

import requests

import urllib3
import xmltodict

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

from pandevice import firewall
from collections import OrderedDict
from python_terraform import Terraform


gcontext = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)


logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s %(name)-12s %(levelname)-8s %(message)s',
                        datefmt='%m-%d %H:%M',
                        filename='deploy.log',
                        filemode='w')

console = logging.StreamHandler()
console.setLevel(logging.INFO)

formatter = logging.Formatter('%(name)-12s: %(levelname)-8s %(message)s')

console.setFormatter(formatter)
logging.getLogger('').addHandler(console)
logger = logging.getLogger(__name__)



# global var to keep status output
status_output = dict()

def replace_string_in_file(filepath, old_string, new_string):
    with open(filepath, 'r') as file:
        filedata = file.read()

    # Replace the target string
    filedata = filedata.replace(old_string, new_string)

    # Write the file out again
    with open(filepath, 'w') as file:
        file.write(filedata)

def move_file(src_file, dest_file):
    """

    :param src_file:
    :param dest_file:
    :return:
    """
    logger.info('Moving file {} to {}'.format(src_file,dest_file))
    try:
        shutil.copy(src_file, dest_file)
        return True
    except IOError as e:
        logger.info("Unable to copy file got error {}".format(e))
        return


def send_request(call):
    """
    Handles sending requests to API
    :param call: url
    :return: Retruns result of call. Will return response for codes between 200 and 400.
             If 200 response code is required check value in response
    """
    headers = {'Accept-Encoding': 'None', 'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'}

    try:
        r = requests.get(call, headers=headers, verify=False, timeout=5)
        r.raise_for_status()
    except requests.exceptions.HTTPError as errh:
        '''
        Firewall may return 5xx error when rebooting.  Need to handle a 5xx response 
        '''
        logger.debug("DeployRequestException Http Error:")
        raise DeployRequestException("Http Error:")
    except requests.exceptions.ConnectionError as errc:
        logger.debug("DeployRequestException Connection Error:")
        raise DeployRequestException("Connection Error")
    except requests.exceptions.Timeout as errt:
        logger.debug("DeployRequestException Timeout Error:")
        raise DeployRequestException("Timeout Error")
    except requests.exceptions.RequestException as err:
        logger.debug("DeployRequestException RequestException Error:")
        raise DeployRequestException("Request Error")
    else:
        return r


class DeployRequestException(Exception):
    pass



def walkdict(dict, match):
    """
    Finds a key in a dict or nested dict and returns the value associated with it
    :param d: dict or nested dict
    :param key: key value
    :return: value associated with key
    """
    for key, v in dict.items():
        if key == match:
            jobid = v
            return jobid
        elif isinstance(v, OrderedDict):
            found = walkdict(v, match)
            if found is not None:
                return found



def check_pending_jobs(fwMgtIP, api_key):
    type = "op"
    cmd = "<show><jobs><all></all></jobs></show>"
    call = "https://%s/api/?type=%s&cmd=%s&key=%s" % (fwMgtIP, type, cmd, api_key)
    key = 'result'
    jobs = ''
    try:
        r = send_request(call)
        logger.info('Got response {} to request for content upgrade '.format(r.text))
        dict = xmltodict.parse(r.text)
        if isinstance(dict, OrderedDict):
            jobs = walkdict(dict, key)
        else:
            logger.info('Didnt get a dict')
        if not jobs:
            # No jobs pending
            return False
        else:
            # Jobs pending
            return True

    except:
        logger.info('Didnt get response to check pending jobs')
        return False


def update_fw(fwMgtIP, api_key):
    """
    Applies latest AppID, Threat and AV updates to firewall after launch
    :param fwMgtIP: Firewall management IP
    :param api_key: API key

    """
    # # Download latest applications and threats

    type = "op"
    cmd = "<request><content><upgrade><download><latest></latest></download></upgrade></content></request>"
    call = "https://%s/api/?type=%s&cmd=%s&key=%s" % (fwMgtIP, type, cmd, api_key)
    getjobid = 0
    jobid = ''
    key = 'job'

    # FIXME - Remove Duplicate code for parsing jobid

    while getjobid == 0:
        try:
            r = send_request(call)
            logger.info('Got response {} to request for content upgrade '.format(r.text))
        except:
            DeployRequestException
            logger.info("Didn't get http 200 response.  Try again")
        else:
            try:
                dict = xmltodict.parse(r.text)
                if isinstance(dict, OrderedDict):
                    jobid = walkdict(dict, key)
            except Exception as err:
                logger.info("Got exception {} trying to parse jobid from Dict".format(err))
            if not jobid:
                logger.info('Got http 200 response but didnt get jobid')
                time.sleep(30)
            else:
                getjobid = 1

    # FIXME - Remove Duplicate code for showing job status

    completed = 0
    while (completed == 0):
        time.sleep(45)
        call = "https://%s/api/?type=op&cmd=<show><jobs><id>%s</id></jobs></show>&key=%s" % (fwMgtIP, jobid, api_key)
        try:
            r = send_request(call)
            logger.info('Got Response {} to show jobs '.format(r.text))
        except:
            DeployRequestException
            logger.debug("failed to get jobid this time.  Try again")
        else:
            tree = ET.fromstring(r.text)
            if tree.attrib['status'] == 'success':
                try:
                    if (tree[0][0][5].text == 'FIN'):
                        logger.debug("APP+TP download Complete ")
                        completed = 1
                    print("Download latest Applications and Threats update")
                    status = "APP+TP download Status - " + str(tree[0][0][5].text) + " " + str(
                        tree[0][0][12].text) + "% complete"
                    print('{0}\r'.format(status))
                except:
                    logger.info('Checking job is complete')
                    completed = 1
            else:
                logger.info('Unable to determine job status')
                completed = 1

    # Install latest content update
    type = "op"
    cmd = "<request><content><upgrade><install><version>latest</version><commit>no</commit></install></upgrade></content></request>"
    call = "https://%s/api/?type=%s&cmd=%s&key=%s" % (fwMgtIP, type, cmd, api_key)
    getjobid = 0
    jobid = ''
    key = 'job'

    while getjobid == 0:
        try:
            r = send_request(call)
            logger.info('Got response {} to request for content upgrade '.format(r.text))
        except:
            DeployRequestException
            logger.info("Didn't get http 200 response.  Try again")
        else:
            try:
                dict = xmltodict.parse(r.text)
                if isinstance(dict, OrderedDict):
                    jobid = walkdict(dict, key)
            except Exception as err:
                logger.info("Got exception {} trying to parse jobid from Dict".format(err))
            if not jobid:
                logger.info('Got http 200 response but didnt get jobid')
                time.sleep(30)
            else:
                getjobid = 1

    completed = 0
    while (completed == 0):
        time.sleep(45)
        call = "https://%s/api/?type=op&cmd=<show><jobs><id>%s</id></jobs></show>&key=%s" % (fwMgtIP, jobid, api_key)
        try:
            r = send_request(call)
            logger.info('Got Response {} to show jobs '.format(r.text))
        except:
            DeployRequestException
            logger.debug("failed to get jobid this time.  Try again")
        else:
            tree = ET.fromstring(r.text)
            if tree.attrib['status'] == 'success':
                try:
                    if (tree[0][0][5].text == 'FIN'):
                        logger.debug("APP+TP Install Complete ")
                        completed = 1
                    print("Install latest Applications and Threats update")
                    status = "APP+TP Install Status - " + str(tree[0][0][5].text) + " " + str(
                        tree[0][0][12].text) + "% complete"
                    print('{0}\r'.format(status))
                except:
                    logger.info('Checking job is complete')
                    completed = 1
            else:
                logger.info('Unable to determine job status')
                completed = 1


    # Download latest anti-virus update without committing
    getjobid = 0
    jobid = ''
    type = "op"
    cmd = "<request><anti-virus><upgrade><download><latest></latest></download></upgrade></anti-virus></request>"
    key = 'job'
    while getjobid == 0:
        try:
            call = "https://%s/api/?type=%s&cmd=%s&key=%s" % (fwMgtIP, type, cmd, api_key)
            r = send_request(call)
            logger.info('Got response to request AV install {}'.format(r.text))
        except:
            DeployRequestException
            logger.info("Didn't get http 200 response.  Try again")
        else:
            try:
                dict = xmltodict.parse(r.text)
                if isinstance(dict, OrderedDict):
                    jobid = walkdict(dict, key)
            except Exception as err:
                logger.info("Got exception {} trying to parse jobid from Dict".format(err))
            if not jobid:
                logger.info('Got http 200 response but didnt get jobid')
                time.sleep(30)
            else:
                getjobid = 1

    completed = 0
    while (completed == 0):
        time.sleep(45)
        call = "https://%s/api/?type=op&cmd=<show><jobs><id>%s</id></jobs></show>&key=%s" % (
            fwMgtIP, jobid, api_key)
        r = send_request(call)
        tree = ET.fromstring(r.text)
        logger.debug('Got response for show job {}'.format(r.text))
        if tree.attrib['status'] == 'success':
            try:
                if (tree[0][0][5].text == 'FIN'):
                    logger.info("AV install Status Complete ")
                    completed = 1
                else:
                    status = "Status - " + str(tree[0][0][5].text) + " " + str(tree[0][0][12].text) + "% complete"
                    print('{0}\r'.format(status))
            except:
                logger.info('Could not parse output from show jobs, with jobid {}'.format(jobid))
                completed = 1
        else:
            logger.info('Unable to determine job status')
            completed = 1


def getApiKey(hostname, username, password):
    '''
    Generate the API key from username / password
    '''

    call = "https://%s/api/?type=keygen&user=%s&password=%s" % (hostname, username, password)

    api_key = ""
    while True:
        try:
            # response = urllib.request.urlopen(url, data=encoded_data, context=ctx).read()
            response = send_request(call)


        except DeployRequestException as updateerr:
            logger.info("No response from FW. Wait 30 secs before retry")
            time.sleep(30)
            continue

        else:
            api_key = ET.XML(response.content)[0][0].text
            logger.info("FW Management plane is Responding so checking if Dataplane is ready")
            logger.debug("Response to get_api is {}".format(response))
            return api_key


def getFirewallStatus(fwIP, api_key):
    fwip = fwIP

    """
    Gets the firewall status by sending the API request show chassis status.
    :param fwMgtIP:  IP Address of firewall interface to be probed
    :param api_key:  Panos API key
    """
    global gcontext

    url = "https://%s/api/?type=op&cmd=<show><chassis-ready></chassis-ready></show>&key=%s" % (fwip, api_key)
    # Send command to fw and see if it times out or we get a response
    logger.info("Sending command 'show chassis status' to firewall")
    try:
        response = requests.get(url, verify=False, timeout=10)
        response.raise_for_status()
    except requests.exceptions.Timeout as fwdownerr:
        logger.debug("No response from FW. So maybe not up!")
        return 'no'
        # sleep and check again?
    except requests.exceptions.HTTPError as fwstartgerr:
        '''
        Firewall may return 5xx error when rebooting.  Need to handle a 5xx response
        raise_for_status() throws HTTPError for error responses 
        '''
        logger.infor("Http Error: {}: ".format(fwstartgerr))
        return 'cmd_error'
    except requests.exceptions.RequestException as err:
        logger.debug("Got RequestException response from FW. So maybe not up!")
        return 'cmd_error'
    else:
        logger.debug("Got response to 'show chassis status' {}".format(response))

        resp_header = ET.fromstring(response.content)
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


def update_status(key, value):
    global status_output

    if type(status_output) is not dict:
        logger.info('Creating new status_output object')
        status_output = dict()

    if key is not None and value is not None:
        status_output[key] = value

    # write status to file to future tracking
    write_status_file(status_output)


def write_status_file(message_dict):
    """
    Writes the deployment state to a dict and outputs to file for status tracking
    """
    try:
        message_json = json.dumps(message_dict)
        with open('deployment_status.json', 'w+') as dpj:
            dpj.write(message_json)

    except ValueError as ve:
        logger.error('Could not write status file!')
        print('Could not write status file!')
        sys.exit(1)


def getServerStatus(IP):
    """
    Gets the server status by sending an HTTP request and checking for a 200 response code
    """
    global gcontext

    call = ("http://" + IP + "/")
    # Send command to fw and see if it times out or we get a response
    count = 0
    max_count = 15
    while True:
        if count < max_count:
            try:
                count = count + 1
                r = send_request(call)
            except DeployRequestException as e:
                logger.debug("Got Invalid response".format(e))
            else:
                return 'server_up'
        else:
            break
    return 'server_down'


def apply_tf(working_dir, vars, description):
    """
    Handles terraform operations and returns variables in outputs.tf as a dict.
    :param working_dir: Directory that contains the tf files
    :param vars: Additional variables passed in to override defaults equivalent to -var
    :param description: Description of the deployment for logging purposes
    :return:    return_code - 0 for success or other for failure
                outputs - Dictionary of the terraform outputs defined in the outputs.tf file

    """
    # Set run_plan to TRUE is you wish to run terraform plan before apply
    run_plan = False
    kwargs = {"auto-approve": True}

    # Class Terraform uses subprocess and setting capture_output to True will capture output
    capture_output = kwargs.pop('capture_output', False)

    if capture_output is True:
        stderr = subprocess.PIPE
        stdout = subprocess.PIPE
    else:
        # if capture output is False, then everything will essentially go to stdout and stderrf
        stderr = sys.stderr
        stdout = sys.stdout

    start_time = time.asctime()
    print('Starting Deployment at {}\n'.format(start_time))

    # Create Bootstrap

    tf = Terraform(working_dir=working_dir)

    tf.cmd('init')
    if run_plan:
        # print('Calling tf.plan')
        tf.plan(capture_output=False)

    return_code, stdout, stderr = tf.apply(vars=vars, capture_output=capture_output,
                                           skip_plan=True, **kwargs)
    outputs = tf.output()

    logger.debug('Got Return code {} for deployment of  {}'.format(return_code, description))

    return (return_code, outputs)

def get_twistlock_console_status(mgt_ip,timeout = 5):

    url = 'https://' + mgt_ip + ':8083/api/v1/_ping'

    max_count = 30
    count = 0
    while True:
        count = count + 1
        time.sleep(30)
        if count < max_count:
            try:
                response = requests.get(url, verify=False, timeout=timeout)
                if response.status_code == 200:
                    return True
                elif response.status_code == 400:
                    return True
            except requests.exceptions.RequestException as err:
                print("General Error", err)
        else:
            return

def twistlock_signup(mgt_ip,username,password,timeout = 5):

    # $ curl - k \
    #   - H
    # 'Content-Type: application/json' \
    # - X
    # POST \
    # - d
    # '{"username": "butterbean", "password": "<PASSWORD>"}' \
    #         https: // < CONSOLE >: 8083 / api / v1 / signup
    url = 'https://' + mgt_ip + ':8083/api/v1/signup'
    payload = {
        "username": username,
        "password": password
    }
    payload = json.dumps(payload)
    headers = {'Content-Type': 'application/json'}
    max_count = 30
    count = 0
    while True:
        count = count + 1
        if count < max_count:
            try:
                response = requests.post(url, data=payload, headers=headers, verify=False, timeout=timeout)
                if response.status_code == 200:
                    return 'Success'
                elif response.status_code == 400:
                    return 'Already initialised'
            except requests.exceptions.RequestException as err:
                print("General Error", err)
        else:
            return



def twistlock_get_auth_token(mgt_ip,username,password,timeout = 5):
    """
    Generates the twistlock auth token for use in future requests
    """
    url = 'https://' + mgt_ip + ':8083/api/v1/authenticate'
    payload = {
        "username": username,
        "password": password
    }
    headers = {'Content-Type': 'application/json'}
    try:
        payload = json.dumps(payload)
        response = requests.post(url, data=payload, headers=headers, verify=False, timeout = timeout)
        response.raise_for_status()
        if response.status_code == 200:
            data = response.json()
            logger.info('Successfully generated auth token')
            return data.get('token')
    except requests.exceptions.HTTPError as err:
        logger.info('HTTP Error {}'.format(err))
        return
    except requests.exceptions.Timeout as errt:
        logger.info('Timeout Error {}'.format(errt))
        return
    except requests.exceptions.RequestException as err:
        logger.info("General Error", err)
        return

def twistlock_add_license(mgt_ip,token,license, timeout = 5):
    """Adds the license key to Twistlock console"""
    url = 'https://' + mgt_ip + ':8083/api/v1/settings/license'
    payload = {"key": license}
    Bearer = "Bearer " + token
    headers = {'Content-Type': 'application/json',
               'Authorization': Bearer }
    logger.info('Url is {}\n Payload is {}\n Headers is{}'.format(url,payload,headers))
    try:
        payload = json.dumps(payload)
        response = requests.post(url, data=payload, headers=headers, verify=False, timeout = timeout)
        response.raise_for_status()
        if response.status_code == 200:
            logger.info('Successfully added license')
            return 'Success'
    except requests.exceptions.HTTPError as err:
        logger.info('HTTP Error {}'.format(err))
        return
    except requests.exceptions.Timeout as errt:
        logger.info('Timeout Error {}'.format(errt))
        return
    except requests.exceptions.RequestException as err:
        logger.info("General Error", err)
        return

def get_twistlock_policy_from_console(mgt_ip, token, timeout = 5):
    """
    Retrieves existing container policy as a list.
    In order to update policies first download as a list and insert reomve
    lines of policy

    """
    url = 'https://' + mgt_ip + ':8083/api/v1/policies/runtime/container'


    Bearer = "Bearer " + token
    headers = {'Content-Type': 'application/json',
               'Authorization': Bearer}
    try:
        response = requests.get(url, headers= headers, verify=False, timeout=timeout)
        if response.status_code == 200:
            return response.content
        elif response.status_code == 400:
            return
    except requests.exceptions.RequestException as err:
        print("General Error", err)

def get_twistlock_policy_from_file(filename):
    """
    loads the Jenkins policy from file:
    """
    with open(filename) as file:
        json_rule = json.loads(file.read())

        return(json_rule)

def update_twistlock_policy(mgt_ip, token, policy, timeout=5):
    """
    Use put operation to update teh policy on the server
    """
    url = 'https://' + mgt_ip + ':8083/api/v1/policies/runtime/container'
    data = policy

    Bearer = "Bearer " + token
    headers = {'Content-Type': 'application/json',
               'Authorization': Bearer}
    try:
        response = requests.put(url, headers=headers, data=json.dumps(data), verify=False, timeout=timeout)
        if response.status_code == 200:
            return True
        else:
            return
    except requests.exceptions.RequestException as err:
        return

def check_http_link(path):
    """
    Checks that the URL is valid
    """
    r = requests.head(path)
    return r.status_code == requests.codes.ok


def main(username, password, aws_access_key, aws_secret_key, aws_region, ec2_key_pair, twistlock_license_key, cdn_url):
    username = username
    password = password
    aws_access_key = aws_access_key
    aws_secret_key = aws_secret_key
    aws_region = aws_region
    ec2_key_pair = ec2_key_pair
    albDns = ''
    nlbDns = ''
    fwMgtIP = ''

    WebInDeploy_vars = {
        'aws_access_key': aws_access_key,
        'aws_secret_key': aws_secret_key,
        'aws_region': aws_region,
        'ServerKeyName': ec2_key_pair
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
        'mgt-ipaddress-fw1': fwMgtIP,
        'nlb-dns': nlbDns,
        'username': username,
        'password': password
    }
    WebServerDeploy = {}


    # # Set run_plan to TRUE is you wish to run terraform plan before apply

    run_plan = True

    kwargs = {"auto-approve": True}



    #   File constants.
    #   We are using template files for the webserver instance and console.
    #   At the start of the run we copy the template file to the tf and then populate values with string replacement
    #   Ensures that on each run we can update the tf file with latest input parameters

    console_filename = './TwistlockDeploy/console-instance.tf'
    console_template = './TwistlockDeploy/console-instance.templ'
    webservers_filename = './WebInDeploy/webservers.tf'
    webservers_with_console_template = './WebInDeploy/webservers-with-console.templ'
    webservers_template = './TwistlockDeploy/webservers.templ'
    jenkins_policy_filename = './TwistlockDeploy/twistlock_rule.js'

    #
    #   Are we deploying Twistlock on this run?
    #   Do we have a license string and a reachable link?
    #



    if twistlock_license_key and cdn_url:

        if check_http_link(cdn_url):
            logger.info('Link to tar file is valid. Lets continue')
        else:
            logger.info('The specified link to the Twistlock install software is not reachable')
            sys.exit(1)

        TwistlockDeploy_vars = {
            'aws_access_key': aws_access_key,
            'aws_secret_key': aws_secret_key,
            'aws_region': aws_region,
            'ServerKeyName': ec2_key_pair
        }

        #
        # Setup the install script again
        # Runs every time to pick up new version of code if required.
        #

        string_to_match = '<cdn-url>'
        fcopy1=move_file(console_template, console_filename)
        fcopy2=move_file(webservers_with_console_template, webservers_filename)

        if fcopy1 and fcopy2:
            logger.info('Created new console and webserver tf files')
        else:
            logger.info('Unable to create new console.tf and webservers.tf files')
            sys.exit(1)


        replace_string_in_file(console_filename, string_to_match, cdn_url)

        return_code, console_deploy_output = apply_tf('./TwistlockDeploy', TwistlockDeploy_vars, 'TwistlockDeploy')

        logger.debug('Got Return code for deploy TwistlockDeploy {}'.format(return_code))

        # update_status('web_in_deploy_stdout', stdout)
        update_status('console_deploy_output', console_deploy_output)

        if return_code == 0:
            update_status('console_deploy_output', 'success')
            console_mgt_ip = console_deploy_output['CONSOLE-MGT']['value']

            #
            # Replace cdn url in console setup file with latest version
            #
        #
        # Setup Twistlock Console
        #
        if get_twistlock_console_status(console_mgt_ip):
            # Create initial user account
            twistlock_signup(console_mgt_ip, username, password)
            # Generate auth token from credentials
            token = twistlock_get_auth_token(console_mgt_ip, username, password)
            # Add license key
            license_add_response = twistlock_add_license(console_mgt_ip, token, twistlock_license_key)
            # Download container policy from console

            jenkins_policy = get_twistlock_policy_from_file(jenkins_policy_filename)

            # Upload additional Jenkins policy to server
            update_twistlock_policy(console_mgt_ip, token, jenkins_policy)

        else:
            sys.exit(1)

        if license_add_response == 'Success':
            logger.info("Twistlock Console licensed and Ready")


        #
        # Now the console is up we can setup the webserver tf file
        # the webserser.tf file will now has script to register with console using auth token

        replace_string_in_file(webservers_filename, '<CONSOLE>', console_mgt_ip)
        replace_string_in_file(webservers_filename, '<AUTHKEY>', token)

    else:
        logger.info('No twistlock install this time')
        move_file(webservers_template, webservers_filename)



    #
    # Add Jenkins WebServer and Kali servers
    #
    #

    #
    return_code, web_in_deploy_output = apply_tf('./WebInDeploy', WebInDeploy_vars, 'WebInDeploy')

    logger.debug('Got Return code for deploy WebInDeploy {}'.format(return_code))

    # update_status('web_in_deploy_stdout', stdout)
    update_status('web_in_deploy_output', web_in_deploy_output)

    if return_code == 0:
        update_status('web_in_deploy_status', 'success')
        albDns = web_in_deploy_output['ALB-DNS']['value']
        fwMgtIP = web_in_deploy_output['MGT-IP-FW-1']['value']
        nlbDns = web_in_deploy_output['NLB-DNS']['value']
        fwMgtIP = web_in_deploy_output['MGT-IP-FW-1']['value']
        logger.info("Got these values from output of WebInDeploy \n\n")
        logger.info("AppGateway address is {}".format(albDns))
        logger.info("Internal loadbalancer address is {}".format(nlbDns))
        logger.info("Firewall Mgt address is {}".format(fwMgtIP))

    else:
        logger.info("WebInDeploy failed")
        update_status('web_in_deploy_status', 'error')
        print(json.dumps(status_output))
        exit(1)

    WebInFWConf_vars['mgt-ipaddress-fw1'] = fwMgtIP
    WebInFWConf_vars['nlb-dns'] = nlbDns

    WebInDeploy_vars['alb_dns'] = albDns
    WebInDeploy_vars['nlb-dns'] = nlbDns
    #
    # Apply WAF Rules
    #
    return_code, waf_conf_out = apply_tf('./waf_conf', waf_conf_vars, 'Waf_conf')

    logger.debug('Got Return code for deploy waf_conf {}'.format(return_code))

    update_status('waf_conf_output', waf_conf_out)
    # update_status('waf_conf_stdout', stdout)
    # update_status('waf_conf_stderr', stderr
    logger.debug('Got Return code to deploy waf_conf {}'.format(return_code))
    if return_code == 0:
        update_status('waf_conf_status', 'success')
    else:
        logger.info("waf_conf failed")
        update_status('waf_conf_status', 'error')
        print(json.dumps(status_output))
        exit(1)


    #
    # Check firewall is up and running
    # #
    api_key = getApiKey(fwMgtIP, username, password)

    #FIXME Add timeout after 3 minutes

    while True:
        err = getFirewallStatus(fwMgtIP, api_key)
        if err == 'cmd_error':
            logger.info("Command error from fw ")

        elif err == 'no':
            logger.info("FW is not up...yet")
            # print("FW is not up...yet")
            time.sleep(60)
            continue

        elif err == 'almost':
            logger.info("MGT up waiting for dataplane")
            time.sleep(20)
            continue

        elif err == 'yes':
            logger.info("FW is up")
            break

    logger.debug('Giving the FW another 10 seconds to fully come up to avoid race conditions')
    time.sleep(10)
    fw = firewall.Firewall(hostname=fwMgtIP, api_username=username, api_password=password)

    logger.info("Updating firewall with latest content pack")

    update_fw(fwMgtIP, api_key)

    #
    # Configure Firewall
    #

    return_code, web_in_fw_conf_out = apply_tf('./WebInFWConf', WebInFWConf_vars, 'WebInFWConf')

    if return_code == 0:
        update_status('web_in_fw_conf', 'success')
        logger.info("WebInFWConf success")

    else:
        logger.info("WebInFWConf failed")
        update_status('web_in_deploy_status', 'error')
        print(json.dumps(status_output))
        exit(1)

    logger.info("Commit changes to firewall")

    fw.commit()
    time.sleep(60)
    logger.info("waiting for commit")




    #
    # Check Jenkins
    #

    logger.info('Checking if Jenkins Server is ready')

    res = getServerStatus(albDns)

    if cdn_url and twistlock_license_key:
        logger.info('\n\n   Connect to Twistlock console at https://{}:8083.'.format(console_mgt_ip))

    if res == 'server_up':
        logger.info('Jenkins Server is ready')
        logger.info('\n\n   ### Deployment Complete ###')
        logger.info('\n\n   Connect to Jenkins Server at http://{}'.format(albDns))
        if cdn_url and twistlock_license_key:
            logger.info('\n\n   Connect to Twistlock console at https://{}:8083.'.format(console_mgt_ip))
    else:
        logger.info('Jenkins Server is down')
        logger.info('\n\n   ### Deployment Complete ###')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Get Terraform Params')
    parser.add_argument('-u', '--username', help='Firewall Username', required=True)
    parser.add_argument('-p', '--password', help='Firewall Password', required=True)
    parser.add_argument('-k', '--aws_access_key', help='AWS Key', required=True)
    parser.add_argument('-s', '--aws_secret_key', help='AWS Secret', required=True)
    parser.add_argument('-r', '--aws_region', help='AWS Region', required=True)
    parser.add_argument('-c', '--aws_key_pair', help='AWS EC2 Key Pair', required=True)
    parser.add_argument('-v', '--twistlock_key', help='Twistlock license key',required=False)
    parser.add_argument('-t', '--twistlock_url', help='URL for latest twistlock version',required=False)


    args = parser.parse_args()
    username = args.username
    password = args.password
    aws_access_key = args.aws_access_key
    aws_secret_key = args.aws_secret_key
    aws_region = args.aws_region
    ec2_key_pair = args.aws_key_pair
    if args.twistlock_key is not None:
        twistlock_license_key=args.twistlock_key
    else:
        twistlock_license_key=False
    if args.twistlock_url is not None:
        cdn_url = args.twistlock_url
    else:
        cdn_url=False

    main(username, password, aws_access_key, aws_secret_key, aws_region, ec2_key_pair, twistlock_license_key, cdn_url)
