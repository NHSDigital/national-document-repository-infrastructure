import boto3
from botocore.exceptions import ClientError
import time

def log(message):
    print(message, flush=True)

def detach_lambda_edge_associations(distribution_id):
    try:
        client = boto3.client('cloudfront')
        
        response = client.get_distribution_config(Id=distribution_id)
        config = response['DistributionConfig']
        etag = response['ETag']

        behaviors = []

        default_behavior = config.get('DefaultCacheBehavior', None)
        if (default_behavior and 
                'LambdaFunctionAssociations' in default_behavior and 
                default_behavior['LambdaFunctionAssociations']['Quantity'] > 0):
            behaviors.append(default_behavior)

        if ('CacheBehaviors' in config and config['CacheBehaviors']['Quantity'] > 0):
            behaviors.extend(config['CacheBehaviors']['Items'])

        for behavior in behaviors:
            if 'LambdaFunctionAssociations' in behavior:
                behavior['LambdaFunctionAssociations'] = {'Quantity': 0}

        client.update_distribution(
            Id=distribution_id,
            DistributionConfig=config,
            IfMatch=etag
        )

        log("Cleared Lambda@Edge associations from CloudFront distribution.")
    except ClientError as e:
        log(f"Error removing associations for distribution {distribution_id}: {e}")
        raise

def delete_lambda_function_with_retries(lambda_function_name, max_retries=10):
    client = boto3.client('lambda', region_name='us-east-1')
    wait_time = 30  # initial wait time in seconds

    for attempt in range(1, max_retries + 1):
        try:
            client.delete_function(FunctionName=lambda_function_name)
            log(f"Successfully deleted Lambda function {lambda_function_name} in region us-east-1")
            return
        except ClientError as e:
            error_code = e.response['Error']['Code']
            if error_code == 'InvalidParameterValueException':
                log(f"Attempt {attempt} failed: {e}")
                log(f"Waiting {wait_time} seconds before retrying...")
                time.sleep(wait_time)
                wait_time *= 2  # exponential backoff
            elif error_code == 'ResourceNotFoundException':
                log(f"Function {lambda_function_name} not found. Exiting retries.")
                return
            else:
                log(f"Unexpected error: {e}")
                raise
    
    log(f"Failed to delete Lambda function {lambda_function_name} after {max_retries} attempts.")

if __name__ == "__main__":
    import os

    distribution_id = os.getenv("DISTRIBUTION_ID")
    lambda_function_name = os.getenv("LAMBDA_FUNCTION_NAME")

    if not distribution_id:
        raise ValueError("The DISTRIBUTION_ID environment variable is not set.")
    if not lambda_function_name:
        raise ValueError("The LAMBDA_FUNCTION_NAME environment variable is not set.")

    detach_lambda_edge_associations(distribution_id)  # Step 1: Remove the Lambda@Edge associations from the CloudFront distribution
    
    # Retry loop with 1-minute intervals
    retries = 5
    for i in range(retries):
        log(f"Retry {i+1}/{retries}: Attempting to delete Lambda function after 1 minute...")
        delete_lambda_function_with_retries(lambda_function_name, max_retries=1)
        time.sleep(60)  # Wait for 1 minute before the next attempt

    log("Finished all retries.")
