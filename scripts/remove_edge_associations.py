import boto3
from botocore.exceptions import ClientError
import time

def detach_lambda_edge_associations(distribution_id):
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

def delete_lambda_edge_replicas(lambda_function_name):
    # Create a Lambda client in us-east-1 to list the replicas
    client = boto3.client('lambda', region_name='us-east-1')
    
    # List all versions to find aliases (which include replicas)
    response = client.list_versions_by_function(FunctionName=lambda_function_name)
    versions = response['Versions']

    for version in versions:
        # Skip $LATEST version
        if version['Version'] == '$LATEST':
            continue

        # Try to delete the alias (replica)
        for region in version['FunctionArn'].split(':'):
            if region.startswith("aws-region-"):
                target_region = region.split('-')[2]
                print(f"Deleting Lambda replica in region {target_region}")
                try:
                    regional_client = boto3.client('lambda', region_name=target_region)
                    regional_client.delete_function(FunctionName=lambda_function_name, Qualifier=version['Version'])
                    print(f"Deleted replica of version {version['Version']} in region {target_region}")
                except ClientError as e:
                    if e.response['Error']['Code'] == 'ResourceNotFoundException':
                        print(f"Replica not found in region {target_region}, skipping.")
                    else:
                        print(f"Failed to delete replica in region {target_region}: {e}")
    
    # Wait to ensure all replicas are deleted
    time.sleep(60)

    # Now delete the main function in us-east-1
    try:
        client.delete_function(FunctionName=lambda_function_name)
        print(f"Deleted Lambda function {lambda_function_name} in region us-east-1")
    except ClientError as e:
        print(f"Failed to delete Lambda function {lambda_function_name} in region us-east-1: {e}")
        print("Waiting for replication cleanup...")
        time.sleep(60)
        client.delete_function(FunctionName=lambda_function_name)
        print(f"Deleted Lambda function {lambda_function_name} in region us-east-1 after waiting for cleanup")

if __name__ == "__main__":
    import os

    distribution_id = os.getenv("DISTRIBUTION_ID")
    lambda_function_name = 'ndrd_EdgePresignLambda'

    if not distribution_id:
        raise ValueError("The DISTRIBUTION_ID environment variable is not set.")
    if not lambda_function_name:
        raise ValueError("The LAMBDA_FUNCTION_NAME environment variable is not set.")

    detach_lambda_edge_associations(distribution_id)  # Step 1: Remove the Lambda@Edge associations from the CloudFront distribution
    delete_lambda_edge_replicas(lambda_function_name) # Step 2: Delete all Lambda@Edge replicas and the main function
