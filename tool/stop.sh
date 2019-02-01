#!/usr/bin/env bash

echo "stop iving openvpn server ..."
docker-compose down
docker rm $(docker stop $(docker ps -a -q --filter="name=iving_openvpn"))
docker rmi $(docker images -q --filter=reference="*iving_openvpn*") --force
