import os
"""
gloud_login
Runs the shell command to invoke login.
The login process creates a new browser window for interactive login.
The login process updates the gloud auth files in ~/.config/gcloud
Files updated are:
    access_tokens.db
    config_sentinel
    credentials.db

The login process stores credentials in sqlite3 in ~/.config/gcloud/credentials.db

https://www.jhanley.com/google-cloud-where-are-my-credentials-stored/

"""

def gcloud_login():
    cmd = 'gcloud auth login'
    os.system(cmd)

if __name__ == '__main__':
    gcloud_login()
