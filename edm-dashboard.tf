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

resource "heroku_build" "edm_dashboard" {
  app        = "${heroku_app.edm_dashboard.id}"

  source = {
    url      = "https://github.com/trevorscott/edm-dashboard/archive/v1.0.1.tar.gz"  
    version = "1.0"
  }
}

resource "heroku_formation" "edm_dashboard" {
  app        = "${heroku_app.edm_dashboard.name}"
  type       = "web"
  quantity   = "${var.edm_dashboard_count}"
  size       = "${var.edm_dashboard_size}"
  depends_on = ["heroku_build.edm_dashboard"]
}
