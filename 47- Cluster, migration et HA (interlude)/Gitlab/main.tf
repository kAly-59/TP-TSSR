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
    type        = "ssh"  #Type de connexion SSH
    user        = var.ssh_user  #Utilisateur SSH
    host        = var.ssh_host  #Hôte SSH
    private_key = file(var.ssh_key)  #Clé privée pour l'authentification
  }
  
#Provisionneur pour exécuter des commandes à distance
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",  #Met à jour la liste des paquets
      "sudo apt-get install -y curl openssh-server ca-certificates tzdata perl",  #Installe les dépendances nécessaires pour GitLab
      "curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash",  #Ajoute le dépôt GitLab
      "sudo EXTERNAL_URL=\"http://${var.ssh_host}\" apt-get install -y gitlab-ce",  #Installe GitLab
      "sudo gitlab-ctl reconfigure",  #Configure GitLab
      "sudo gitlab-ctl status"  #Vérifie l'état de GitLab
    ]
  }   
}