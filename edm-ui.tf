# Create a new Heroku app
resource "heroku_app" "edm_ui" {
  name   = "${var.name}-edm-ui"

  config_vars {
    REACT_APP_EDM_RELAY_BACKEND_HOST = "https://${heroku_app.edm_relay.name}.herokuapp.com" 
    //REDSHIFT_HOST = "${aws_redshift_cluster.tf_redshift_cluster.dns_name}"
  }

  buildpacks = [
    "mars/create-react-app"
  ]
}

resource "heroku_slug" "edm_ui" {
  app                            = "${heroku_app.edm_ui.id}"
  buildpack_provided_description = "mars/create-react-app"
  commit_description             = "manual slug build"
  file_path                      = "${var.edm_ui_slug_file_path}"

  process_types = {
    web = "bin/boot"
  }
}

resource "heroku_app_release" "edm_ui" {
  app     = "${heroku_app.edm_ui.id}"
  slug_id = "${heroku_slug.edm_ui.id}"
}

resource "heroku_formation" "edm_ui" {
  app        = "${heroku_app.edm_ui.id}"
  type       = "web"
  quantity   = "${var.edm_ui_app_count}"
  size       = "${var.edm_ui_app_size}"
  depends_on = ["heroku_app_release.edm_ui"]
}