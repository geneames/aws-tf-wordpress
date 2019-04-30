import uuid
import logging
import json
import boto3
from botocore.exceptions import ClientError

logging.basicConfig(level=logging.DEBUG, format='%(levelname)s: %(asctime)s: %(funcName)s: %(lineno)d: %(message)s')
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)


def manage_dns_recordset(action_flag: str, ip_address: str, health_check_id: str):
    """Create Route 53 Health Check for given IP Address

    :param action_flag: string
    :param ip_address: string
    :param health_check_id: string
    :return: Success if DNS record set was successfully managed.
    """

    r53 = boto3.client('route53')
    try:
        response = r53.change_resource_record_sets(
            HostedZoneId='Z9796LRXUMDK8',
            ChangeBatch={
                'Comment': '',
                'Changes': [
                    {
                        'Action': action_flag,
                        'ResourceRecordSet': {
                            'Name': 'bastion.wp.sema.io',
                            'Type': 'A',
                            'SetIdentifier': 'sema-bastion-{}'.format(ip_address.replace('.', '-')),
                            'Weight': 10,
                            'TTL': 60,
                            'ResourceRecords': [
                                {
                                    'Value': ip_address
                                },
                            ],
                            'HealthCheckId': health_check_id,
                        }
                    },
                ]
            }
        )
    except ClientError as e:
        logger.debug(e)
        return None

    logger.debug(response)
    return 'Success'


def get_instance_ip_address(instance_id: str):
    """Create Route 53 Health Check for given IP Address


    :param instance_id: string
    :return: IP Address of the given instance.
    """

    ec2 = boto3.client('ec2')
    public_ip_address = ''
    try:
        instance_data = ec2.describe_instances(
            InstanceIds=[instance_id]
        )
        logger.debug(instance_data)
        public_ip_address = instance_data['Reservations'][0]['Instances'][0]['PublicIpAddress']

    except ClientError as e:
        logger.debug(e)
        return public_ip_address

    return public_ip_address


def create_health_check(ip_address: str):
    """Create Route 53 Health Check for given IP Address


    :param ip_address: string
    :return: Health Check Id if the health check is successfully created, otherwise None
    """

    r53 = boto3.client('route53')
    health_check_id = ''
    try:
        # Create Health Check
        create_health_check_response = r53.create_health_check(
            CallerReference=str(uuid.uuid1()),
            HealthCheckConfig={
                'IPAddress': ip_address,
                'Port': 22,
                'Type': 'TCP'
            }
        )

        # Apply Tags to health check
        health_check_id = create_health_check_response['HealthCheck']['Id']
        logger.debug(health_check_id)
        health_check_name = 'sema-bastion-{}'.format(ip_address.replace('.', '-'))
        r53.change_tags_for_resource(
            ResourceType='healthcheck',
            ResourceId=health_check_id,
            AddTags=[
                {
                    'Key': 'Name',
                    'Value': health_check_name
                },
            ]
        )

    except ClientError as e:
        logger.debug(e)
        return health_check_id

    logger.debug(json.dumps(create_health_check_response))
    return health_check_id


def delete_health_check(health_check_id: str):
    """Delete Route 53 Health Check for given IP Address


    :param health_check_id: string
    :return: Health Check Id if the health check is successfully created, otherwise None
    """

    r53 = boto3.client('route53')
    try:
        response = r53.delete_health_check(
            HealthCheckId=health_check_id
        )

    except ClientError as e:
        logger.debug(e)
        return None

    return response


def manage_bastion_dns(event: str, context: str):
    """Handler function for the AWS Lambda


    :param event: string
    :param context: string
    :return: Success if the DNS operations were successful, otherwise None
    """

    response = None
    event_type = event['detail-type']
    instance_id = event['detail']['EC2InstanceId']
    logger.debug(instance_id)
    ip_address = get_instance_ip_address(instance_id)
    logger.debug(ip_address)

    # Create Health Check & DNS entry for Bastion Instance
    if event_type == 'EC2 Instance-launch Lifecycle Action':
        health_check_id = create_health_check(ip_address)
        response = manage_dns_recordset('CREATE', ip_address, health_check_id)
        if response is not None:
            logger.info('DNS record set and associated health check added for instance {}'
                         .format(instance_id))
        else:
            logger.warning('Creation of DNS record set and associated health check failed for instance {}'
                            .format(instance_id))

    # Remove DNS Entry & Health Check for Bastion Instance
    elif event_type == 'EC2 Instance-terminate Lifecycle Action':
        health_check_id = get_hc_id_for_ip_address(ip_address)
        response = manage_dns_recordset('DELETE', ip_address, health_check_id)
        response = delete_health_check(health_check_id)
        if response is not None:
            logger.info('DNS record set and associated health check removed for instance {}'
                         .format(instance_id))
        else:
            logger.warning('Removal of DNS record set and associated health check failed for instance {}'
                            .format(instance_id))

    # Not sure exactly going on...
    else:
        logger.warning('Instance lifecycle indeterminate.')

    return response


def get_hc_id_for_ip_address(ip_address: str):
    """Gets the Health Check ID for given IP Address


    :param ip_address: string
    :return: Health Check Id if it exists, otherwise None
    """

    r53 = boto3.client('route53')
    health_check_id = None
    try:
        health_checks = r53.list_health_checks()
        for k in health_checks['HealthChecks']:
            if k['HealthCheckConfig']['IPAddress'] == ip_address:
                health_check_id = k['Id']

    except ClientError as e:
        logger.debug(e)
        return None

    return health_check_id


def main():
    """Exercise bucket_exists()"""
    with open('tests/data/asg-instance-launching.json') as json_file:
        data = json.load(json_file)
        manage_bastion_dns(data, None)


if __name__ == '__main__':
    main()
