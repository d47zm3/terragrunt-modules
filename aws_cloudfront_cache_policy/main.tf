resource "aws_cloudfront_cache_policy" "this" {
  name        = var.name
  comment     = var.comment
  default_ttl = var.default_ttl
  max_ttl     = var.max_ttl
  min_ttl     = var.min_ttl
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = var.cookie_behavior
      cookies {
        items = var.cookies_items
      }
    }
    headers_config {
      header_behavior = var.header_behavior
      headers {
        items = var.headers_items
      }
    }
    query_strings_config {
      query_string_behavior = var.query_string_behavior
      query_strings {
        items = var.query_strings_items
      }
    }
  }
}
