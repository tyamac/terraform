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
  name       = (var.subnet_name)
  network_id = (openstack_networking_network_v2.network_1.id)
  cidr       = (var.cidr)
  ip_version = 4
}

#----------------------------------------------#
# Router
#----------------------------------------------#
resource "openstack_networking_router_v2" "router_1" {
  name                = (var.router_name)
  admin_state_up      = true
  external_network_id = (var.external_network_id)
}
resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = (openstack_networking_router_v2.router_1.id)
  subnet_id = (openstack_networking_subnet_v2.subnet_1.id)
}

#----------------------------------------------#
# Floating IP
#----------------------------------------------#
# resource "openstack_compute_floatingip_v2" "floatip_1" {
#   pool = "fip-net"
# }

#----------------------------------------------#
# Compute
#----------------------------------------------#
# resource "openstack_compute_instance_v2" "terraform-test-server" {
#   name = (var.openstack_server_name)
#   image_id = (var.openstack_image_id)
#   flavor_id = (var.flavor_id)
# }
