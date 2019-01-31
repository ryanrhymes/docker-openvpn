
.PHONY: all
all: build

.PHONY: build
build:
	docker build -f Dockerfile -t ryanrhymes/iving_openvpn:alpine .
	docker push ryanrhymes/iving_openvpn:alpine

.PHONY: liang
liang:
	docker run -v iving_openvpn_data:/etc/openvpn --log-driver=none --rm -it ryanrhymes/iving_openvpn:alpine easyrsa build-client-full liang nopass
	docker run -v iving_openvpn_data:/etc/openvpn --log-driver=none --rm ryanrhymes/iving_openvpn:alpine ovpn_getclient liang > liang.ovpn

.PHONY: clean
clean:
	docker-compose down
	docker rm $(docker stop $(docker ps -a -q --filter ancestor=iving_openvpn --format="{{.ID}}"))
	docker rmi $(docker images -q --filter=reference="*iving_openvpn*") --force
	#docker volume rm iving_openvpn_data

.PHONY: push
push:
	git commit -am "coding ..." && \
	git push origin master
