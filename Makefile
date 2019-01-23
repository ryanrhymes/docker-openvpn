
.PHONY: all
all: build

.PHONY: build
build:
	docker build -f Dockerfile -t ryanrhymes/iving_openvpn:alpine .
	docker push ryanrhymes/iving_openvpn:alpine

.PHONY: init
init:
	docker volume create iving_openvpn_data
	docker run -v iving_openvpn_data:/etc/openvpn --log-driver=none --rm ryanrhymes/iving_openvpn:alpine ovpn_genconfig -u udp://${IVING_OPENVPN_SERVER_URL}
	docker run -v iving_openvpn_data:/etc/openvpn --log-driver=none --rm -it ryanrhymes/iving_openvpn:alpine ovpn_initpki

.PHONY: clean
clean:
	$(RM) -r build dist

.PHONY: push
push:
	git commit -am "coding ..." && \
	git push origin master
