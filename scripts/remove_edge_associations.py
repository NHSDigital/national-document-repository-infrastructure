import boto3
from botocore.exceptions import ClientError
import time

def remove_lambda_edge_associations(distribution_id):
    try:
        client = boto3.client('cloudfront')
        
        response = client.get_distribution_config(Id=distribution_id)
        config = response['DistributionConfig']
        etag = response['ETag']

        behaviors = []

        default_behavior = config.get('DefaultCacheBehavior', None)
        if default_behavior and 'LambdaFunctionAssociations' in default_behavior:
            behaviors.append(default_behavior)

        if 'CacheBehaviors' in config and config['CacheBehaviors']['Quantity'] > 0:
            behaviors.extend(config['CacheBehaviors']['Items'])

        for behavior in behaviors:
            if 'LambdaFunctionAssociations' in behavior:
                behavior['LambdaFunctionAssociations'] = {'Quantity': 0}

        client.update_distribution(
            Id=distribution_id,
            DistributionConfig=config,
            IfMatch=etag
        )

        print("Cleared Lambda@Edge associations from CloudFront distribution.")
    except ClientError as e:
        print(f"No Cloudfront Distribution with ID ${distribution_id} found.")
        raise

def delete_lambda_function_replicas(lambda_function_name):
    # List of all AWS regions
    regions = [region['RegionName'] for region in boto3.client('ec2').describe_regions()['Regions']]

    # Iterate through each region and attempt to delete the Lambda function
    for region in regions:
        client = boto3.client('lambda', region_name=region)
        try:
            client.delete_function(FunctionName=lambda_function_name)
            print(f"Deleted Lambda function {lambda_function_name} in region {region}")
        except ClientError as e:
            if e.response['Error']['Code'] == 'ResourceNotFoundException':
                print(f"Lambda function {lambda_function_name} not found in region {region}, skipping.")
            elif e.response['Error']['Code'] == 'InvalidParameterValueException' and region == 'us-east-1':
                print(f"Failed to delete Lambda function {lambda_function_name} in region us-east-1: {e}")
                print("Waiting for replication cleanup...")
                time.sleep(30)
                client.delete_function(FunctionName=lambda_function_name)
                print(f"Deleted Lambda function {lambda_function_name} in region us-east-1 after waiting for cleanup")
            else:
                print(f"Error deleting Lambda function {lambda_function_name} in region {region}: {e}")

if __name__ == "__main__":
    import os

    distribution_id = os.getenv("DISTRIBUTION_ID")
    lambda_function_name = 'ndrd_EdgePresignLambda'

    if not distribution_id:
        raise ValueError("The DISTRIBUTION_ID environment variable is not set.")
    if not lambda_function_name:
        raise ValueError("The LAMBDA_FUNCTION_NAME environment variable is not set.")

    remove_lambda_edge_associations(distribution_id)
    delete_lambda_function_replicas(lambda_function_name)
