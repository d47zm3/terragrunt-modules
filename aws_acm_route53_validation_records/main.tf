resource "aws_route53_record" "this" {
  for_each = { for idx, record in var.records : idx => record }

  zone_id = var.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 300
  records = [each.value.resource_record_value]
}
