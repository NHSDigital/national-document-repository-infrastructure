
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

    # Remove Lambda@Edge function associations
    if 'DefaultCacheBehavior' in config:
        config['DefaultCacheBehavior'].pop('LambdaFunctionAssociations', None)
    
    if 'CacheBehaviors' in config:
        for behavior in config['CacheBehaviors']['Items']:
            behavior.pop('LambdaFunctionAssociations', None)
    
    # Update the distribution config
    client.update_distribution(
        DistributionConfig=config,
        Id=distribution_id,
        IfMatch=etag
    )
    print(f"Lambda@Edge associations removed from CloudFront distribution {distribution_id}")

remove_lambda_edge_associations(distribution_id)