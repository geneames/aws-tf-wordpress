import os
import re
import uuid
import logging
import json
import boto3
from botocore.exceptions import ClientError


def main():
    """Exercise bucket_exists()"""
    with open('tests/data/test.json') as json_file:
        data = json.load(json_file)

    blob = data['Reservations'][0]['Instances'][0]['PublicIpAddress']
    blob = blob['Instances']

if __name__ == '__main__':
    main()
