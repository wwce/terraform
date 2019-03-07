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
from  python_terraform import Terraform

logger = logging.getLogger()
handler = logging.StreamHandler()
formatter = logging.Formatter('%(levelname)-8s %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.INFO)


def main():

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
    tf = Terraform(working_dir='./waf_conf')

    if run_plan:
        print('Calling tf.plan')
        tf.plan(capture_output=False)

    return_code1, stdout, stderr = tf.cmd('destroy',capture_output=False,**kwargs)
    #return_code1 =0
    print('Got return code {}'.format(return_code1))

    if return_code1 != 0:
        logger.info("Failed to destroy WebInDeploy ")


        exit()
    else:

        logger.info("Destroyed WebInDeploy ")






    tf = Terraform(working_dir='./WebInDeploy')

    if run_plan:
        print('Calling tf.plan')
        tf.plan(capture_output=False)

    return_code1, stdout, stderr = tf.cmd('destroy',capture_output=False,**kwargs)
    #return_code1 =0
    print('Got return code {}'.format(return_code1))

    if return_code1 != 0:
        logger.info("WebInDeploy destroyed")
        deployment_status = {'WebInDeploy': 'Fail'}

        exit()
    else:
        deployment_status = {'WebInDeploy':'Success'}
        exit()



if __name__ == '__main__':
    main()
