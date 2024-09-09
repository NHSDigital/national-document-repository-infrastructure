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

def delete_lambda_function(lambda_function_name, max_retries, initial_wait_time):
    client = boto3.client('lambda', region_name='us-east-1')
    wait_time = initial_wait_time
    limit = max_retries + 1

    for attempt in range(1, limit):
        try:
            log(f"{attempt}/{limit} Removing CloudFront and Lambda@Edge associations")
            client.delete_function(FunctionName=lambda_function_name)
            log(f"Successfully deleted Lambda function {lambda_function_name} in region us-east-1")
            return True
        except ClientError as e:
            error_code = e.response['Error']['Code']
            if error_code == 'InvalidParameterValueException':
                log(f"Attempt {attempt} failed: {e}")
                log(f"Waiting {wait_time} seconds before retrying...")
                time.sleep(wait_time)
            elif error_code == 'ResourceNotFoundException':
                log(f"Function {lambda_function_name} successfully deleted.")
                return True
            else:
                log(f"Unexpected error: {e}")
                raise

    log(f"Failed to delete Lambda function {lambda_function_name} after {max_retries} attempts.")
    return False

if __name__ == "__main__":
    import os

    distribution_id = os.getenv("DISTRIBUTION_ID")
    lambda_function_name = os.getenv("LAMBDA_FUNCTION_NAME")

    if not distribution_id:
        raise ValueError("The DISTRIBUTION_ID environment variable is not set.")
    if not lambda_function_name:
        raise ValueError("The LAMBDA_FUNCTION_NAME environment variable is not set.")

    detach_lambda_edge_associations(distribution_id)  # Step 1: Remove Lambda@Edge associations from CloudFront distribution
    
    # Single retry loop for lambda deletion with 30 seconds interval
    if delete_lambda_function(lambda_function_name, max_retries=30, initial_wait_time=30):
        log("Lambda function deletion successful.")
    else:
        log("Lambda function deletion failed after all retries.")
