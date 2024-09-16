import boto3
from botocore.exceptions import ClientError


def log(message):
    print(message, flush=True)


def detach_lambda_edge_associations(distribution_id: str):
    try:
        client = boto3.client("cloudfront")

        response = client.get_distribution_config(Id=distribution_id)
        config = response["DistributionConfig"]
        etag = response["ETag"]

        behaviors: list[dict] = []
        default_behavior = config.get("DefaultCacheBehavior", None)
        if (
            default_behavior
            and "LambdaFunctionAssociations" in default_behavior
            and default_behavior["LambdaFunctionAssociations"]["Quantity"] > 0
        ):
            behaviors.append(default_behavior)

        if "CacheBehaviors" in config and config["CacheBehaviors"]["Quantity"] > 0:
            behaviors.extend(config["CacheBehaviors"]["Items"])

        for behavior in behaviors:
            if "LambdaFunctionAssociations" in behavior:
                behavior["LambdaFunctionAssociations"] = {"Quantity": 0}

        client.update_distribution(
            Id=distribution_id, DistributionConfig=config, IfMatch=etag
        )

        log("Cleared Lambda@Edge associations from CloudFront distribution.")
    except ClientError as e:
        log(f"Error removing associations for distribution {distribution_id}: {e}")
        raise


if __name__ == "__main__":
    import os

    distribution_id = os.getenv("DISTRIBUTION_ID")
    lambda_function_name = os.getenv("LAMBDA_FUNCTION_NAME")

    if not distribution_id:
        raise ValueError("The DISTRIBUTION_ID environment variable is not set.")
    if not lambda_function_name:
        raise ValueError("The LAMBDA_FUNCTION_NAME environment variable is not set.")

    detach_lambda_edge_associations(distribution_id)
