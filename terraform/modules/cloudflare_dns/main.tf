# Configure the Cloudflare provider using the required_providers stanza required with Terraform 0.13 and beyond
# You may optionally use version directive to prevent breaking changes occurring unannounced.
# Add a record to the domain
resource  "cloudflare_record" "_" {
  zone_id = var.cloudflare_zone_id
  name    = var.dns_record_name
  type    = var.dns_record_type
  ttl     = var.dns_record_ttl
  proxied = var.dns_record_proxied
  value = var.dns_record_value
}
