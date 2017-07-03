# idmsspasschg
## Purpose

A container project to implement the ability to gain access to idm from an external alias. This is based on the documentation from https://www.adelton.com/freeipa/freeipa-behind-proxy-with-different-name . The goal of this project is to be able to run a container on the IdM Server that can accept a connection from an external URL and proxy it to the internal URL of the IdM server. This will allow full access to the IdM WebUI from the external URL. An alternate deployment would be to create a simple WebUI and service to allow a user to enter their current username, current password, an updated password and confirm the updated password and pass that back to the IdM server for processing and then inform the user of the result. 

## Current Iteration

Implementing the basic proxy. The current code allows you to run the container on a host other than the IdM/IPA Server and will manage the proxying of the UI. Users can access all the functionality provided by their access credentials through the UI without restrictions. In other words, a simple proxy. The configuration of IdM at this time prevents running the proxy container on an alternate port on the same server - the source port of the proxy must be 443. 


## Requirements

Repositories

rhel-7-server-rpms
rhel-7-server-optional-rpms
epel

Base container

registry.access.redhat.com/rhel7:latest

Edit vars in config.yml to reflect your proxy name
Build the container.
Ensure your proxy name is resolvable via DNS
Run the container map external port 443 to container port 443

e.g. sudo docker run -d -h someserver.parmstrong.ca -p 443:443 --name=myidmproxy rhel7idmproxy


