resource "digitalocean_firewall" "firewall" {
	name			= "entrypoint"
	tags 			= [ "external" ]

	inbound_rule {
		protocol	= "tcp"
		port_range	= "22"
 		source_addresses = ["0.0.0.0/0", "::/0"]
	}

	inbound_rule {
		protocol	= "tcp"
		port_range	= "80"
		source_addresses = ["0.0.0.0/0", "::/0"]
	}

	inbound_rule {
		protocol	= "icmp"
		source_addresses = ["0.0.0.0/0", "::/0"]
	}

	inbound_rule {
		protocol	= "tcp"
		port_range	= "443"
		source_addresses = ["0.0.0.0/0", "::/0"]
	}

	outbound_rule {
		protocol	= "tcp"
		port_range	= "1-65535"
		destination_addresses = ["0.0.0.0/0", "::/0"]
	}

	outbound_rule {
		protocol	= "icmp"
		destination_addresses = ["0.0.0.0/0", "::/0"]
	}

	outbound_rule {
		protocol	= "udp"
		port_range	= "1-65535"
		destination_addresses = ["0.0.0.0/0", "::/0"]
	}
}

// Needs to be applied only to the php droplet
resource "digitalocean_firewall" "php_firewall" {
	name					=	"php"
	droplet_ids				=	["${digitalocean_droplet.php.id}"]

	inbound_rule {
		protocol			=	"tcp"
		port_range			=	"9000"
		source_droplet_ids	=	["${digitalocean_droplet.nginx.id}"]
	}

	inbound_rule {
		protocol			=	"udp"
		port_range			=	"9000"
		source_droplet_ids	=	["${digitalocean_droplet.nginx.id}"]
	}
}
