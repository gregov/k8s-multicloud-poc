#!/usr/bin/env python
# Credits: from https://raw.githubusercontent.com/RocketChat/rasa-kick-starter/master/scripts/bot_config.py

import argparse
import json
import logging
import requests

# == Log Config ==

logger = logging.getLogger('Bot Config')
logger.setLevel(logging.DEBUG)

ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)

formatter = logging.Formatter(
    '%(asctime)s :: %(name)s :: %(levelname)s :: %(message)s'
)

ch.setFormatter(formatter)

logger.addHandler(ch)

# == CLI ==

parser = argparse.ArgumentParser()

parser.add_argument(
    '--bot-name', '-bn', type=str, default='hubot',
    help='Bot username'
)
parser.add_argument(
    '--bot-password', '-bp', type=str, default='hubot!',
    help='Bot password'
)
parser.add_argument(
    '--admin-name', '-an', type=str, default='admin',
    help='Admin username'
)
parser.add_argument(
    '--admin-password', '-ap', type=str, default='123soleil',
    help='Admin password'
)
parser.add_argument(
    '--rocketchat-url', '-r', type=str, default='http://localhost:8888',
    help='Rocket chat URL (default: http://localhost:3000)'
)

args = parser.parse_args()


host = args.rocketchat_url
if host[-1] == '/':
    host = host[:-1]

path = '/api/v1/login'

bot_name = args.bot_name
bot_password = args.bot_password
admin_name = args.admin_name
admin_password = args.admin_password

bot_email = bot_name + '@email.com'
user_header = None


def get_authentication_token():
    login_data = {'username': admin_name, 'password': admin_password}
    response = requests.post(host + path, data=json.dumps(login_data))

    if response.json()['status'] == 'success':
        logger.info('Login suceeded')

        authToken = response.json()['data']['authToken']
        userId = response.json()['data']['userId']
        user_header = {
            'X-Auth-Token': authToken,
            'X-User-Id': userId,
            'Content-Type': 'application/json'
        }

        return user_header


def create_bot_user():
    user_info = {
        'name': bot_name,
        'email': bot_email,
        'password': bot_password,
        'username': bot_name,
        'requirePasswordChange': False,
        'sendWelcomeEmail': True, 'roles': ['bot']
    }

    create_user_response = requests.post(
        host + '/api/v1/users.create',
        data=json.dumps(user_info),
        headers=user_header
    )

    print(create_user_response.json())

    if create_user_response.json()['success'] is True:
        logger.info('User has been sucessfully created!')
    else:
        logger.error('Error while creating bot user!')


if __name__ == '__main__':

    user_header = get_authentication_token()

    if user_header:
        create_bot_user()
    else:
        logger.error('Login Failed')