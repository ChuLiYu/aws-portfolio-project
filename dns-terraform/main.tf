# Cloudflare DNS Configuration for GitHub Pages
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token with DNS edit permissions"
  type        = string
  sensitive   = true
}

variable "zone_id" {
  description = "Cloudflare Zone ID for luichu.dev"
  type        = string
  # Get this from Cloudflare dashboard
}

# Root domain A records for GitHub Pages
resource "cloudflare_record" "root_a_1" {
  zone_id = var.zone_id
  name    = "luichu.dev"
  value   = "185.199.108.153"
  type    = "A"
  ttl     = 1  # Auto
  proxied = false  # MUST be false for GitHub Pages
  comment = "GitHub Pages - IP 1/4"
}

resource "cloudflare_record" "root_a_2" {
  zone_id = var.zone_id
  name    = "luichu.dev"
  value   = "185.199.109.153"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "GitHub Pages - IP 2/4"
}

resource "cloudflare_record" "root_a_3" {
  zone_id = var.zone_id
  name    = "luichu.dev"
  value   = "185.199.110.153"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "GitHub Pages - IP 3/4"
}

resource "cloudflare_record" "root_a_4" {
  zone_id = var.zone_id
  name    = "luichu.dev"
  value   = "185.199.111.153"
  type    = "A"
  ttl     = 1
  proxied = false
  comment = "GitHub Pages - IP 4/4"
}

# WWW subdomain CNAME
resource "cloudflare_record" "www" {
  zone_id = var.zone_id
  name    = "www"
  value   = "ChuLiYu.github.io"
  type    = "CNAME"
  ttl     = 1
  proxied = false  # MUST be false for GitHub Pages
  comment = "GitHub Pages - www subdomain"
}

# Keep existing chainy subdomain (do not touch)
# This is just a data source to show it exists
data "cloudflare_record" "chainy" {
  zone_id  = var.zone_id
  hostname = "chainy.luichu.dev"
}

output "github_pages_setup" {
  value = {
    root_domain = "luichu.dev → GitHub Pages"
    www_domain  = "www.luichu.dev → GitHub Pages"
    chainy      = "chainy.luichu.dev → ${data.cloudflare_record.chainy.value} (unchanged)"
  }
}
