#----------------------------------------------#
# Floating IP
#----------------------------------------------#
resource "openstack_networking_floatingip_v2" "fip" {
  pool = "fip-net"
}

output "address" {
  value = (openstack_networking_floatingip_v2.fip.address)
}
