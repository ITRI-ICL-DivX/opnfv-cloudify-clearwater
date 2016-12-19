#!/bin/bash -e

ctx logger debug "${COMMAND}"

ctx logger info "Configure the APT software source"
if [ ! -f /etc/apt/sources.list.d/clearwater.list ]
  then
    echo 'deb file:///root/cw-repo/mirror/repo.cw-ngv.com/archive/repo84/binary /' | sudo tee --append /etc/apt/sources.list.d/clearwater.list
    curl -L http://repo.cw-ngv.com/repo_key | sudo apt-key add -
fi
sudo sed -i 's/http:\/\/nova.clouds.archive.ubuntu.com\/ubuntu\//http:\/\/ubuntu.cs.nctu.edu.tw\/ubuntu\//g' /etc/apt/sources.list
sudo apt-get update

ctx logger info "Now install the software"
sudo DEBIAN_FRONTEND=noninteractive apt-get install clearwater-management --yes --force-yes
ctx logger info "The software is installed"

/usr/share/clearwater/clearwater-etcd/scripts/wait_for_etcd
sudo /usr/share/clearwater/clearwater-config-manager/scripts/upload_shared_config
# sudo /usr/share/clearwater/clearwater-config-manager/scripts/apply_shared_config

ctx logger info "Installation is done"
