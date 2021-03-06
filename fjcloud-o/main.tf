#----------------------------------------------#
# Configure the OpenStack Provider
#----------------------------------------------#
provider "openstack" {
  user_name         = var.user_name
  tenant_name       = var.tenant_name
  tenant_id         = var.tenant_id
  user_domain_name  = var.user_domain_name
  project_domain_id = var.project_domain_id
  password          = var.password
  auth_url          = var.auth_url
  region            = var.region
}


#----------------------------------------------#
# External Network - Data Resource
#----------------------------------------------#
data "openstack_networking_network_v2" "external_network" {
  name = "fip-net"
}
data "openstack_images_image_v2" "windows" {
  name = (var.image_name)
}

output "image_id" {
  value = data.openstack_images_image_v2.windows.id
}

#----------------------------------------------#
# Network
#----------------------------------------------#
resource "openstack_networking_network_v2" "network_1" {
  name           = (var.network_name)
  admin_state_up = "true"
}

#----------------------------------------------#
# Subnet
#----------------------------------------------#
resource "openstack_networking_subnet_v2" "subnet_1" {
  name            = (var.subnet_name)
  network_id      = (openstack_networking_network_v2.network_1.id)
  cidr            = (var.cidr)
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

#----------------------------------------------#
# Router
#----------------------------------------------#
resource "openstack_networking_router_v2" "router_1" {
  name                = (var.router_name)
  admin_state_up      = true
  external_network_id = (data.openstack_networking_network_v2.external_network.id)
}
resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = (openstack_networking_router_v2.router_1.id)
  subnet_id = (openstack_networking_subnet_v2.subnet_1.id)
}

#----------------------------------------------#
# Security Groups
#----------------------------------------------#
module "secgroups" {
  source = "./modules/secgroups"
}

#----------------------------------------------#
# Firewall
#----------------------------------------------#
module "firewall" {
  source    = "./modules/firewall"
  router_id = (openstack_networking_router_v2.router_1.id)
}

#----------------------------------------------#
# Floating IP
#----------------------------------------------#
module "floatingip_1" {
  source = "./modules/floatingip"
}
output "floatingip_1" {
  value = (module.floatingip_1)
}

# module "floatingip_2" {
#   source = "./modules/floatingip"
# }
# output "floatingip_2" {
#   value = (module.floatingip_2)
# }

#----------------------------------------------#
# Compute
#----------------------------------------------#
resource "openstack_compute_instance_v2" "test_instance_1" {
  name      = (var.instance_name)
  image_id  = (data.openstack_images_image_v2.windows.id)
  flavor_id = (var.flavor_id)

  block_device {
    source_type = "image"
    volume_size = (var.volume_size)
  }

  network {
    uuid = (openstack_networking_network_v2.network_1.id)
  }

}
