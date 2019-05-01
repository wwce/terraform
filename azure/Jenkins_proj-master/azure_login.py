from azure import cli
from azure.cli.core import get_default_cli
import sys

sys.sterr = sys.stdout

print('Logging in to Azure using device code')

get_default_cli().invoke(['login', "--use-device-code"], out_file=sys.stdout)
pass