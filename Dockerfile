FROM centos:centos7
MAINTAINER Stephen Kolar

# Install required packages
RUN yum -y update \
	&& yum -y install openssh-server openssh-clients

RUN systemctl enable sshd \
	&& systemctl start sshd

RUN yum -y install curl policycoreutils postfix

RUN systemctl enable postfix \
	&& systemctl start postfix

RUN curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash

Run yum -y install gitlab-ce

# Expose web & ssh
EXPOSE 443 80 22

# Define data volumes
VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]

# Copy assets
COPY assets/wrapper /usr/local/bin/

# Wrapper to handle signal, trigger runit and reconfigure GitLab
CMD ["/usr/local/bin/wrapper"]