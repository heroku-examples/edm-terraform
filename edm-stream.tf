# Create a new Heroku app
resource "heroku_app" "edm_stream" {
  name   = "${var.name}-edm-stream" 
  region = "us"
  config_vars {
    KAFKA_TOPIC="edm-ui-click,edm-ui-pageload"
    KAFKA_CONSUMER_GROUP="edm-consumer-group-1"
  }

  buildpacks = [
    "heroku/nodejs"
  ]
}

resource "heroku_addon_attachment" "edm_stream_kafka" {
  app_id  = "${heroku_app.edm_stream.id}"
  addon_id = "${heroku_addon.kafka.id}"
}

resource "heroku_slug" "edm_stream" {
  app                            = "${heroku_app.edm_stream.name}"
  buildpack_provided_description = "Node.js"
  commit_description             = "manual slug build"
  file_path                      = "${var.edm_stream_slug_file_path}"

  process_types = {
    web = "npm start"
  }
}

resource "heroku_app_release" "edm_stream" {
  app     = "${heroku_app.edm_stream.name}"
  slug_id = "${heroku_slug.edm_stream.id}"
}

resource "heroku_formation" "edm_stream" {
  app        = "${heroku_app.edm_stream.name}"
  type       = "web"
  quantity   = "${var.edm_stream_count}"
  size       = "${var.edm_stream_size}"
  depends_on = ["heroku_app_release.edm_stream","heroku_addon.kafka"]
}