variable "github_user" {
  description = "github_user"
  type        = string
}

variable "github_secret" {
  description = "github_user"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "github_token"
  type        = string
  sensitive   = true
}

variable "github_allow_domain" {
  description = "github_allow_domain"
  type        = string
}

variable "secret" {
  description = "secret"
  type        = string
  sensitive   = true
}

variable "repository" {
  description = "repository"
  type        = string
}

variable "github_token_webhook" {
  description = "github_token_webhook"
  type        = string
  sensitive   = true
}

variable "account" {
  description = "account"
  type        = string
  sensitive   = true
}