variable "cloudflare_zone_id" {
    type = string
}

variable "dns_record_name" {
    type = string
}
variable "dns_record_value" {
    type = string
}
variable "dns_record_type" {
    type = string
}
variable "dns_record_ttl" {
    type = string
    default = 3600
}
variable "dns_record_proxied" {
    type = bool
    default = true
}