# Create a new Heroku app
resource "heroku_app" "edm_dashboard" {
  name   = "${var.name}-edm-dashboard"
  region = "us"
  config_vars {
    REACT_APP_EDM_STREAM_BACKEND_HOST = "https://${var.name}-edm-stream.herokuapp.com" 
    REACT_APP_EDM_STATS_BACKEND_HOST  = "https://${var.name}-edm-stats.herokuapp.com" 
  }

  buildpacks = [
    "mars/create-react-app"
  ]
}

resource "heroku_slug" "edm_dashboard" {
  app                            = "${heroku_app.edm_dashboard.name}"
  buildpack_provided_description = "mars/create-react-app"
  commit_description             = "manual slug build"
  file_path                      = "${var.edm_dashboard_slug_file_path}"

  process_types = {
    web = "bin/boot"
  }
}

resource "heroku_app_release" "edm_dashboard" {
  app     = "${heroku_app.edm_dashboard.name}"
  slug_id = "${heroku_slug.edm_dashboard.id}"
}

resource "heroku_formation" "edm_dashboard" {
  app        = "${heroku_app.edm_dashboard.name}"
  type       = "web"
  quantity   = "${var.edm_dashboard_count}"
  size       = "${var.edm_dashboard_size}"
  depends_on = ["heroku_app_release.edm_dashboard"]
}