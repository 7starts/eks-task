
provider "github" {
  token = var.github_token_webhook
}

resource "github_repository_webhook" "example_webhook" {
  repository = var.repository

  configuration {
    url          = "http://${var.url}/events"
    content_type = "form"
    secret       = var.secret #  # optional
    insecure_ssl = false  # Set true if SSL is not required
  }

  # Specify which events trigger the webhook
  events = [
    "push",
    "pull_request",
    "issue_comment",
    "pull_request_review"

  ]

  active = true
}
