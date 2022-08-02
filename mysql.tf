resource "digitalocean_database_cluster" "cluster" {
	name			=	"mysql-cluster"
	engine			=	"mysql"
	version			=	"8"
	region			=	"lon1"
	size			=	"db-s-1vcpu-1gb"
	node_count		=	1
	tags			=	[ "mysql", "internal" ]
}

// Allow only the php droplet to access the cluster
resource "digitalocean_database_firewall" "cluster_firewall" {
	cluster_id		=	"${digitalocean_database_cluster.cluster.id}"

	rule {
		type		=	"droplet"
		value		=	"${digitalocean_droplet.php.id}"
	}
}
