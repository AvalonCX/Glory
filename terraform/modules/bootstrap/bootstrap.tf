resource "aws_kms_key" "local_terraform_states3key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "local_terraform_s3_encryption" {
  bucket = aws_s3_bucket.avalon-glory-terrafm-state-mgmt-bucket-bar.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.local_terraform_states3key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_acl" "local_terraform_s3_acl" {
  bucket = aws_s3_bucket.avalon-glory-terrafm-state-mgmt-bucket-bar.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "local_terraform_s3_versioning" {
  bucket = aws_s3_bucket.avalon-glory-terrafm-state-mgmt-bucket-bar.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "avalon-glory-terrafm-state-mgmt-bucket-bar" {
  bucket = var.name_of_s3_bucket

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Terraform = "true"
  }
}

# Build a DynamoDB to use for terraform state locking
resource "aws_dynamodb_table" "avalon-glory_tf_s3_lock_state" {
  name = var.dynamo_db_table_name

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"
  attribute {

    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = var.dynamo_db_table_name
    BuiltBy = "Terraform"
  }
}