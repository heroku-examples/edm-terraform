# Create a new Heroku app
resource "heroku_app" "edm_ui" {
  name   = "${var.name}-edm-ui"
  region = "us"
  config_vars {
    REACT_APP_EDM_RELAY_BACKEND_HOST = "https://${var.name}-edm-relay.herokuapp.com" 
  }
  buildpacks = [
    "mars/create-react-app"
  ]
}

resource "heroku_build" "edm_ui" {
  app        = "${heroku_app.edm_ui.id}"

  source = {
    url      = "https://github.com/trevorscott/edm-ui/archive/v1.0.tar.gz"
    version = "1.0"
  }
}

resource "heroku_formation" "edm_ui" {
  app        = "${heroku_app.edm_ui.name}"
  type       = "web"
  quantity   = "${var.edm_ui_count}"
  size       = "${var.edm_ui_size}"
  depends_on = ["heroku_build.edm_ui"]
}
