terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

data "digitalocean_vpc" "vpc" {
  name = "default-lon1"
}

variable "do_token" {}
variable "pvt_key" {}
variable "ssh_name" {}
variable "spaces_key" {}
variable "spaces_secret" {}

variable "wp_admin_user" {
  type = string
}

variable "wp_admin_pass"{
  type = string
}

variable "wp_admin_email" {
  type = string
}

variable "wp_reg_user" {
  type = string
}

variable "wp_reg_pass" {
  type = string
}

variable "mount_point" {
  type    = string
  default = "/tmp/mount"
}

variable "shared_dir" {
  default = "/srv/nfs"
  type    = string
}

provider "digitalocean" {
  token = var.do_token
  spaces_access_id = var.spaces_key
  spaces_secret_key = var.spaces_secret
}

locals {
  pub_key = "${var.pvt_key}.pub"

  private_host = digitalocean_database_cluster.cluster.private_host
  database = digitalocean_database_cluster.cluster.database
  database_port = digitalocean_database_cluster.cluster.port
  username = digitalocean_database_cluster.cluster.user
  password = nonsensitive(digitalocean_database_cluster.cluster.password)

  fqdn = digitalocean_record.default.fqdn
  phpmyadmin_fqdn = digitalocean_record.phpmyadmin_domain.fqdn

  wp_url = "https://${digitalocean_domain.domain.name}"
}

output "database_private_host" {
  value = local.private_host
}

output "database_name" {
  value = local.database
}

output "database_username" {
  value = local.username
}

output "database_password" {
  value = local.password
}

output "fqdn" {
  value = local.fqdn
}

output "phpmyadmin_fqdn" {
  value = local.phpmyadmin_fqdn
}

output "IPs" {
  value = [
    "nginx: ${digitalocean_droplet.nginx.ipv4_address}",
    "php: ${digitalocean_droplet.php.ipv4_address}",
    "nfs: ${digitalocean_droplet.nfs.ipv4_address_private}",
  ]
}

output "misc" {
  value = [
    "wp_url: ${local.wp_url}",
    "wp_admin_user: ${var.wp_admin_user}",
    "wp_admin_pass: ${var.wp_admin_pass}",
    "phpmyadmin_fqdn: ${local.phpmyadmin_fqdn}",
  ]
}
