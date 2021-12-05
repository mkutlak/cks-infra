variable "user" {
  description = "Username for SSH Key"
  type        = string
}

variable "sshkey_file" {
  description = "Path to public SSH Key file."
  type        = string
  sensitive   = true
}

variable "project" {
  description = "GCP Project ID"
  type        = string
  sensitive   = true
}

variable "credentials_file" {
  description = "Path to file with credentials to GCP."
  type        = string
  sensitive   = true
}

variable "region" {
  description = "GCP Region (ex. us-central1, europe-west-3)"
  default     = "europe-west3"
  type        = string

}

variable "zone" {
  description = "GCP Zone (ex. us-central1-c, europe-west3-a)"
  default     = "europe-west3-a"
  type        = string
}
