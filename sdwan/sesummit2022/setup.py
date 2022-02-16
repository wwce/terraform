#!/usr/bin/env python
"""
Prisma SDWAN Upgrade Single ION
tkamath@paloaltonetworks.com
Version: 1.0.1 b1
"""
# standard modules
import getpass
import json
import logging
import datetime
import os
import sys
import csv
import time
import numpy as np
import pandas as pd

#standard modules
import argparse
import logging

# CloudGenix Python SDK
import cloudgenix
import codecs

# Global Vars
SDK_VERSION = cloudgenix.version
SCRIPT_NAME = 'Prisma SD-WAN: SE Summit 2022 Set Up Lab'

# Set NON-SYSLOG logging to use function name
logger = logging.getLogger(__name__)

sys.path.append(os.getcwd())
try:
    from cloudgenix_settings import CLOUDGENIX_AUTH_TOKEN

except ImportError:
    # Get AUTH_TOKEN/X_AUTH_TOKEN from env variable, if it exists. X_AUTH_TOKEN takes priority.
    if "X_AUTH_TOKEN" in os.environ:
        CLOUDGENIX_AUTH_TOKEN = os.environ.get('X_AUTH_TOKEN')
    elif "AUTH_TOKEN" in os.environ:
        CLOUDGENIX_AUTH_TOKEN = os.environ.get('AUTH_TOKEN')
    else:
        # not set
        CLOUDGENIX_AUTH_TOKEN = None

try:
    from cloudgenix_settings import CLOUDGENIX_USER, CLOUDGENIX_PASSWORD

except ImportError:
    # will get caught below
    CLOUDGENIX_USER = None
    CLOUDGENIX_PASSWORD = None


#
# Global Dicts
#
elem_id_name = {}
elem_name_id = {}
elem_id_hwid = {}
elem_hwid_id = {}
image_id_name = {}
image_name_id = {}
unsupported_id_name = {}
unsupported_name_id = {}
device_serials = []
machine_slno_obj = {}

def create_dicts(cgx_session):
    resp = cgx_session.get.elements()
    if resp.cgx_status:
        elemlist = resp.cgx_content.get("items", None)
        for elem in elemlist:
            elem_id_name[elem["id"]] = elem["name"]
            elem_name_id[elem["name"]] = elem["id"]
            elem_id_hwid[elem["id"]] = elem["hw_id"]
            elem_hwid_id[elem["hw_id"]] = elem["id"]
    else:
        print("ERR: Could not retrieve elements")
        cloudgenix.jd_detailed(resp)

    resp = cgx_session.get.element_images()
    if resp.cgx_status:
        imagelist = resp.cgx_content.get("items", None)
        for image in imagelist:
            if image["state"] == "release":
                image_id_name[image["id"]] = image["version"]
                image_name_id[image["version"]] = image["id"]
            else:
                unsupported_id_name[image["id"]] = image["version"]
                unsupported_name_id[image["version"]] = image["id"]

    else:
        print("ERR: Could not retrieve element images")
        cloudgenix.jd_detailed(resp)

    return


def abort_upgrades(device, cgx_session):
    hwid = device
    if hwid in elem_hwid_id.keys():
        elemid = elem_hwid_id[hwid]

        data = {
            "action": "abort_upgrade",
            "parameters": None
        }

        resp = cgx_session.post.operations_e(element_id=elemid, data=data)
        if resp.cgx_status:
            print("Upgrade aborted for {}".format(hwid))
        else:
            print("ERR: Could not abort upgrade for {}".format(hwid))
            cloudgenix.jd_detailed(resp)

    return


def upgrade_device(device,cgx_session):

    hwid = device
    if hwid in elem_hwid_id.keys():
        elemid = elem_hwid_id[hwid]
        swversion = "5.6.3-b11"

        if swversion in image_name_id.keys():
            imageid = image_name_id[swversion]

            #
            # Get Current Software Status
            #
            resp = cgx_session.get.software_state(element_id=elemid)
            if resp.cgx_status:
                status = resp.cgx_content
                current_imageid = status["image_id"]
                if current_imageid == imageid:
                    print("INFO: Device {} already at {}. Skipping Upgrade..".format(hwid,swversion))

                else:
                    status["image_id"] = imageid
                    status["scheduled_download"] = None
                    status["scheduled_upgrade"] = None
                    status["interface_ids"] = []
                    status["download_interval"] = None
                    status["upgrade_interval"] = None

                    resp = cgx_session.put.software_state(element_id=elemid,data=status)
                    if resp.cgx_status:
                        print("INFO: Device {} upgrade to {} scheduled".format(hwid,swversion))

                    else:
                        print("ERR: Device {} could not be upgraded to {}".format(hwid,swversion))
                        cloudgenix.jd_detailed(resp)

            else:
                print("ERR: Could not retrieve software status")
                cloudgenix.jd_detailed(resp)

    return


def claim_device(machine,cgx_session):
    machine_state = "Unknown"
    serial = machine.get('sl_no')
    machine_id = machine.get('id')
    if not serial or not machine_id:
        print("ERR: Unable to get machine serial or ID:", machine)

    claimed = False
    claim_pending = False

    # Check if claimed
    machines_describe_response = cgx_session.get.machines(machine_id)
    if machines_describe_response.cgx_status:
        machine_state = machines_describe_response.cgx_content.get('machine_state')

        if machine_state.lower() in ['claim_pending',
                                     'manufactured_cic_issued',
                                     'manufactured_cic_issue_pending',
                                     'manufactured_cic_operational']:
            # system in process of claiming. bypass claim and wait.
            claim_pending = True

        if machine_state.lower() in ['claimed']:
            claimed = True
        else:
            claimed = False

    # if isn't claimed, begin work.
    if not claimed:

        # only verify online and claim if not in claim_pending state.
        if not claim_pending:
            print("  Unclaimed({0}). Beginning Claim process..".format(machine_state))
            # verify ION is online
            connected = False
            time_elapsed = 0
            while not connected:
                # check online status
                machines_describe_response = cgx_session.get.machines(machine_id)
                if machines_describe_response.cgx_status:
                    connected = machines_describe_response.cgx_content.get('connected', False)

                if time_elapsed > 600:
                    print("Machine {0} Offline for longer than {1} seconds. Exiting."
                                "".format(serial, 600))

                if not connected:
                    print("  Machine {0} Offline, waited so far {1} seconds out of {2}."
                                   "".format(serial, time_elapsed, 600))
                    time.sleep(10)
                    time_elapsed += 10

            # Got here, means ION is online.
            # cgx Machine template
            machines_claim = {
                "inventory_op": "claim"
            }

            # Attempt to claim Machine
            machines_claim_response = cgx_session.post.tenant_machine_operations(machine_id, machines_claim)

            if not machines_claim_response.cgx_status:
                print("Machine '{0}' CLAIM failed.".format(serial), machines_claim_response.cgx_content)
        else:
            print("  Claim already in process ({0})..".format(machine_state))
        # wait and make sure that the ION moves to "claimed" state.
        time_elapsed = 0

        while not claimed:
            # check online status
            machines_describe_response = cgx_session.get.machines(machine_id)
            if machines_describe_response.cgx_status:
                machine_state = machines_describe_response.cgx_content.get('machine_state')
                # Update claimed
                if machine_state.lower() in ['claimed']:
                    claimed = True
                else:
                    claimed = False

            if time_elapsed > 600:
                # failed waiting.
                print("Machine {0} Claim took longer than {1} seconds. Exiting."
                            "".format(serial, 600))

            if not claimed:
                print("  Machine {0} still claiming, waited so far {1} seconds out of {2}."
                               "".format(serial, time_elapsed, 600))
                time.sleep(10)
                time_elapsed += 10

    else:
        return True

    #
    # Check state before returning
    #
    resp = cgx_session.get.machines(machine_id=machine["id"])
    if resp.cgx_status:
        state = resp.cgx_content.get('machine_state')
        if state == "claimed":
            return True
        else:
            return False


def go():
    ############################################################################
    # Begin Script, parse arguments.
    ############################################################################

    # Parse arguments
    parser = argparse.ArgumentParser(description="{0}.".format(SCRIPT_NAME))

    # Allow Controller modification and debug level sets.
    controller_group = parser.add_argument_group('API', 'These options change how this program connects to the API.')
    controller_group.add_argument("--controller", "-C",
                                  help="Controller URI, ex. "
                                       "C-Prod: https://api.elcapitan.cloudgenix.com",
                                  default=None)

    controller_group.add_argument("--insecure", "-I", help="Disable SSL certificate and hostname verification",
                                  dest='verify', action='store_false', default=False)

    login_group = parser.add_argument_group('Login', 'These options allow skipping of interactive login')
    login_group.add_argument("--email", "-E", help="Use this email as User Name instead of prompting",
                             default=None)
    login_group.add_argument("--pass", "-PW", help="Use this Password instead of prompting",
                             default=None)

    # Commandline for CSV file name
    device_group = parser.add_argument_group('Device Info', 'Device to setup for SE Summit 2022')
    device_group.add_argument("--serial_number", "-SN", help="Device Serial Number", default=None)

    device_group.add_argument("--abort", "-A", help="Abort Scheduled Upgrades",
                              default=False, action="store_true")

    debug_group = parser.add_argument_group('Debug', 'These options enable debugging output')
    debug_group.add_argument("--debug", "-D", help="Verbose Debug info, levels 0-2", type=int,
                             default=0)

    args = vars(parser.parse_args())

    abort = args["abort"]
    serial_number = args["serial_number"]

    if args['debug'] == 1:
        logging.basicConfig(level=logging.INFO,
                            format="%(levelname)s [%(name)s.%(funcName)s:%(lineno)d] %(message)s")
        logger.setLevel(logging.INFO)
    elif args['debug'] >= 2:
        logging.basicConfig(level=logging.DEBUG,
                            format="%(levelname)s [%(name)s.%(funcName)s:%(lineno)d] %(message)s")
        logger.setLevel(logging.DEBUG)
    else:
        # Remove all handlers
        for handler in logging.root.handlers[:]:
            logging.root.removeHandler(handler)
        # set logging level to default
        logger.setLevel(logging.WARNING)

    ############################################################################
    # Instantiate API
    ############################################################################
    cgx_session = cloudgenix.API(controller=args["controller"], ssl_verify=args["verify"])

    # set debug
    cgx_session.set_debug(args["debug"])
    ############################################################################
    # Draw Interactive login banner, run interactive login including args above.
    ############################################################################

    print("{0} v{1} ({2})\n".format(SCRIPT_NAME, SDK_VERSION, cgx_session.controller))

    # login logic. Use cmdline if set, use AUTH_TOKEN next, finally user/pass from config file, then prompt.
    # figure out user
    if args["email"]:
        user_email = args["email"]
    elif CLOUDGENIX_USER:
        user_email = CLOUDGENIX_USER
    else:
        user_email = None

    # figure out password
    if args["pass"]:
        user_password = args["pass"]
    elif CLOUDGENIX_PASSWORD:
        user_password = CLOUDGENIX_PASSWORD
    else:
        user_password = None

    # check for token
    if CLOUDGENIX_AUTH_TOKEN and not args["email"] and not args["pass"]:
        cgx_session.interactive.use_token(CLOUDGENIX_AUTH_TOKEN)
        if cgx_session.tenant_id is None:
            print("AUTH_TOKEN login failure, please check token.")
            sys.exit()

    else:
        while cgx_session.tenant_id is None:
            cgx_session.interactive.login(user_email, user_password)
            # clear after one failed login, force relogin.
            if not cgx_session.tenant_id:
                user_email = None
                user_password = None

    ############################################################################
    # Create WAN Networks
    ############################################################################
    publicnws = []
    resp = cgx_session.get.wannetworks()
    if resp.cgx_status:
        networks = resp.cgx_content.get("items",None)
        for nw in networks:
            if nw["type"] == "pbulicwan":
                publicnws.append(nw["name"])

    if "Amazon Internet" in publicnws:
        print("INFO: WAN Network Amazon Internet already exists")
    else:
        data = {
            "name": "Amazon Internet",
            "description": None,
            "tags": None,
            "provider_as_numbers": None,
            "type": "publicwan"
        }
        resp = cgx_session.post.wannetworks(data=data)
        if resp.cgx_status:
            print("INFO: WAN Network {} created".format(data["name"]))
        else:
            print("ERR: Could not create WAN Network {}".format(data["name"]))
            cloudgenix.jd_detailed(resp)

    ############################################################################
    # Claim the device
    ############################################################################
    resp = cgx_session.get.machines()
    if resp.cgx_status:
        machinelist = resp.cgx_content.get("items", None)
        for mach in machinelist:
            machine_slno_obj[mach["sl_no"]] = mach
            device_serials.append(mach["sl_no"])


    if serial_number in device_serials:
        mobj = machine_slno_obj[serial_number]
        print("INFO: Device found")
        if claim_device(machine=mobj,cgx_session=cgx_session):

            print("INFO: Device claimed")

            ############################################################################
            # Upgrade the device
            ############################################################################
            create_dicts(cgx_session)
            upgrade_device(device=serial_number, cgx_session=cgx_session)
    else:
        print("ERR: Invalid Serial Number. Please choose from:\n")
        for i in device_serials:
            print("\t{}".format(i))

        cgx_session.get.logout()
        sys.exit()

    # get time now.
    curtime_str = datetime.datetime.utcnow().strftime('%Y-%m-%d-%H-%M-%S')
    # create file-system friendly tenant str.
    tenant_str = "".join(x for x in cgx_session.tenant_name if x.isalnum()).lower()

    # end of script, run logout to clear session.
    print("Logging Out.")
    cgx_session.get.logout()


if __name__ == "__main__":
    go()