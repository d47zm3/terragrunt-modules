variable "name" {}
variable "compute_instance" {}

resource "google_os_config_patch_deployment" "patch" {
  patch_deployment_id = var.name

  instance_filter {
    instances = [var.compute_instance]
  }

  patch_config {
    reboot_config = "DEFAULT"

    yum {
      security = true
      minimal  = true
      excludes = ["bash"]
    }
  }

  recurring_schedule {
    time_zone {
      id = "Europe/Warsaw"
    }

    time_of_day {
      hours   = 3
      minutes = 0
      seconds = 0
      nanos   = 0
    }

    monthly {
      week_day_of_month {
        week_ordinal = 1
        day_of_week  = "SUNDAY"
      }
    }
  }
}
