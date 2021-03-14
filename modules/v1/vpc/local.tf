locals {
  max_subnet_length = max(
    length(var.private_subnets),
    length(var.elasticache_subnets),
    length(var.database_subnets),
    length(var.redshift_subnets),
    length(var.infra_subnets),
  )
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length

  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = element(
    concat(
      aws_vpc_ipv4_cidr_block_association.this.*.vpc_id,
      aws_vpc.this.*.id,
      [""],
    ),
    0,
  )

  vpce_tags = merge(
    var.tags,
    var.vpc_endpoint_tags,
  )

  infra_route_table_tags    = merge(var.infra_subnet_tags, var.infra_route_table_tags)
  database_route_table_tags = merge(var.database_subnet_tags, var.database_route_table_tags)
  private_route_table_tags  = merge(var.private_subnet_tags, var.public_route_table_tags)
  public_route_table_tags   = merge(var.public_subnet_tags, var.public_route_table_tags)
}
