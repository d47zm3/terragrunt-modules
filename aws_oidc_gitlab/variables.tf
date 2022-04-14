variable "role_name" {
  description = "Name of the role to create"
  type        = string
  default     = "GitLabRole"
}

variable "gitlab_url" {
  description = "The URL of the token endpoint for GitLab"
  type        = string
  default     = "https://gitlab.example.com"
}

variable "gitlab_org" {
  description = "GitLab Project To Trust"
  type        = string
}

variable "gitlab_repos" {
  description = "GitLab Repos To Trust"
  type        = list(string)
  default     = []
}

variable "tags" {
  type = map(string)
}
