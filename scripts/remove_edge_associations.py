
import boto3
import os
import json

# Get environment variables
distribution_id = os.getenv('DISTRIBUTION_ID')

if not distribution_id:
    raise ValueError("The DISTRIBUTION_ID environment variable is not set.")

# Initialize CloudFront client
client = boto3.client('cloudfront')

def remove_lambda_edge_associations(distribution_id):
    # Get current distribution config
    response = client.get_distribution_config(Id=distribution_id)
    config = response['DistributionConfig']
    etag = response['ETag']

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
    
    # Update the distribution config
    client.update_distribution(
        DistributionConfig=config,
        Id=distribution_id,
        IfMatch=etag
    )
    print(f"Lambda@Edge associations removed from CloudFront distribution {distribution_id}")

remove_lambda_edge_associations(distribution_id)