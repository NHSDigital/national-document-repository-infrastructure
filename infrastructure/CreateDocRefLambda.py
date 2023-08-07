import os
import uuid
import boto3
from botocore.exceptions import ClientError
import datetime


def lambda_handler(event, context):
    print("API Gateway event received - processing starts")
    s3_bucket_name = os.environ['DOCUMENT_STORE_BUCKET_NAME']
    s3_object_key = str(uuid.uuid4())
    try:
        body = event['body']
        create_document_reference_object(s3_bucket_name, s3_object_key, body)
        response = create_document_presigned_url_handler(s3_bucket_name, s3_object_key)
        
    except Exception as e:
        print(e)
        #create error response generator
        return e
    return response

def create_document_presigned_url_handler(s3_bucket_name, s3_object_key):
    # Generate a presigned S3 POST URL
    s3_client = boto3.client('s3', region_name='eu-west-2')

    try:
        response = s3_client.generate_presigned_post(s3_bucket_name,
                                                     s3_object_key,
                                                     Fields=None,
                                                     Conditions=None,
                                                     ExpiresIn=1800)
    except ClientError as e:
        print(e)
        return None

    # The response contains the presigned URL and required fields
    return response

def create_document_reference_object(s3_bucket_name, s3_object_key, document_request_body):
    s3_file_location = "s3://" + s3_bucket_name + "/" + s3_object_key
    print(document_request_body)
    new_document = NHSDocumentReference(file_location=s3_file_location,reference_id=s3_object_key, data=document_request_body)
    print("Input document reference filename: ", new_document.file_name)
    create_document_reference_in_dynamo_db(new_document)

def create_document_reference_in_dynamo_db(new_document):
    dynamodb = boto3.resource('dynamodb')
    dynamodb_name = os.environ['DOCUMENT_STORE_DYNAMODB_NAME']
    table = dynamodb.Table(dynamodb_name)
    table.put_item(
        Item=new_document.to_dict()
    )


class NHSDocumentReference:
    def __init__(self, reference_id, file_location, data) -> None:
        self.id = reference_id
        self.nhs_number = data['subject']['identifier']['value']
        self.content_type =  data['content'][0]['attachment']['contentType']
        self.file_name = data['description']
        self.created = datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%S.%fZ')
        self.deleted = None
        self.uploaded = None
        self.virus_scanner_result = "Not Scanned"
        self.file_location = file_location

    def set_uploaded(self) -> None:
        self.uploaded = datetime.now()

    def set_deleted(self) -> None:
        self.deleted = datetime.now()

    def set_virus_scanner_result(self, updated_virus_scanner_result) -> None:
        self.virus_scanner_result = updated_virus_scanner_result

    def update_location(self, updated_file_location):
        self.file_location = updated_file_location

    def is_uploaded(self) -> bool:
        return bool(self.uploaded)

    def to_dict(self):
        document_metadata = {
            "ID": str(self.id),
            "NhsNumber": self.nhs_number,
            "FileName": self.file_name,
            "Location": self.file_location,
            "Created": self.created,
            "ContentType": self.content_type,
            "VirusScanResult": self.virus_scanner_result,
        }
        return document_metadata