"""
add/remove suffix to Schedule tag
"""
import boto3

"""Change here"""
region = 'us-west-2'
ip_addresses = """
54.200.88.75
52.38.151.206
"""
suffix = '_20190909'
"""/Change here"""

boto3.setup_default_session(region_name=region)
client = boto3.client('ec2')

for ip_address in ip_addresses.split('\n'):
    if not ip_address:
        continue

    response = client.describe_instances(
            Filters=[{'Name': 'ip-address', 'Values': [ip_address]}])
    instance = response['Reservations'][0]['Instances'][0]

    current_value = ''
    for tag in instance['Tags']:
        if tag['Key'] == 'Schedule':
            current_value = tag['Value']
            break

    if not current_value:
        continue

    if current_value.endswith(suffix):
        new_value = current_value.replace(suffix, '')
    else:
        new_value = current_value + suffix
    client.create_tags(
        Resources=[instance['InstanceId']],
        Tags=[{'Key': 'Schedule', 'Value': new_value}])
