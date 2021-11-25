#Build AMI

resource "null_resource" "ami-builder" {
  provisioner "local-exec" {
    command="packer init packer && packer build -force -var-file=packer/secrets/secrets.pkrvars.hcl packer"
  }
}
