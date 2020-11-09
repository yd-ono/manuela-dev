import os
import boto3


def main():


    bucket_name = os.environ['BUCKET_NAME']
    s3_access_key = os.environ['AWS_ACCESS_KEY_ID'] 
    s3_secret_access_key = os.environ['AWS_SECRET_ACCESS_KEY']
    s3_endpoint = os.environ['S3_ENDPOINT'] 


    #
    # OCS S3 + AWS S3 compatible
    #
    # E.g.:
    # - OCS s3_endpoint = 
    # - AWS s3_endpoint = s3.eu-west-1.amazonaws.com
    #
    
    
    s3 = boto3.client(service_name='s3', aws_access_key_id = s3_access_key,
                      aws_secret_access_key = s3_secret_access_key, 
                      endpoint_url="https://" + s3_endpoint, use_ssl=True, verify=False)

    
    paginator = s3.get_paginator('list_objects_v2')
    pages = paginator.paginate(Bucket=bucket_name)
    
    for page in pages:
        for obj in page['Contents']:
            print(obj['Key'])


if __name__ == '__main__':
    main()


