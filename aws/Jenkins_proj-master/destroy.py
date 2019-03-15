#!/usr/bin/env python3
"""
Paloaltonetworks Deploy_Jenkins_Hack_Demo.py

This software is provided without support, warranty, or guarantee.
Use at your own risk.
"""

'''
Destroys resources post testing

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
from python_terraform import Terraform

logger = logging.getLogger()
handler = logging.StreamHandler()
formatter = logging.Formatter('%(levelname)-8s %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.INFO)


def main(aws_access_key, aws_secret_key, aws_region):
    albDns = ''
    nlbDns = ''
    fwMgt = ''

    # Set run_plan to TRUE is you wish to run terraform plan before apply
    run_plan = False
    deployment_status = {}
    kwargs = {"auto-approve": True}

    vars = {
        'aws_access_key': aws_access_key,
        'aws_secret_key': aws_secret_key,
        'aws_region': aws_region,
    }

    #
    # Destroy Infrastructure
    #
    tf = Terraform(working_dir='./waf_conf')
    tf.cmd('init')
    if run_plan:
        print('Calling tf.plan')
        tf.plan(capture_output=False)

    return_code1, stdout, stderr = tf.cmd('destroy', capture_output=True, vars=vars, **kwargs)
    # return_code1 =0
    print('Got return code {}'.format(return_code1))

    if return_code1 != 0:
        logger.info("Failed to destroy WebInDeploy ")

        exit()
    else:

        logger.info("Destroyed WebInDeploy ")

    tf = Terraform(working_dir='./WebInDeploy')
    tf.cmd('init')
    if run_plan:
        print('Calling tf.plan')
        tf.plan(capture_output=False)

    return_code1, stdout, stderr = tf.cmd('destroy', capture_output=True, vars=vars, **kwargs)
    # return_code1 =0
    print('Got return code {}'.format(return_code1))

    if return_code1 != 0:
        logger.info("WebInDeploy destroyed")
        deployment_status = {'WebInDeploy': 'Fail'}
        print(deployment_status)
        exit(1)
    else:
        deployment_status = {'WebInDeploy': 'Success'}
        print(deployment_status)
        exit(0)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Get Terraform Params')

    parser.add_argument('-k', '--aws_access_key', help='AWS Key', required=True)
    parser.add_argument('-s', '--aws_secret_key', help='AWS Secret', required=True)
    parser.add_argument('-r', '--aws_region', help='AWS Region', required=True)

    args = parser.parse_args()
    aws_access_key = args.aws_access_key
    aws_secret_key = args.aws_secret_key
    aws_region = args.aws_region

    main(aws_access_key, aws_secret_key, aws_region)

