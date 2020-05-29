#!/bin/bash


currentPath=$(pwd)
restPath=$(pwd)/../catapult-rest

cd $restPath

# Update /etc/hosts adding:
#
#copy "127.0.0.1       db api-node-broker-0 api-node-0" into /etc/hosts

# RUN:
# sudo mkdir /usr/local/share/symbol
# sudo ln -s $PWD/build/catapult-config/api-node-0/userconfig/resources /usr/local/share/symbol/api-node-config


npm install -g yarn
yarn_setup.sh

for module in 'catapult-sdk' 'tools' 'spammer' 'rest'
do
	cd "${module}" && yarn rebuild
	cd ..
done

cd rest && yarn start ${currentPath}/build/catapult-config/rest-gateway-0/userconfig/rest.json

cd $currentPath

