from flask import Flask, jsonify, request
import boto3
from botocore.exceptions import ClientError
import urllib.parse

app = Flask(__name__)

# AWS S3 Configuration
AWS_REGION = "ap-south-1"  # Update to your region
BUCKET_NAME = "terraform-accessible-s3-bucket-973148501077"  # Replace with your bucket name

# Initialize S3 client
s3_client = boto3.client('s3', region_name=AWS_REGION)

@app.route('/get-file', methods=['GET'])
def get_file():
    """
    Fetches the metadata or content of a file in the S3 bucket based on the provided path.
    Query parameter: file_path (e.g., "image(4).png")
    """
    file_path = request.args.get('file_path')
    
    if not file_path:
        return jsonify({"error": "Missing required query parameter 'file_path'"}), 400

    # Decode URL-encoded file path (e.g., handling spaces encoded as %20)
    file_path = urllib.parse.unquote(file_path)

    try:
        # Get object metadata from S3
        response = s3_client.head_object(Bucket=BUCKET_NAME, Key=file_path)

        # Return file metadata (you can adjust the response based on your requirements)
        metadata = {
            "FilePath": file_path,
            "Bucket": BUCKET_NAME,
            "Size": response['ContentLength'],
            "LastModified": response['LastModified'].isoformat(),
            "ContentType": response['ContentType'],
        }

        return jsonify({"file_metadata": metadata})

    except ClientError as e:
        error_code = e.response['Error']['Code']
        error_message = e.response['Error']['Message']
        return jsonify({"error": f"Error fetching file: {error_code} - {error_message}"}), 500


@app.route('/list-bucket-content', defaults={'path': ''}, methods=['GET'])
@app.route('/list-bucket-content/<path:path>', methods=['GET'])
def list_bucket_content(path):
    """
    Lists the contents of the bucket or a specific folder.
    """
    try:
        # Decode URL-encoded path (handling spaces and special characters)
        path = urllib.parse.unquote(path)
        
        # Adjust the prefix to search in the specified directory
        prefix = path if path.endswith('/') else f"{path}/" if path else ''

        # List objects in the specified prefix (folder) in S3
        response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=prefix, Delimiter='/')

        # Collect subdirectories (CommonPrefixes) and files (Contents)
        content = []
        
        # Extract subdirectories
        if 'CommonPrefixes' in response:
            content.extend([prefix['Prefix'].rstrip('/').split('/')[-1] for prefix in response['CommonPrefixes']])
        
        # Extract files
        if 'Contents' in response:
            content.extend([obj['Key'].split('/')[-1] for obj in response['Contents'] if obj['Key'] != prefix])

        return jsonify({"content": content})

    except ClientError as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9000, debug=True)
