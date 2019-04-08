#!/usr/bin/env python3
"""
Paloaltonetworks Deploy_Jenkins_Hack_Demo.py

This software is provided without support, warranty, or guarantee.
Use at your own risk.
"""

'''
Destroys resources post testing

Usage

python deploy.py -u <fwusername> -p <fwpassword> -a <Attack RG Name>, '-g' <RG name>

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

logger = logging.getLogger()
handler = logging.StreamHandler()
formatter = logging.Formatter('%(levelname)-8s %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.INFO)


def main(username, password):

    username = username
    password = password

    WebInDeploy_vars = {
        'Admin_Username': username,
        'Admin_Password': password
    }

    WebInBootstrap_vars = {
        'Admin_Username': username,
        'Admin_Password': password
    }

    albDns = ''
    nlbDns = ''
    fwMgt = ''

    # Set run_plan to TRUE is you wish to run terraform plan before apply
    run_plan = False
    deployment_status = {}
    kwargs = {"auto-approve": True}

    #
    # Destroy Infrastructure
    #
    tf = Terraform(working_dir='./WebInDeploy')
    rg_name = tf.output('RG_Name')

    attack_rg_name = tf.output('Attacker_RG_Name')
    logger.info('Got RG_Name {} and Attacker_RG_Name {}'.format(rg_name, attack_rg_name))

    WebInDeploy_vars.update({'RG_Name' : rg_name})
    WebInDeploy_vars.update({'Attack_RG_Name': attack_rg_name})


    if run_plan:
        print('Calling tf.plan')
        tf.plan(capture_output=False)

    return_code1, stdout, stderr = tf.cmd('destroy',var = WebInDeploy_vars, capture_output=False,**kwargs)
    #return_code1 =0
    print('Got return code {}'.format(return_code1))

    if return_code1 != 0:
        logger.info("Failed to destroy build ")


        exit()
    else:

        logger.info("Destroyed WebInDeploy ")

    WebInBootstrap_vars.update({'RG_Name': rg_name})
    WebInBootstrap_vars.update({'Attack_RG_Name': attack_rg_name})


    tf = Terraform(working_dir='./WebInBootstrap')

    if run_plan:
        print('Calling tf.plan')
        tf.plan(capture_output=False)

    return_code1, stdout, stderr = tf.cmd('destroy',var = WebInBootstrap_vars,capture_output=False,**kwargs)
    #return_code1 =0
    print('Got return code {}'.format(return_code1))

    if return_code1 != 0:
        logger.info("WebInBootstrap destroyed")
        deployment_status = {'WebInDeploy': 'Fail'}

        exit()
    else:
        deployment_status = {'WebInDeploy':'Success'}
        exit()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Get Terraform Params')
    parser.add_argument('-u', '--username', help='Firewall Username', required=True)
    parser.add_argument('-p', '--password', help='Firewall Password', required=True)


    args = parser.parse_args()
    username = args.username
    password = args.password


    main(username, password)
