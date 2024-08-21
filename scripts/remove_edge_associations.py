import boto3
import time

def remove_lambda_edge_associations(distribution_id):
    client = boto3.client('cloudfront')
    
    # Get the current distribution configuration
    response = client.get_distribution_config(Id=distribution_id)
    config = response['DistributionConfig']
    etag = response['ETag']

    # Log the CacheBehaviors for debugging
    print(f"BEHAVIOURS: {config.get('CacheBehaviors')}")

    # Check for default and cache behaviors
    behaviors = []

    # Default behavior
    default_behavior = config.get('DefaultCacheBehavior', None)
    if default_behavior and 'LambdaFunctionAssociations' in default_behavior:
        behaviors.append(default_behavior)

    # Cache behaviors
    if 'CacheBehaviors' in config and config['CacheBehaviors']['Quantity'] > 0:
        behaviors.extend(config['CacheBehaviors']['Items'])

    for behavior in behaviors:
        if 'LambdaFunctionAssociations' in behavior:
            # Clear all Lambda function associations
            behavior['LambdaFunctionAssociations'] = {'Quantity': 0}

    # Update the distribution configuration with the cleared Lambda associations
    client.update_distribution(
        Id=distribution_id,
        DistributionConfig=config,
        IfMatch=etag
    )

    print("Cleared Lambda@Edge associations from CloudFront distribution.")

def delete_lambda_function(lambda_function_name):
    # Create a Lambda client in us-east-1 region
    client = boto3.client('lambda', region_name='us-east-1')

    try:
        # Delete the Lambda function (this will only delete the function if it has no remaining associations)
        client.delete_function(FunctionName=lambda_function_name)
        print(f"Deleted Lambda function {lambda_function_name} in region us-east-1")

    except client.exceptions.InvalidParameterValueException as e:
        print(f"Failed to delete Lambda function {lambda_function_name} in region us-east-1: {e}")
        print("Waiting for replication cleanup...")

        # Retry deleting the function after a delay
        time.sleep(30)
        client.delete_function(FunctionName=lambda_function_name)
        print(f"Deleted Lambda function {lambda_function_name} in region us-east-1 after waiting for cleanup")

if __name__ == "__main__":
    import os

    distribution_id = os.getenv("DISTRIBUTION_ID")
    lambda_function_name = os.getenv("LAMBDA_FUNCTION_NAME")

    if not distribution_id:
        raise ValueError("The DISTRIBUTION_ID environment variable is not set.")
    if not lambda_function_name:
        raise ValueError("The LAMBDA_FUNCTION_NAME environment variable is not set.")

    remove_lambda_edge_associations(distribution_id)
    delete_lambda_function(lambda_function_name)