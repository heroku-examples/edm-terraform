# Create a new Heroku app
resource "heroku_app" "edm_relay" {
  name   = "${var.name}-edm-relay"
  buildpacks = [
    "Node.js"
  ]
}

# Create a multi-tenant kafka cluster, and configure the app to use it
resource "heroku_addon" "kafka" {
  app  = "${heroku_app.edm_relay.name}"
  plan = "heroku-kafka:basic-0"

  provisioner "local-exec" {
    command = "./setup-kafka.sh ${heroku_app.edm_relay}"
  }
}

resource "heroku_slug" "edm_relay" {
  app                            = "${heroku_app.edm_relay.id}"
  buildpack_provided_description = "Node.js"
  commit_description             = "manual slug build"
  file_path                      = "${var.edm_relay_slug_file_path}"

  process_types = {
    web = "npm start"
  }
}

resource "heroku_app_release" "edm_relay" {
  app     = "${heroku_app.edm_relay.id}"
  slug_id = "${heroku_slug.edm_relay.id}"
}

resource "heroku_formation" "edm_relay" {
  app        = "${heroku_app.edm_relay.id}"
  type       = "web"
  quantity   = "${var.edm_relay_app_count}"
  size       = "${var.edm_relay_app_size}"
  depends_on = ["heroku_app_release.edm_relay"]
}