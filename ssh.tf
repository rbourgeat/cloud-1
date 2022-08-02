resource "digitalocean_ssh_key" "ssh_key" {
  name			= var.ssh_name
  public_key	= file(local.pub_key)
}
