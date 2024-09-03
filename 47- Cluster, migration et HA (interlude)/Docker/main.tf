#Déclaration des variables pour la connexion SSH
variable "ssh_host" {
  description = "Adresse IP du serveur"
  default     = "192.168.1.189"
}

variable "ssh_user" {
  description = "Nom d'utilisateur SSH"
  default     = "ubuntu"
}

variable "ssh_key" {
  description = "Chemin vers la clé privée SSH"
  default     = "~/.ssh/terraform_key"
}

#Ressource null_resource pour exécuter des commandes à distance via SSH
resource "null_resource" "gitlab_install" {
  connection {
    type        = "ssh"  # Type de connexion SSH
    user        = var.ssh_user  # Utilisateur SSH
    host        = var.ssh_host  # Hôte SSH
    private_key = file(var.ssh_key)
  }
  
#Provisionneur pour exécuter des commandes à distance
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update -y",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker ${var.ssh_user}",
      "docker --version"
    ]
  }   
}