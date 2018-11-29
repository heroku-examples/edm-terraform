# Create a new Heroku app
resource "heroku_app" "edm_stats" {
  name   = "${var.name}-edm-stats"

  config_vars {
    KAFKA_TOPIC="edm-ui-click,edm-ui-pageload"
    KAFKA_CONSUMER_GROUP="edm-consumer-group-2"
  }

  buildpacks = [
    "Node.js"
  ]
}

resource "heroku_addon" "database" {
  app  = "${heroku_app.edm_stats.name}"
  plan = "heroku-postgresql:hobby-dev"
  provisioner "local-exec" {
    command = "setup-postgres.sh ${heroku_app.edm_stats.name}"
  }
}

resource "heroku_addon_attachment" "kafka" {
  app_id  = "${heroku_app.edm_stats.id}"
  addon_id = "${heroku_addon.kafka.id}"
}

resource "heroku_slug" "edm_stats" {
  app                            = "${heroku_app.edm_stats.id}"
  buildpack_provided_description = "Node.js"
  commit_description             = "manual slug build"
  file_path                      = "${var.edm_stats_slug_file_path}"

  process_types = {
    web = "npm start"
  }
}

resource "heroku_app_release" "edm_stats" {
  app     = "${heroku_app.edm_stats.id}"
  slug_id = "${heroku_slug.edm_stats.id}"
}

resource "heroku_formation" "edm_stats" {
  app        = "${heroku_app.edm_stats.id}"
  type       = "web"
  quantity   = "${var.edm_stats_app_count}"
  size       = "${var.edm_stats_app_size}"
  depends_on = ["heroku_app_release.edm_stats"]
}