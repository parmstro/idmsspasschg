# idmsspasschg
## Purpose

A container project to implement the ability to gain access to idm from an external alias. This is based on the documentation from https://www.adelton.com/freeipa/freeipa-behind-proxy-with-different-name . The goal of this project is to be able to run a container on the IdM Server that can accept a connection from an external URL and proxy it to the internal URL of the IdM server. This will allow full access to the IdM WebUI from the external URL. An alternate deployment would be to create a simple WebUI and service to allow a user to enter their current username, current password, an updated password and confirm the updated password and pass that back to the IdM server for processing and then inform the user of the result. 

## Current Iteration

Implementing the basic proxy.

## Installation 

TBD - basic docker pull. Entry points should start the container appropriately and expose basic ports. Environment should define the proxied and target FQDNs.



