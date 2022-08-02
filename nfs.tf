resource "digitalocean_droplet" "nfs" {
  image = "ubuntu-20-04-x64"
  name = "nfs.fttranscendence.site"
  region = "lon1"
  size = "s-1vcpu-2gb-amd"
  ssh_keys = [ digitalocean_ssh_key.ssh_key.fingerprint ]
  tags = ["nfs", "internal"]
  monitoring = true

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "5m"
  }

  provisioner "file" {
    source = "scripts/nfs/script.sh"
    destination = "/usr/bin/script.sh"
  }

  provisioner "file" {
    source = "config/wp-config.php"
    destination = "/tmp/wp-config.php"
  }

  provisioner "file" {
    source = "config/pma-config.inc.php"
    destination = "/tmp/pma-config.inc.php"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /usr/bin/script.sh",

      "export DB_HOST=${local.private_host}",
      "export DB_NAME=${local.database}",
      "export DB_USER=${local.username}",
      "export DB_PASS=${local.password}",
      "export DB_PORT=${local.database_port}",
      "export HOSTS=${data.digitalocean_vpc.vpc.ip_range}",

      "export SHARED=${var.shared_dir}",

      "/usr/bin/script.sh",
    ]
  }
}
