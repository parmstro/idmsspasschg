# A container to implement a basic web proxy specifically for IdM Servers
#
# Based on the information brovided in:
# https://www.adelton.com/freeipa/freeipa-behind-proxy-with-different-name AND
# https://www.adelton.com/freeipa/freeipa-behind-load-balancer
#


# build it based on RHEL7 - this may drive a requirement.

FROM registry.access.redhat.com/rhel7:latest

# its from me
LABEL maintainedby="Paul Armstrong" \
      version="0.8" \
      release-date="2017-06-28"


# COPY ./source_script_file /tmp/target_script_file
COPY ./config.yml  /tmp/config.yml

# If you want to use custom certs, copy the key and certificate to the container
# NOTE: edit the path to these files and ensure that they can be read during build
# in the REAL WORLD we will do this with persistent volumes and claims
COPY ./private/container_ssl.key /tmp/container_ssl.key
COPY ./private/container_ssl.crt /tmp/container_ssl.crt


ENV TZ=America/Toronto

RUN yum repolist --disablerepo=* && \
    yum-config-manager --disable \* > /dev/null && \
    yum-config-manager --enable rhel-7-server-rpms --enable epel --enable rhel-7-server-optional-rpms > /dev/null && \
    yum -y install wget && \
    wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y localinstall epel-release-latest-7.noarch.rpm && \
    yum -y install httpd mod_ssl mod_proxy_html mod_proxy_balancer ansible && \
    yum -y update && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

RUN echo "" > /etc/httpd/conf.d/ssl.conf && \
    ansible-playbook /tmp/config.yml && \
    cat /etc/httpd/conf.d/ssl.conf

# Expose WebServer ports
EXPOSE 443

# Start the service
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
