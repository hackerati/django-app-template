# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"

    config.vm.network "private_network", ip: "192.168.59.103"
    config.vm.synced_folder ".", "/src"

    # Enable ssh forward agent
    config.ssh.forward_agent = true

    # Run apt-get update
    config.vm.provision :shell, inline: "apt-get update"

    # Install Ruby dev, which gem needs
    config.vm.provision :shell, inline: "apt-get install -y ruby-dev"

    # Install travis CLI
    config.vm.provision :shell, inline: "gem install travis -v 1.8.0 --no-rdoc --no-ri"
    config.vm.provision :shell, inline: "gem install travis-lint --no-rdoc --no-ri"

    # Install PIP
    config.vm.provision :shell, inline: "curl -O https://bootstrap.pypa.io/get-pip.py"
    config.vm.provision :shell, inline: "python get-pip.py"

    # Install AWS Elastic Beanstalk CLI
    config.vm.provision :shell, inline: "pip install awsebcli"

    # Install Docker, Docker Compose, and stand up the docker environment
    config.vm.provision :docker
    config.vm.provision :docker_compose, yml: "/src/docker-compose.yml", rebuild: true, project_name: "django-app-template", run: "always"

    # Setup aliases
    config.vm.provision :shell, inline: "/bin/sh /src/aliases.sh"
end
