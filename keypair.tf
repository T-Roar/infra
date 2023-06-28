
resource "tls_private_key" "hammer" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "hammer" {
  key_name   = "last-hammer"
  public_key = tls_private_key.hammer.public_key_openssh
}

output "hammer" {
  value = {
    private_key = tls_private_key.hammer.private_key_pem
    public_key  = tls_private_key.hammer.private_key_openssh
  }
  sensitive = true
}