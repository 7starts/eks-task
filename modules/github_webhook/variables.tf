variable "url" {
  description = "Load Balancer FQDN"
  type        = string
}

variable "secret" {
  description = "Secret"
  type        = string
  sensitive = true
}

variable "repository" {
  description = "Repository"
  type        = string
}

variable "github_token_webhook" {
  description = "Repository"
  type        = string
  sensitive = true
}