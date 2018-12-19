# Create a new Heroku app
resource "heroku_app" "edm_stats" {
  name   = "${var.name}-edm-stats"
  region = "us"
  config_vars {
    KAFKA_TOPIC="edm-ui-click,edm-ui-pageload"
    KAFKA_CONSUMER_GROUP="edm-consumer-group-2"
  }

  buildpacks = [
    "heroku/nodejs"
  ]
}

resource "heroku_addon" "database" {
  app  = "${heroku_app.edm_stats.name}"
  plan = "heroku-postgresql:hobby-dev"
  provisioner "local-exec" {
    command = "./setup-postgres.sh ${heroku_app.edm_stats.name}"
  }
}

resource "heroku_addon_attachment" "edm_stats_kafka" {
  app_id  = "${heroku_app.edm_stats.id}"
  addon_id = "${heroku_addon.kafka.id}"
}

resource "heroku_build" "edm_stats" {
  app        = "${heroku_app.edm_stats.id}"

  source = {
    url      = "https://github.com/trevorscott/edm-stats/archive/v1.1.tar.gz"
    version = "1.0"
  }
}

resource "heroku_app_release" "edm_stats" {
  app     = "${heroku_app.edm_stats.name}"
  slug_id = "${heroku_build.edm_stats.slug_id}"
}

resource "heroku_formation" "edm_stats" {
  app        = "${heroku_app.edm_stats.name}"
  type       = "web"
  quantity   = "${var.edm_stats_count}"
  size       = "${var.edm_stats_size}"
  depends_on = ["heroku_app_release.edm_stats","heroku_addon.kafka"]
}
