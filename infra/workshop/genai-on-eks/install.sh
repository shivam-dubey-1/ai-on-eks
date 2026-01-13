#!/bin/bash
# Copy the base into the folder
mkdir -p ./terraform/_LOCAL
cp -r ../../base/terraform/* ./terraform/_LOCAL

# Replace bucket naming in s3.tf
if [ -f "./terraform/_LOCAL/s3.tf" ]; then
  echo "Updating S3 bucket naming..."
  sed -i.bak 's/bucket_prefix = var.s3_models_bucket_name == "" ? "${local.name}-models-${local.region}-" : null/bucket = var.s3_models_bucket_name != "" ? var.s3_models_bucket_name : "genai-models-${data.aws_caller_identity.current.account_id}"/g' ./terraform/_LOCAL/s3.tf
  sed -i.bak '/bucket        = var.s3_models_bucket_name != "" ? var.s3_models_bucket_name : null/d' ./terraform/_LOCAL/s3.tf
  rm -f ./terraform/_LOCAL/s3.tf.bak
fi

# Append s3-workshop.tf to s3.tf
if [ -f "./terraform/s3-workshop.tf" ]; then
  echo "Appending s3-workshop.tf to s3.tf..."
  cat ./terraform/s3-workshop.tf >> ./terraform/_LOCAL/s3.tf
fi

cd terraform/_LOCAL
source ./install.sh
