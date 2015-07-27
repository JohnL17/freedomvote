.PHONY: help docker docker-clean docker-init docker-migrate docker-makemessages docker-compilemessages

help:
	@echo "The following make targets are available:"
	@echo "  * docker                   - Start the docker containers"
	@echo "  * docker-init              - Initialize docker containers"
	@echo "  * docker-clean             - Remove all docker containers"
	@echo "  * docker-migrate           - Apply migrations to docker env"
	@echo "  * docker-makemessages      - Generate .po locale files"
	@echo "  * docker-compilemessages   - Generate .mo locale files"
	@echo ""
	@echo ""
	@echo "If you're new to the project, run this to get started:"
	@echo ""
	@echo " make docker-init docker"

docker:
	@docker-compose up --no-recreate

docker-clean:
	@docker-compose kill
	@docker-compose rm -f

docker-init:
	@docker-compose up -d --no-recreate
	@docker-compose run web python app/manage.py syncdb --noinput
	@docker-compose run web python app/manage.py migrate
	@docker-compose run web python app/manage.py loaddata tools/docker/user.json

docker-migrate:
	@vagrant ssh -c 'cd /vagrant/app && sudo python manage.py migrate'

docker-makemessages:
	@vagrant ssh -c 'cd /vagrant/app && sudo python manage.py makemessages -a'

docker-compilemessages:
	@vagrant ssh -c 'cd /vagrant/app && sudo python manage.py compilemessages'
