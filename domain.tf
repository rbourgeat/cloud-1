variable "domain_name" {
	type = string
	default = "fttranscendence.site"
}

resource "digitalocean_domain" "domain" {
	name			=	"${var.domain_name}"
}

resource "digitalocean_record" "default" {
	domain			=	"${digitalocean_domain.domain.name}"
	name			=	"@"
	type			=	"A"
	value			=	"${digitalocean_droplet.nginx.ipv4_address}"

	ttl				=	3600
}

resource "digitalocean_record" "phpmyadmin_domain" {
	domain			=	"${digitalocean_domain.domain.id}"
	name			=	"phpmyadmin"
	type			=	"A"
	value			=	"${digitalocean_droplet.nginx.ipv4_address}"

	ttl				=	3600
}

resource "digitalocean_record" "www" {
	domain			=	"${digitalocean_domain.domain.id}"
	name			=	"www"
	type			=	"CNAME"
	value			=	"${digitalocean_record.default.fqdn}."

	ttl				=	3600
}

resource "digitalocean_record" "php" {
	domain			=	"${digitalocean_domain.domain.id}"
	name			=	"php"
	type			=	"A"
	value			=	"${digitalocean_droplet.php.ipv4_address}"

	ttl				=	3600
}

resource "digitalocean_record" "nfs" {
	domain			=	"${digitalocean_domain.domain.id}"
	name			=	"nfs"
	type			=	"A"
	value			=	"${digitalocean_droplet.nfs.ipv4_address_private}"

	ttl				=	3600
}
