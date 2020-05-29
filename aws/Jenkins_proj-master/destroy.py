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

        logger.info("Destroyed waf_conf Successfully")

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
        print ('Failed to Destroy WebInDeploy')
        
        exit(1)
    else:
        print ('Destroyed WebInDeploy Successfully')
        
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

