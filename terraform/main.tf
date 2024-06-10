provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "minecraft" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.minecraft.name]

  tags = {
    Name = "Minecraft Server"
  }

  provisioner "remote-exec" {
    inline = [
        "sudo apt update -y",
        "sudo apt install -y openjdk-21-jdk",
        "sudo mkdir -p /minecraft-server",
        "sudo chown -R ubuntu:ubuntu /minecraft-server",
        "sudo chmod -R 755 /minecraft-server",
        "sudo wget -O /minecraft-server/server.jar https://piston-data.mojang.com/v1/objects/145ff0858209bcfc164859ba735d4199aafa1eea/server.jar",
        "echo 'eula=true' | sudo tee /minecraft-server/eula.txt",
        "echo '#!/bin/bash\ncd /minecraft-server && java -Xmx2048M -Xms1024M -jar server.jar nogui' | sudo tee /minecraft-server/run.sh",
        "sudo chmod +x /minecraft-server/run.sh",
        "printf '[Unit]\nDescription=Minecraft Server\nAfter=network.target\n\n[Service]\nUser=ubuntu\nWorkingDirectory=/minecraft-server\nExecStart=/minecraft-server/run.sh\nRestart=always\n\n[Install]\nWantedBy=multi-user.target\n' | sudo tee /etc/systemd/system/minecraft.service",
        "sudo systemctl daemon-reload",
        "sudo systemctl enable minecraft",
        "sudo systemctl start minecraft"
    ]
}

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/../minecraft-key")
    host        = self.public_ip
  }
}

resource "aws_security_group" "minecraft" {
  name = "minecraft-options"

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
