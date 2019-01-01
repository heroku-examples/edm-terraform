# Create a new Heroku app
resource "heroku_app" "edm_relay" {
  name   = "${var.name}-edm-relay"
  region = "us"
  buildpacks = [
    "heroku/nodejs"
  ]
}

# Create a multi-tenant kafka cluster, and configure the app to use it
resource "heroku_addon" "kafka" {
  app  = "${heroku_app.edm_relay.name}"
  plan = "heroku-kafka:basic-0"

  provisioner "local-exec" {
    command = "./setup-kafka.sh ${heroku_app.edm_relay.name}"
  }
}

resource "heroku_build" "edm_relay" {
  app        = "${heroku_app.edm_relay.id}"

  source = {
    url      = "https://github.com/trevorscott/edm-relay/archive/v1.1.tar.gz"
    version = "1.0"
  }
}

resource "heroku_formation" "edm_relay" {
  app        = "${heroku_app.edm_relay.name}"
  type       = "web"
  quantity   = "${var.edm_relay_count}"
  size       = "${var.edm_relay_size}"
  depends_on = ["heroku_build.edm_relay"]
}
