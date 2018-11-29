# Create a new Heroku app
resource "heroku_app" "edm_dashboard" {
  name   = "${var.name}-edm-dashboard"

  config_vars {
    REACT_APP_EDM_STREAM_BACKEND_HOST = "https://${heroku_app.edm_stream.name}.herokuapp.com" 
    REACT_APP_EDM_STATS_BACKEND_HOST  = "https://${heroku_app.edm_stats.name}.herokuapp.com" 
  }

  buildpacks = [
    "mars/create-react-app"
  ]
}

resource "heroku_slug" "edm_dashboard" {
  app                            = "${heroku_app.edm_dashboard.id}"
  buildpack_provided_description = "mars/create-react-app"
  commit_description             = "manual slug build"
  file_path                      = "${var.edm_dashboard_slug_file_path}"

  process_types = {
    web = "bin/boot"
  }
}

resource "heroku_app_release" "edm_dashboard" {
  app     = "${heroku_app.edm_dashboard.id}"
  slug_id = "${heroku_slug.edm_dashboard.id}"
}

resource "heroku_formation" "edm_dashboard" {
  app        = "${heroku_app.edm_dashboard.id}"
  type       = "web"
  quantity   = "${var.edm_dashboard_app_count}"
  size       = "${var.edm_dashboard_app_size}"
  depends_on = ["heroku_app_release.edm_dashboard"]
}