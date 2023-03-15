#!/usr/bin/env python3

# This script gets the service4 credentials from the secure openlab vault
# then add each record to ACS credentials

import json
import logging
import os
import sys
from typing import Any

import requests

openlab_uri = "http://vault.openenglab.netapp.com"
correlationid = "b90cd7e9-6095-4755-be2e-88614b1245b3"
userid = "06ea14a1-dce8-11ea-8f1c-2eda23b24bb8"
# This is the credential host, do port forward first.
target_host = "http://localhost:9080"

def get_github_auth_token(github_token:str):
    logger.info("get_auth_token")

    headers = {
        "content-type": "application/json",
    }

    body = {
        "token": github_token
    }
    uri = "{}/v1/auth/github/login".format(openlab_uri)

    response = requests.post(uri, headers=headers, json=body)
    logger.info("get_auth_token - returned " + str(response.status_code))

    if response.status_code != 200:
        logger.info("get_auth_token - \n" + json.dumps(response.json(), indent=4))
        return None

    return response.json().get("auth").get("client_token")

def get_credentials(auth_token:str):
    logger.info("get_credentials")

    headers = {
        "content-type": "application/json",
        "X-Vault-Token": auth_token,
    }

    uri = "{}/v1/astra/data/service-stage-credentials".format(openlab_uri)
    response = requests.get(uri, headers=headers)
    logger.info("get_credentials - returned " + str(response.status_code))

    if response.status_code != 200:
        logger.info("get_credentials - \n" + json.dumps(response.json(), indent=4))
        return None

    return response.json().get("data").get("data").get("secret_stage_credentials")

def add_credential(credential_id:str, cred: Any):
    logger.info("adding credential name: " + cred.get("name"))
    headers = {
        "content-type": "application/json",
        "x-pcloud-correlationid": correlationid,
        "x-pcloud-userid": userid,
        "x-pcloud-role": "system"
    }

    uri = "{}/v1/credentials/{}".format(target_host, credential_id)
    response = requests.put(uri, headers=headers, json=cred)
    logger.info("add_credential - returned " + str(response.status_code))

    if response.status_code < 400:
        print("added credential: " + cred.get("name"))
    else:
        print("add credential " + cred.get("name") + " failed")

if __name__ == '__main__':
    logFormatter = '%(asctime)s - %(levelname)s - %(message)s'
    logging.basicConfig(format=logFormatter, level=logging.ERROR)
    logger = logging.getLogger(__name__)

    github_id = os.getenv("GITHUB_ID", default=None)
    github_token = os.getenv("GITHUB_TOKEN", default=None)
    if github_token == None or github_id == None:
        logger.info("The environment variable GITHUB_TOKEN or GITHUB_ID cannot be found")
        sys.exit(1)

    auth_token = get_github_auth_token(github_token)
    logger.info("Auth token returned: " + auth_token)

    creds = get_credentials(auth_token)
    if creds == None:
        logger.info("The credentials were not returned")
        sys.exit(1)

    allitems = json.loads(creds)
    for cred_rec in allitems.get("items"):
        # Get the id and credential from each item
        # Push the id and credential
        if cred_rec.get("cred").get("name") != "Template":
            add_credential(cred_rec.get("id"), cred_rec.get("cred"))

