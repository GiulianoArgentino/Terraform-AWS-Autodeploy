resource "local_file" "ansible-secret-vars" {
  content = <<DOC
tf_aws_access_key: ${var.aws_access_key}
tf_aws_secret_key: ${var.aws_secret_key}
tf_aws_session_token: ${var.aws_session_token}
tf_aws_region: ${var.aws_region}
tf_aws_s3_bucket: ${var.aws_s3_bucket}
tf_dbendpoint: "${var.dbaddress}:${var.dbport}"
tf_dbaddress: ${var.dbaddress}
tf_dbport: ${var.dbport}
tf_dbuser: ${var.dbuser}
tf_dbpassword: ${var.dbpassword}
    DOC
  filename = "ansible/roles/webapp/vars/secrets.yml"
}

resource "local_file" "packer-secret-vars" {
  content = <<DOC
access_key="${var.aws_access_key}"
secret_key="${var.aws_secret_key}"
token="${var.aws_session_token}"
region="${var.aws_region}"
    DOC
  filename = "packer/secrets/secrets.pkrvars.hcl"
}