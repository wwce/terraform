
from azure.cli.core import get_default_cli
import sys
import tempfile
import argparse
import logging
import subprocess
import os

from python_terraform import Terraform

logger = logging.getLogger()
# handler = logging.StreamHandler()
# formatter = logging.Formatter('%(levelname)-8s %(message)s')
# handler.setFormatter(formatter)
# logger.addHandler(handler)
logger.setLevel(logging.INFO)


#
# Usage azure_login.py -g rgname
#

sys.sterr = sys.stdout

print('Logging in to Azure using device code')

def run_cmd(cmd):
    subprocess.call('az login', shell=True)
    res = subprocess.call(cmd, shell=True)
    print ('Result is {}'.format(res))


def delete_file(fpath):
    if os.path.exists(fpath):
        try:
            os.remove(fpath)
            print ('Removed state file {}'.format(fpath))
        except Exception as e:
            print ('Unable to delete the file {} got error {}'.format(fpath, e))
    else:
        print('No need to delete {} as it no longer exists'.format(fpath))

def az_cli(args_str):
    temp = tempfile.TemporaryFile()
    args = args_str.split()
    logger.debug('Sending cli command {}'.format(args))
    code = get_default_cli().invoke(args, None, temp)
    # temp.seek(0)
    data = temp.read().strip()
    temp.close()
    return [code, data]

def delete_rg(rg_name):
    logger.info('Deleting resource group {}'.format(rg_name))
    cmd = 'group delete --name ' + rg_name + ' --yes'
    code, data = az_cli(cmd)
    if code == 0:
        print ('Successfully deleted Rg {} {}'.format(code,rg_name))

def delete_state_files(working_dir, file_list):
    """

    :param working_dir: string
    :param tfstate_files: list of files
    :return: True or False

    Removes a list of files from a directory

    """
    for file_name in file_list:
        fpath = working_dir + file_name
        if os.path.exists(fpath):
            delete_file(fpath)
        else:
            print('Already deleted file {}'.format(fpath))

def main (username, password):
    #get_default_cli().invoke(['login', "--use-device-code"], out_file=sys.stdout)
    #
    # Destroy Infrastructure
    #
    tfstate_file = 'terraform.tfstate'
    tfstate_files = ['terraform.tfstate', 'terraform.tfstate.backup']

    fpath = './WebInDeploy/' + tfstate_file
    if os.path.isfile(fpath):
        tf = Terraform(working_dir='./WebInDeploy')
        rg_name = tf.output('RG_Name')
        rg_name1 = tf.output('Attacker_RG_Name')
        delete_rg_cmd = 'group delete --name ' + rg_name + ' --yes'
        az_cli(delete_rg_cmd)
    #
    # Delete state files WebInDeploy
    #
    delete_state_files('./WebInDeploy/', tfstate_files)


    fpath = './WebInBootstrap/' + tfstate_file
    if os.path.isfile(fpath):
        delete_rg_cmd = 'group delete --name ' + rg_name1 + ' --yes'
        az_cli(delete_rg_cmd)
    #
    # Delete state files WebInBootstrap
    #
    delete_state_files('./WebInBootstrap/', tfstate_files)


    #
    # Delete state files WebInFWConf
    #
    delete_state_files('./WebInFWConf/', tfstate_files)




if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Get Terraform Params')
    parser.add_argument('-u', '--username', help='Firewall Username', required=True)
    parser.add_argument('-p', '--password', help='Firewall Password', required=True)
    args = parser.parse_args()
    username = args.username
    password = args.password
    # get_default_cli().invoke(['login', "--use-device-code"], out_file=sys.stdout)
    main(username, password)
