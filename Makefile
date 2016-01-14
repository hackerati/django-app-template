UNAME := $(shell uname)
ifeq ($(UNAME),Darwin)
OSX := 1
endif


VIRTUALBOX := $(shell { type virtualbox; } 2>/dev/null)
VAGRANT := $(shell { type vagrant; } 2>/dev/null)
VAGRANT_DOCKER_COMPOSE := $(shell { vagrant plugin list | grep vagrant-docker-compose; } 2>/dev/null)
DOCKER := $(shell { type docker; } 2>/dev/null)
DOCKER_COMPOSE := $(shell { type docker-compose; } 2>/dev/null)
SHORT_APP_SERVER_ID := $(shell { docker ps | grep appsvr | awk -F ' ' '{print $$1}'; } 2>/dev/null)
ifdef SHORT_APP_SERVER_ID
FULL_APP_SERVER_ID := $(shell { docker ps --no-trunc -q | grep $(SHORT_APP_SERVER_ID); } 2>/dev/null)
endif
SHORT_NGINX_SERVER_ID := $(shell { docker ps | grep nginx | awk -F ' ' '{print $$1}'; } 2>/dev/null)
ifdef SHORT_NGINX_SERVER_ID
FULL_NGINX_SERVER_ID := $(shell { docker ps --no-trunc -q | grep $(SHORT_NGINX_SERVER_ID); } 2>/dev/null)
endif
APP_SERVER_IMAGE_NAME := $(shell { docker ps | grep $(SHORT_APP_SERVER_ID) | awk -F ' ' '{print $2}'; } 2>/dev/null)


.PHONY: build push shell run start stop rm release check
######################################################################
# COMMANDS FOR USING OSX
#######################################################################
ifdef OSX
check: check_vagrant check_virtualbox check_plugins

install: check_vagrant check_virtualbox install_plugins

build: up
	@vagrant ssh -c "cd /src/ && make build"

provision:
	@vagrant up --provision

up:
	@vagrant up

test:
	@vagrant ssh -c "cd /src/ && make test"

debug:
	@vagrant ssh -c "cd /src/ && make debug"
	@vagrant halt

shell:
	@vagrant ssh -c "cd /src/ && make shell"

djangoshell:
	@vangrant ssh -c "cd /src/ && make djangoshell"

stop:
	@vagrant halt

makemigrations:
	@vagrant ssh -c "cd /src/ && make makemigrations"

migrate:
	@vagrant ssh -c "cd /src/ && make migrate"

ssh:
	@vagrant ssh

ps:
	@vagrant ssh -c "cd /src/ && make ps"

tail:
	@vagrant ssh -c "cd /src/ && make tail"

tailnginx:
	@vagrant ssh -c "cd /src/ && make tailnginx"

stats:
	@vagrant ssh -c "cd /src/ && make stats"

top:
	@vagrant ssh -c "cd /src/ && make top"

#######################################################################
# COMMANDS FOR USING LINUX
else
#######################################################################

check: check_docker check_docker_compose

build:
	@docker-compose build

up:
	@docker-compose up

test:
ifdef FULL_APP_SERVER_ID
	@docker exec -i -t $(FULL_APP_SERVER_ID) bash -c "cd /src/app/ && python /src/app/manage.py test"
else
	@echo "You must start docker-compose before running tests"
	@echo "Please run \`make up\`"
endif

debug:
ifdef FULL_APP_SERVER_ID
	@docker-compose stop
endif
	@sed -i s/ports/\#ports/ docker-compose.yml
	@sed -i s/"- \"8000:8000\""/"\#- \"8000:8000\""/ docker-compose.yml
	@sed -i s/ENVIRONMENT=development/ENVIRONMENT=debug/ docker-compose.yml
	@sed -i s/"uwsgi \-\-ini \/src\/app\/uwsgi\.ini"/"python \/src\/app\/manage.py runserver 0.0.0.0:8000\"\n  ports:\n    - \"8000:8000"/ docker-compose.yml

	@echo "\n\nRunning app in debug mode. See docs for ipdb."
	@echo "This command changes docker-compose.yml temporarily, do not commit these changes"
	@echo "To exit debugger use CTRL-D. To shut off server use CTRL-C."

	@docker-compose -f docker-compose.yml run --service-ports appsvr

	@sed -i s/ENVIRONMENT=debug/ENVIRONMENT=development/ docker-compose.yml
	@sed -i s/"python \/src\/app\/manage.py runserver 0.0.0.0:8000"/"uwsgi \-\-ini \/src\/app\/uwsgi\.ini"/ docker-compose.yml
	@sed -i '/  ports:/ d' docker-compose.yml
	@sed -i '/    - "8000:8000"/ d' docker-compose.yml
	@sed -i s/\#ports/ports/ docker-compose.yml
	@sed -i s/"\#- \"8000:8000\""/"- \"8000:8000\""/ docker-compose.yml

shell:
ifdef FULL_APP_SERVER_ID
	@docker exec -i -t $(FULL_APP_SERVER_ID) bash
else
	@echo "Must be running Application Server to get shell access."
endif

djangoshell:
ifdef FULL_APP_SERVER_ID
	@docker exec -i -t $(FULL_APP_SERVER_ID) python /src/app/manage.py shell
else
	@echo "Must be running Application Server to get shell access."
endif

stop:
	@docker-compose stop

rm:
	@docker-compose rm

makemigrations:
ifdef FULL_APP_SERVER_ID
	@docker exec -i -t $(FULL_APP_SERVER_ID) python /src/app/manage.py makemigrations
else
	@echo "Must be running Application Server to make migrations"
endif

migrate:
ifdef FULL_APP_SERVER_ID
	@docker exec -i -t $(FULL_APP_SERVER_ID) python /src/app/manage.py migrate
else
	@echo "Must be running Application Server to migrate database"
endif

ps:
	@docker ps

tail:
ifdef FULL_APP_SERVER_ID
	@docker logs -f $(FULL_APP_SERVER_ID)
else
	@echo "Must be running Application Sever to tail"
endif

tailnginx:
ifdef FULL_NGINX_SERVER_ID
	@docker logs -f $(FULL_NGINX_SERVER_ID)
else
	@echo "Must be running Nginx container to tail"
endif

stats:
ifdef FULL_APP_SERVER_ID
	@docker stats $(FULL_APP_SERVER_ID)
else
	@echo "Must be running Application Sever to see stats"
endif

top:
ifdef FULL_APP_SERVER_ID
	@docker top $(FULL_APP_SERVER_ID)
else
	@echo "Must be running Application Sever to see processes"
endif

#######################################################################
# GENERAL COMMANDS
endif
#######################################################################
check_vagrant:
	@echo "Checking whether Vagrant installed... "
ifdef VAGRANT
	@echo "YES"
else
	@echo "NO! Please install Vagrant"
	@exit 1
endif

check_plugins:
	@echo "Checking whether vagrant-docker-compose installed... "
ifdef VAGRANT_DOCKER_COMPOSE
	@echo "YES"
else
	@echo "Missing vagrant-docker-compose"
	@echo "Please run \`make install_plugins\`"
	@exit 1
endif

install_plugins:
	@echo "Installing vagrant-docker-compose"
	@vagrant plugin install vagrant-docker-compose

check_virtualbox:
	@echo "Checking whether Virtualbox installed... "
ifdef VIRTUALBOX
	@echo "YES"
else
	@echo "NO! Please install Virtualbox"
	@exit 1
endif

check_docker:
	@echo "Checking whether docker installed..."
ifdef DOCKER
	@echo "YES"
else
	@echo "NO! Please install Docker"
	@exit 1
endif

check_docker_compose:
	@echo "Checking whether docker-compose installed... "
ifdef DOCKER_COMPOSE
	@echo "YES"
else
	@echo "NO! Please install docker-compose"
	@exit 1
endif

release: build

default: build
