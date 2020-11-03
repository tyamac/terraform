resource "openstack_networking_secgroup_v2" "secgroup_1" {
  name = "tf-sample-sg"
  description = "tf sample security group."
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "22"
  port_range_max    = "22"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = (openstack_networking_secgroup_v2.secgroup_1.id)
}
