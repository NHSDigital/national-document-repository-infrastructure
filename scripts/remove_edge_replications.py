import boto3
import os


function_name = os.getenv('WORKSPACE') + '_EdgePresignLambda'

if not function_name:
    raise ValueError("The LAMBDA_FUNCTION_NAME environment variable is not set.")

def delete_lambda_function_across_regions(function_name):
    # Initialize EC2 client to get regions
    ec2_client = boto3.client('ec2')
    lambda_client = boto3.client('lambda')

    # Get the list of all AWS regions
    regions = [region['RegionName'] for region in ec2_client.describe_regions()['Regions']]

    for region in regions:
        try:
            # Initialize Lambda client for the specific region
            lambda_client_region = boto3.client('lambda', region_name=region)

            # Delete the Lambda function
            lambda_client_region.delete_function(FunctionName=function_name)
            print(f"Lambda function {function_name} deleted in region {region}")

        except lambda_client_region.exceptions.ResourceNotFoundException:
            print(f"Lambda function {function_name} not found in region {region}")
        except Exception as e:
            print(f"Failed to delete Lambda function {function_name} in region {region}: {str(e)}")

delete_lambda_function_across_regions(function_name)