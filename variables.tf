#edm-ui vars
variable "edm_ui_slug_file_path" {
  description = "Heroku slug archive to release"
  default     = "slugs/edm-ui-slug.tgz"
}

variable "edm_ui_count" {
  description = "Heroku dyno quantity"
  default     = 1
}

variable "edm_ui_size" {
  description = "Heroku dyno size"
  default     = "Standard-1x"
}

#edm-dashboard vars
variable "edm_relay_slug_file_path" {
  description = "Heroku slug archive to release"
  default     = "slugs/edm-dashboard-slug.tgz"
}

variable "edm_dashboard_count" {
  description = "Heroku dyno quantity"
  default     = 1
}

variable "edm_dashboard_size" {
  description = "Heroku dyno size"
  default     = "Standard-1x"
}

#edm-relay vars
variable "edm_relay_slug_file_path" {
  description = "Heroku slug archive to release"
  default     = "slugs/edm-relay-slug.tgz"
}

variable "edm_relay_count" {
  description = "Heroku dyno quantity"
  default     = 1
}

variable "edm_relay_size" {
  description = "Heroku dyno size"
  default     = "Standard-1x"
}

#edm-stream vars
variable "edm_stream_slug_file_path" {
  description = "Heroku slug archive to release"
  default     = "slugs/edm-stream-slug.tgz"
}

variable "edm_stream_count" {
  description = "Heroku dyno quantity"
  default     = 1
}

variable "edm_stream_size" {
  description = "Heroku dyno size"
  default     = "Standard-1x"
}

#edm-stats vars
variable "edm_stats_slug_file_path" {
  description = "Heroku slug archive to release"
  default     = "slugs/edm-stats-slug.tgz"
}

variable "edm_stats_count" {
  description = "Heroku dyno quantity"
  default     = 1
}

variable "edm_stats_size" {
  description = "Heroku dyno size"
  default     = "Standard-1x"
}