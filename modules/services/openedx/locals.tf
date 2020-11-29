locals {
  http_port = 80
  https_port = 443
  cms_port = 18010
  prometheus_tcp_port = 19100
  prometheus_udp_port = 19100
  consul_tcp_from_port = 8301
  consul_tcp_to_port = 8302
  consul_udp_from_port = 8301
  consul_udp_to_port = 8302
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  udp_protocol = "udp"
  all_ips = ["0.0.0.0/0"]
}
