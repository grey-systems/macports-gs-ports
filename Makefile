PORTS_FILE:=            ports.txt
LOCAL_PORTS_DIR:=       ~/ports
PORT_INDEX_SENTINEL:=   $(LOCAL_PORTS_DIR)/.port-index.sentinel

.PHONY: all
all:
	@echo "Nothing to do."

$(PORT_INDEX_SENTINEL):
	@$(MAKE) port-index
	@touch $@

.PHONY: port-index
port-index:
	@(cd $(LOCAL_PORTS_DIR) ; portindex )

.PHONY: livecheck
livecheck:
	@port livecheck maintainer:emcrisostomo
	@port livecheck maintainer:patarra
	@for i in $$(cat $(PORTS_FILE)) ; \
	do \
		port livecheck $${i} || true ; \
	done

.PHONY: list-ports
list-ports:
	@cat $(PORTS_FILE)

.PHONY: create-port-branch
create-port-branch:
	@echo "Port name:"
	@read PORT_NAME && \
		if [ -z $${PORT_NAME} ] ; then echo "Invalid port name." ; exit 1 ; fi && \
		git checkout upstream_master && \
		git checkout -b $${PORT_NAME}

.PHONY: pull-upstream
pull-upstream:
	git checkout upstream_master
	git pull
	git checkout master
	git merge --no-edit upstream_master
	portindex
