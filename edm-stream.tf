# Create a new Heroku app
resource "heroku_app" "edm_stream" {
  name   = "${var.name}-edm-stream"

  config_vars {
    KAFKA_TOPIC="edm-ui-click,edm-ui-pageload"
    KAFKA_CONSUMER_GROUP="edm-consumer-group-1"
  }

  buildpacks = [
    "Node.js"
  ]
}

resource "heroku_addon_attachment" "kafka" {
  app_id  = "${heroku_app.edm_stream.id}"
  addon_id = "${heroku_addon.kafka.id}"
}

resource "heroku_slug" "edm_stream" {
  app                            = "${heroku_app.edm_stream.id}"
  buildpack_provided_description = "Node.js"
  commit_description             = "manual slug build"
  file_path                      = "${var.edm_stream_slug_file_path}"

  process_types = {
    web = "npm start"
  }
}

resource "heroku_app_release" "edm_stream" {
  app     = "${heroku_app.edm_stream.id}"
  slug_id = "${heroku_slug.edm_stream.id}"
}

resource "heroku_formation" "edm_stream" {
  app        = "${heroku_app.edm_stream.id}"
  type       = "web"
  quantity   = "${var.edm_stream_app_count}"
  size       = "${var.edm_stream_app_size}"
  depends_on = ["heroku_app_release.edm_stream"]
}