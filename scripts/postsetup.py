#!/usr/bin/env python3

import requests
import logging
import os
import sys
import time
import json

target_host = "http://localhost:30000"
issuer_uri = os.getenv("CREDS_ISSUER_URL", default=None).strip("/")
created_accounts = []
firstCred = """
{
    "grant_type": "password",
    "username": "netapp-test-astra00@mailinator.com",
    "password": "This_is_a_test",
    "audience": "https://api.cloud.netapp.com",
    "client_id": "VcPXCf6rPTPQsyS2oIt6SP5ZSgnUHI3S",
    "scope": "openid profile email"
}
"""

def get_token():
    logger = logging.getLogger(__name__)
    logger.info("accounts_api - attempting the retrieval of the account creator auth0 token")

    auth_data = json.loads(firstCred)

    logger.info("accounts_api - requesting our auth token")
    headers = {}
    headers["authorization"] = "Bearer"
    headers["content-type"] = "application/json"

    uri = "{}/oauth/token".format(issuer_uri)

    r = requests.post(uri, json=auth_data, headers=headers)
    if r.status_code >= 400:
        logger.info("accounts_api - could not retrieve the access token")
        logger.info(r.text)
        return None
    my_token = r.json().get("access_token")
    if my_token == None:
        logger.info("accounts_api - could not retrieve the access token")
        return None
    time.sleep(1)
    return my_token

def get_account(account_name: str, headers) -> str:
    r = requests.get(target_host + "/accounts/", headers=headers)
    if r.status_code == 200:
        body = r.json()
        for item in body["items"]:
            if item["name"] == account_name:
                return item["id"]
    return None

def create_account(account_name: str, headers) -> str:
    logger.info("")
    logger.info("accounts_create - creating account for " + account_name)

    account_data = {}
    account_data["name"] = account_name
    account_data["isEnabled"] = "false"

    r = requests.post(target_host + "/accounts", json=account_data, headers=headers)
    logger.info("returned " + str(r.status_code))
    if r.status_code == 201:
        location = r.headers["location"]
        location = location[location.rindex('/')+1:]
        logger.info("accounts_create - created an account with an id of " + location)
        logger.info("")
        return location
    else:
        return None

def get_user(account_id: str, email: str, headers) -> str:
    r = requests.get(target_host + "/accounts/" + account_id + "/core/v1/users", headers=headers)
    if r.status_code == 200:
        body = r.json()
        for item in body["items"]:
            if item["email"] == email:
                return item["id"]
    return None

def create_user(account_id: str, useremail: str, headers) -> str:
    new_user = {}

    new_user["type"] = "application/astra-user"
    new_user["version"] = "1.2"
    new_user["firstName"] = "John"
    new_user["lastName"] = "Doe"
    new_user["email"] = useremail
    new_user["isEnabled"] = "true"
    new_user["sendWelcomeEmail"] = "false"

    new_user["companyName"] = "NetApp"
    new_user["phone"] = "9999999999"

    address = {
        "addressCountry": "US",
        "addressLocality": "Durham",
        "addressRegion": "North Carolina",
        "streetAddress1": "7301 Kit Creek Rd",
        "postalCode": "27709"
    }
    new_user["postalAddress"] = address

    r = requests.post(target_host + "/accounts/" + account_id + "/core/v1/users", json=new_user, headers=headers)
    if r.status_code == 201:
        location = r.headers["location"]
        location = location[location.rindex('/')+1:]
        logger.info("users_manage - created a user with an id of " + location)
        logger.info("")
        return location
    else:
        return None

def manage_user(account_id: str, user_id: str, headers) -> str:
    #
    # now we need to create a role
    #
    new_role = {}
    new_role["type"] = "application/astra-roleBinding"
    new_role["version"] = "1.1"
    new_role["accountID"] = account_id
    new_role["userID"] = user_id
    new_role["role"] = "owner"

    r = requests.post(target_host + "/accounts/" + account_id + "/core/v1/roleBindings", json=new_role, headers=headers)
    if r.status_code == 201:
        location = r.headers["location"]
        location = location[location.rindex('/')+1:]
        role_id = location
        logger.info("users_manage - created a roleBinding with an id of " + role_id)
        logger.info("")
    elif r.status_code != 409:
        logger.info("users_manage - creation of a roleBinding failed")
        logger.info("")
        return None

    #
    # ok, we are going to update our user by doing a PUT
    #
    created_user = {}
    created_user["type"] = "application/astra-user"
    created_user["version"] = "1.2"
    created_user["isInviteAccepted"] = "true"

    r = requests.put(target_host + "/accounts/" + account_id + "/core/v1/users/" + user_id, json=created_user, headers=headers)
    if r.status_code == 204:
        logger.info("users_manage - user modified to 'accept the invite'")
        logger.info("")
    else:
        logger.info("users_manage - modification of the user to accept an invite failed " + str(r.status_code))
        logger.info("")
        return None

    return user_id

def add_billing_subscription(account_id: str, headers):
    body = {
        "marketplace": "netapp",
        "terms": "trial"
    }

    uri = "{}/accounts/{}/core/v1/subscriptions".format(target_host, account_id)
    response = requests.post(uri, json=body, headers=headers)
    logger.info("add_billing_subscription - returned " + str(response.status_code))

    if response.status_code != 201:
        logger.info("add_billing_subscription - FAIL:")

if __name__ == '__main__':
    logFormatter = '%(asctime)s - %(levelname)s - %(message)s'
    logging.basicConfig(format=logFormatter, level=logging.ERROR)
    logger = logging.getLogger(__name__)

    token = get_token()
    if token == None:
        logger.info("accounts_create - cannot continue...")
        sys.exit(1)

    headers = {}
    headers["authorization"] = "Bearer " + token
    headers["content-type"] = "application/json# "

    x = int(sys.argv[1]) # The sequence number
    useremail = f'netapp-test-astra{x:02d}@mailinator.com'
    account_name = f'JohnDoe{x:02d}'
    print("Ready to create account: {}".format(account_name))
    account_id = create_account(account_name, headers)
    if account_id != None:
        print("Account {} created successfully".format(account_name))
        add_billing_subscription(account_id, headers)
    else:
        account_id = get_account(account_name, headers)
        if account_id != None:
            print("Account {} retrieved successfully".format(account_name))
        else:
            print("Account {} creation failed".format(account_name))
            sys.exit(1)

    user_id = create_user(account_id, useremail, headers)
    if user_id != None:
        print("User: {} created successfully".format(useremail))
    else:
        user_id = get_user(account_id, useremail, headers)
        if user_id != None:
            print("User: {} retrieved successfully".format(useremail))
        else:
            print("User: {} creation failed".format(useremail))
            sys.exit(1)

    managed_user_id = manage_user(account_id, user_id, headers)
    if managed_user_id != None:
        print("User: {} subscription done successfully".format(useremail))
    else:
        print("User: {} subscription failed".format(useremail))

    print("")