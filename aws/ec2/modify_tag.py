import boto3


region = 'us-west-2'
ip_addresses = """
54.148.120.159
54.69.207.136
52.11.175.67
52.26.190.25
"""

schedule = 'ec2_stopstart_vn4'

boto3.setup_default_session(region_name=region)
client = boto3.client('ec2')

response = client.describe_instances(
        Filters=[{'Name': 'ip-address',
                  'Values': list(filter(lambda x: x, ip_addresses.split('\n')))}])

instance_ids = []
for re in response['Reservations']:
    for i in re['Instances']:
        instance_ids.append(i['InstanceId'])

client.create_tags(
    Resources=instance_ids,
    Tags=[{'Key': 'Schedule', 'Value': schedule}])
