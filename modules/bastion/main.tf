#Make bastion private key
resource "tls_private_key" "bastion-key" {
  algorithm = "RSA"
  rsa_bits = 4096
   lifecycle {
    create_before_destroy = true
  }
}

#Make bastion key pair
resource "aws_key_pair" "bastion-keypair" {
  key_name   = "${var.prefix_name}-bastion-key"
  public_key = tls_private_key.bastion-key.public_key_openssh
  
  provisioner "local-exec" {
    command="echo '${tls_private_key.bastion-key.private_key_pem}' > ${var.ssh_key_dir}/${aws_key_pair.bastion-keypair.key_name}.pem"  
  }
}

#Configure the EC2 instance in a public subnet
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.bastion-keypair.key_name
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = var.ssh_sg_id

  tags = {
    "Name" = "${var.prefix_name}-bastion"
  }
}