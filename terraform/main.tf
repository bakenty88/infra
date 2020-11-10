provider "google"{
project = "infra-293516"
region = "europe-west1"
}

resource "google_compute_instance" "app" {
  name = "reddit-app"
  machine_type = "g1-small"
  zone = "europe-west1-b"
  tags = ["reddit-app"]
  metadata = {
    ssh-keys =  "bakenty:${file("week6.pub")}"
  }
  metadata_startup_script = "sudo ufw allow ssh"
  # определение загрузочного диска
  boot_disk {
  initialize_params{
  image =  "reddit-base-1603559777"
  }
  }

  provisioner "remote-exec"{
  script = "files/deploy.sh"
  connection {
    type = "ssh"
    host = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
    private_key = file("week6")
    user = "bakenty"
    agent = false
  }

}
provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
      connection {
    type = "ssh"
    host = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
    private_key = file("week6")
    user = "bakenty"
    agent = false
  }
  }
provisioner "remote-exec"{
  script = "files/puma.sh"
  connection {
    type = "ssh"
    host = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
    private_key = file("week6")
    user = "bakenty"
    agent = false
  }

}

  # определение сетевого интерфейса
 network_interface {
# сеть, к которой присоединить данный интерфейс
network = "default"
# использоватьephemeral IP для доступа из Интернет
access_config{}
} 
}

resource "google_compute_firewall" "firewall_puma"{
name = "allow-puma-default"
# Название сети, в которой действует правило
network = "default"
# Какой доступ разрешить
allow {
protocol = "tcp"
ports = ["9292"]
}
# Каким адресам разрешаем доступ
source_ranges = ["0.0.0.0/0"]
# Правило применимо для инстансов с тегом…
target_tags = ["reddit-app"]
}









