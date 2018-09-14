provider "kong" {
  admin_api_url = "http://localhost:8001"
}

resource "kong_service" "mockbin" {
  name = "mockbin"
  url = "https://mockbin.org/request"
}

resource "kong_route" "mock" {
  service_id = "${kong_service.mockbin.id}"
  paths = [
    "/mock"]
}

//resource "kong_plugin" "response-transformer-plugin-route" {
//  route_id = "${kong_route.mock.id}"
//  name = "response-transformer"
//  config_json =<<EOF
//"add": {"json": "added-by-terraform:true", "headers": "x-parent-resource:route"}}
//EOF
//}

variable "test-count-enabled" {
  default = "no"
  type = "string"
}

resource "kong_service" "test-count-service" {
  count = "${var.test-count-enabled == "yes" ? 1 : 0}"

  name = "foo"
  url = "http://foo.bar.org"
}

resource "kong_route" "child-route-test-count" {
  /*
    Need to set count for dependent resources of a conditional resource,
    otherwise TF will error:
    Resource 'kong_service.test-count-service' not found for variable 'kong_service.test-count-service.id'
  */
  count = "${var.test-count-enabled == "yes" ? 1 : 0}"

  service_id = "${kong_service.test-count-service.id}"
}

resource "kong_plugin_ip_header_restriction" "global-ip-header-restriction" {
  whitelist = [
    "230.188.209.188",
    "141.201.15.252",
    "142.121.207.218"
  ]
}

resource "kong_plugin_ip_header_restriction" "route-ip-header-restriction" {
  route_id = "${kong_route.mock.id}"
  whitelist = ["181.28.140.88"]
}

variable basic-auth-foo-config {
  type = "string"
  default =<<EOF
{
  "anonymous": "",
  "hide_credentials": true
}
EOF
}

resource "kong_plugin" "basic-auth-foo" {
  route_id = "${kong_route.mock.id}"
  name = "basic-auth"
  config_json = "${var.basic-auth-foo-config}"
}
// imported resources
// run ./create-resources-to-import.sh to create them and then uncomment the block below
//resource "kong_service" "imported-service" {
//  name = "service-to-import"
//  url = "http://mockbin.org/request"
//}
//resource "kong_route" "imported-route" {
//  service_id = "${kong_service.imported-service.id}"
//  paths = ["/route-to-import"]
//}
//resource "kong_plugin" "imported-basic-auth-plugin" {
//  route_id = "${kong_route.imported-route.id}"
//  name = "basic-auth"
//}
//resource "kong_plugin_ip_header_restriction" "imported-ip-header-restriction-plugin" {
//  route_id = "${kong_route.imported-route.id}"
//  whitelist = ["244.213.135.114"]
//}
