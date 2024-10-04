import boto3

ec2 = boto3.resource('ec2')
# instance_name = 'ec2-mpg-server'

# instance_id = None

ec2_list = ec2.instances.all()
instance_exists = True

def lambda_handler(event, context):
    for instance in ec2_list:
        for tag in instance.tags:
            if tag['Key'] =='Environment' and tag['Value'] == 'Dev':
                instance_exists = True
                instance_id = instance.id
                ec2.Instance(instance_id).stop()
                print(f"An instance named '{instance_id}' is shutting .")
#                break
#            if instance_exists:
#                break
    
#   print(f" {instance_id}")

