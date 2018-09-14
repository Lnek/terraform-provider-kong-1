# terraform-provider-kong

A Terraform provider for the api gateway [Kong](https://github.com/Kong/kong).

## Development

- install Go 1.11 (this project uses [Go modules](https://github.com/golang/go/wiki/Modules#installing-and-activating-module-support))
- install Terraform.
- `docker-compose up --build -d` to stand up an instance of Kong 0.14 CE w/ Postgres.
- `make build` to create the provider.
- `make example` to run the provider against Kong.

### Manually testing imported resources

Run `./examples/import/create-resources.sh` to create an example service, route, and a few plugins.
Then `terraform import -config=examples/import <resource>.<resource-name> <UUID>` should import the resource (ex: `terraform import -config=examples/import kong_service.service-to-import e86f981e-a580-4bd6-aef3-1324adfcc12c`).
Afterwards `terraform destroy examples/import` will remove the resources.

## Resources

### Unsupported Resources

No plans to support the legacy [API resource](https://docs.konghq.com/0.12.x/admin-api/#api-object).

I also don't intend to add support for the following resources, since I don't currently use them:

- [Certificate](https://docs.konghq.com/0.14.x/admin-api/#certificate-object)
- [SNI](https://docs.konghq.com/0.14.x/admin-api/#sni-objects)
- [Upstream](https://docs.konghq.com/0.14.x/admin-api/#upstream-objects)
- [Target](https://docs.konghq.com/0.14.x/admin-api/#target-object)

That said, PRs are welcome and may I try to implement them once the other resources are mature.

### Services


### Routes


### Plugins


#### Custom Plugins/Specialized Plugin Resources


### Consumers


### Admins/RBAC

