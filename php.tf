
resource "digitalocean_droplet" "php" {
	image				=	"docker-20-04"
	name				=	"php.fttranscendence.site"
	region				=	"lon1"
	size				=	"c-2"
	ssh_keys			=	[ digitalocean_ssh_key.ssh_key.fingerprint ]
	tags				=	[ "php", "external" ]
	monitoring			=	true

	connection {
		host = self.ipv4_address
		user = "root"
		type = "ssh"
		private_key = file(var.pvt_key)
		timeout = "5m"
	}

	provisioner "file" {
		source = "scripts/mount_space.sh"
		destination = "/usr/bin/mount_space.sh"
	}

	provisioner "file" {
		source = "config/php-fpm.conf"
		destination = "/tmp/php-fpm.conf"
	}

	provisioner "file" {
		source = "config/www.conf"
		destination = "/tmp/www.conf"
	}

	provisioner "file" {
		source = "scripts/php/Dockerfile"
		destination = "/tmp/Dockerfile"
	}

	provisioner "file" {
		source = "scripts/php/script.sh"
		destination = "/tmp/script.sh"
	}

	provisioner "file" {
		source = "scripts/php/remote-exec.sh"
		destination = "/tmp/remote-exec.sh"
	}

	provisioner "remote-exec" {
		inline = [
			"export WP_URL=${local.wp_url}",
			"export WP_FQDN=${var.domain_name}",
			"export WP_ADMIN_USER=${var.wp_admin_user}",
			"export WP_ADMIN_PASS=${var.wp_admin_pass}",
			"export WP_ADMIN_EMAIL=${var.wp_admin_email}",
			"export WP_REG_USER=${var.wp_reg_user}",
			"export WP_REG_USER_PASS=${var.wp_reg_pass}",

			"export SHARED=${var.shared_dir}",
			"export NFS=${digitalocean_record.nfs.fqdn}",

			"chmod +x /tmp/remote-exec.sh",
			"/tmp/remote-exec.sh ${var.mount_point}",
		]
	}
}
