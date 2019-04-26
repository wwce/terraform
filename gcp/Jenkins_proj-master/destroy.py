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

Usage:
git
python destroy.py

"""

import argparse
import logging

from python_terraform import Terraform

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

    WebInDeploy_vars.update({'RG_Name': rg_name})
    WebInDeploy_vars.update({'Attack_RG_Name': attack_rg_name})

    if run_plan:
        print('Calling tf.plan')
        tf.plan(capture_output=False)

    return_code1, stdout, stderr = tf.cmd('destroy', var=WebInDeploy_vars, capture_output=False, **kwargs)
    # return_code1 =0
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

    return_code1, stdout, stderr = tf.cmd('destroy', var=WebInBootstrap_vars, capture_output=False, **kwargs)
    # return_code1 =0
    print('Got return code {}'.format(return_code1))

    if return_code1 != 0:
        logger.info("WebInBootstrap destroyed")
        deployment_status = {'WebInDeploy': 'Fail'}

        exit()
    else:
        deployment_status = {'WebInDeploy': 'Success'}
        exit()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Get Terraform Params')
    parser.add_argument('-u', '--username', help='Firewall Username', required=True)
    parser.add_argument('-p', '--password', help='Firewall Password', required=True)

    args = parser.parse_args()
    username = args.username
    password = args.password

    main(username, password)
