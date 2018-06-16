import boto3
import os
import zipfile

S3_BUCKET = 'osf-bryan'
s3_client = boto3.client('s3')


def download_unzip_upload_delete(s3_key):
    local_directory = '/tmp/%s' % s3_key[22:26]
    local_key = '/tmp/%s' % s3_key[22:]
    destination = s3_key[22:26]
    s3_client.download_file(S3_BUCKET, s3_key, local_key)
    zf = zipfile.ZipFile(local_key)
    zf.extractall('/tmp/')

    for root, dirs, files in os.walk(local_directory):
        for filename in files:
            local_path = os.path.join(root, filename)
            relative_path = os.path.relpath(local_path, local_directory)
            s3_path = os.path.join(destination, relative_path)
            print('Searching "%s" in "%s"' % (s3_path, S3_BUCKET))
            try:
                s3_client.head_object(S3_BUCKET, Key=s3_path)
                print("Path found on S3! Skipping %s..." % s3_path)
            except:
                print("Uploading %s..." % s3_path)
                s3_client.upload_file(local_path, S3_BUCKET, s3_path)
                os.remove(local_path)
    os.remove(local_key)


def main():
    s3_objects = s3_client.list_objects(Bucket=S3_BUCKET,
                                        Prefix='Structured Study Data')
    for s3_object in s3_objects['Contents']:
        if 'zip' in s3_object['Key']:
            download_unzip_upload_delete(s3_object['Key'])
