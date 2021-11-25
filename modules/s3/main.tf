# S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"
  tags = {
    Name = "${var.prefix_name}-${var.bucket_name}"
  }
}

# Clones deploy to workspace for copying the latest images
resource "null_resource" "clone_git_repo" {
  provisioner "local-exec" {
      command = "git -C 2TIN_ResearchProject pull || git clone https://github.com/d-ries/2TIN_ResearchProject.git"
  } 
}

# Add content to bucket
resource "aws_s3_bucket_object" "add_image_to_s3" {
  for_each = fileset("2TIN_ResearchProject/assets/images","*")
  acl = "public-read"
  bucket = aws_s3_bucket.my_bucket.id
  key = "${each.value}"
  source = "2TIN_ResearchProject/assets/images/${each.value}"
}
