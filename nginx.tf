resource "digitalocean_droplet" "nginx" {
	image		=	"docker-20-04" # Ubuntu 20.04 with Docker preinstalled
	name		=	"fttranscendence.site"
	region		=	"lon1"
	size		=	"c-2"
	ssh_keys	=	[ digitalocean_ssh_key.ssh_key.fingerprint ]
	tags		=	[ "nginx", "external" ]
	monitoring	=	true

	connection {
		host = self.ipv4_address
		user = "root"
		type = "ssh"
		private_key = file(var.pvt_key)
		timeout = "5m"
	}

	provisioner "file" {
		source = "./scripts/mount_space.sh"
		destination = "/usr/bin/mount_space.sh"
	}

	provisioner "file" {
		source = "./config/nginx.conf"
		destination = "/tmp/default"
	}

	provisioner "file" {
		source = "./config/phpmyadmin"
		destination = "/tmp/phpmyadmin"
	}

	provisioner "file" {
		source = "./scripts/nginx/Dockerfile"
		destination = "/tmp/Dockerfile"
	}

	provisioner "remote-exec" {
		inline = [
			"chmod +x /usr/bin/mount_space.sh",

			"export DEBIAN_FRONTEND=noninteractive",
			"export SHARED=${var.shared_dir}",
			"export NFS=${digitalocean_record.nfs.fqdn}",

			"mount_space.sh $NFS $SHARED ${var.mount_point}",

			"mkdir -p /root/ctx",
			"cp /tmp/default /root/ctx/default",
			"cp /tmp/Dockerfile /root/ctx/Dockerfile",
			"cp /tmp/phpmyadmin /root/ctx/phpmyadmin",
			"cd /root/ctx",
			"sed -i -e 's/__PHP_ADDRESS__/${digitalocean_record.php.fqdn}/g' /root/ctx/default",
			"sed -i -e 's/__PHP_ADDRESS__/${digitalocean_record.php.fqdn}/g' /root/ctx/phpmyadmin",

			"docker build -t nginx .",
			"docker run --restart unless-stopped -d -p 80:80 -p 443:443 -v ${var.mount_point}:/var/www --name nginx_container nginx",
		]
	}
}
