UNAME := $(shell uname)

ifeq ($(UNAME),Darwin)
OS := osx
VAGRANT := $(shell { type vagrant } 2>/dev/null)

ifeq ($(UNAME),Linux)
@echo linux
OS := linux
DOCKER := $(shell { type docker } 2>/dev/null)
DOCKER_COMPOSE := $(shell { type docker-compose } 2>/dev/null)
SHORT_APP_SERVER_ID := $(shell { docker ps | grep appsvr | awk -F ' ' '{print $1}'; } 2>/dev/null)
ifdef SHORT_APP_SERVER_ID
FULL_APP_SERVER_ID := $(shell { docker ps --no-trunc -q | grep $short_app_server_id; } 2>/dev/null)
endif

else
	@echo "\n\n The Django App Template currently only supports Linux and OSX."
	@exit 1
endif
endif


.PHONY: build push shell run start stop rm release check

# COMMANDS FOR USING OSX
ifeq ($(OSX),1)
check: check_vagrant check_virtualbox

build:
	@vagrant provision

up:
	@vagrant up

# COMMANDS FOR RUNNING ON LINUX
else
check: check_docker check_docker_compose

build:
	@docker-compose build

up:
	@docker-compose up

test:
ifdef FULL_APP_SERVER_ID
	@echo "its alive"
	docker exec $(FULL_APP_SERVER_ID) python /src/app/manage.py test
else
	@echo "You must start docker-compose before running tests"
	@echo "Please run \`make up\`"
endif
endif


debug:
	@sed -i s/ports/\#ports/ docker-compose.yml
	@sed -i s/"- \"8000:8000\""/"\#- \"8000:8000\""/ docker-compose.yml
	@sed -i s/ENVIRONMENT=development/ENVIRONMENT=debug/ docker-compose.yml
	@sed -i s/"uwsgi \-\-ini \/src\/app\/uwsgi\.ini"/"python \/src\/app\/manage.py runserver 0.0.0.0:8000\"\n  ports:\n    - \"8000:8000"/ docker-compose.yml

	@echo "\n\nRunning app in debug mode. See docs for ipdb."
	@echo "This command changes docker-compose.yml temporarily, do not commit these changes"
	@echo "To exit debugger use CTRL-D. To shut off server use CTRL-C."
	ifeq ($(OSX),1)
		@vagrant ssh 
	else
		@docker-compose -f docker-compose.yml run --service-ports appsvr
	endif

	@sed -i s/ENVIRONMENT=debug/ENVIRONMENT=development/ docker-compose.yml
	@sed -i s/"python \/src\/app\/manage.py runserver 0.0.0.0:8000"/"uwsgi \-\-ini \/src\/app\/uwsgi\.ini"/ docker-compose.yml
	@sed -i '/  ports:/ d' docker-compose.yml
	@sed -i '/    - "8000:8000"/ d' docker-compose.yml
	@sed -i s/\#ports/ports/ docker-compose.yml
	@sed -i s/"\#- \"8000:8000\""/"- \"8000:8000\""/ docker-compose.yml



shell:

run:

start:

stop:

rm:

check_vagrant:
	@echo "Checking whether Vagrant installed... "
ifdef VAGRANT
	@echo "YES"
else
	@echo "NO!\n\n\ Please install Vagrant \n\n"
	@exit 1
endif

install_plugins:
	@vagrant plugin install vagrant-docker-compose

check_virtualbox:
	@echo "Checking whether Virtualbox installed... "
ifdef VIRTUALBOX
	@echo "YES"
else
	@echo "NO!\n\n Please install Virtualbox \n\n"
	@exit 1
endif

check_docker:
	@echo "Checking whether docker installed..."
ifdef DOCKER
	@echo "YES"
else
	@echo "NO!\n\n Please install Docker \n\n"
	@exit 1
endif

check_docker_compose:
	@echo "Checking whether docker-compose installed... "
ifdef DOCKER_COMPOSE
	@echo "YES"
else
	@echo "NO!\n\n Please install docker-compose \n\n"
	@exit 1
endif

release: build

default: build
