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
      version="0.5" \
      release-date="2017-06-28"


# COPY ./source_script_file /tmp/target_script_file
COPY ./config.yml  /tmp/config.yml

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
EXPOSE 8443

# Start the service
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
