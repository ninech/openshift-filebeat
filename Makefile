include ./env_make

.PHONY: build push shell run start stop rm release test clean default all

all: clean build push

GET_VER = $(word 1,$(subst |, ,$1))
GET_SHA = $(word 2,$(subst |, ,$1))
GET_TYPE = $(word 3,$(subst |, ,$1))

build:
	$(foreach var,$(VH_LIST),docker build -t $(NS)/$(REPO):$(call GET_VER,$(var)) --build-arg FILEBEAT_VERSION=$(call GET_VER,$(var)) --build-arg FILEBEAT_SHA=$(call GET_SHA,$(var)) --build-arg FILEBEAT_SHA_TYPE=$(call GET_TYPE,$(var)) .;)

push:
	$(foreach var,$(VH_LIST),docker push $(NS)/$(REPO):$(call GET_VER,$(var));)

shell:
	docker run --rm --name $(NAME)-$(INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION) /bin/bash

run:
	docker run --rm --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

start:
	docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

stop:
	docker stop $(NAME)-$(INSTANCE)

rm:
	docker rm $(NAME)-$(INSTANCE)

release: build
	make push -e VERSION=$(VERSION)

clean:
	$(foreach var,$(VH_LIST),docker rmi $(NS)/$(REPO):$(call GET_VER,$(var));)

default: build