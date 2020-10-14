#----------------------------------------------#
# Firewall Rule
#----------------------------------------------#
resource "openstack_fw_rule_v1" "rule_1" {
  name             = "all_allow"
  description      = "all traffic allow"
  action           = "allow"
  protocol         = "any"
  destination_port = ""
  enabled          = "true"
}

#----------------------------------------------#
# Firewall Policy
#----------------------------------------------#
resource "openstack_fw_policy_v1" "policy_1" {
  name = "my-fw-policy"

  rules = [
    (openstack_fw_rule_v1.rule_1.id),
  ]
}

#----------------------------------------------#
# Firewall
#----------------------------------------------#
resource "openstack_fw_firewall_v1" "firewall_1" {
  name      = "my-firewall"
  policy_id = (openstack_fw_policy_v1.policy_1.id)
  associated_routers = [
    (var.router_id),
  ]
}
