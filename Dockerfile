FROM contrainfra/linchpin:latest

USER root
ENV HOME=/home/jenkins
ENV PinFile=./entitlement-tests/CCI/Linchpin/beaker/simple/PinFile

# Install some requirements
#RUN echo "yum install some requirements" \
#  && yum install -y git krb5-devel libselinux-python libxml2-devel libxslt-devel libxslt-python libxslt-python gcc

# Download the code
RUN mkdir /home/jenkins \
  && cd /home/jenkins \
  && git clone http://git.app.eng.bos.redhat.com/git/entitlement-tests.git

# Copy the script to install
COPY linchpin_install.sh /home/jenkins/linchpin_install.sh

# Install Red Hat SSL certificates for Internal systems
RUN curl -k -o /etc/yum.repos.d/it-iam.repo https://gitlab.corp.redhat.com/it-iam/idm-user-configs/raw/master/rhit-legacy-client/rhit-legacy-configs-1.0.0/yum.repos.d/it-iam.repo \
  && curl -k -o /tmp/RPM-GPG-KEY-redhat-git https://gitlab.corp.redhat.com/it-iam/idm-user-configs/raw/master/rhit-legacy-client/rhit-legacy-configs-1.0.0/rpm-gpg/RPM-GPG-KEY-redhat-git \
  && rpm --import /tmp/RPM-GPG-KEY-redhat-git \
  && yum install -y rhit-legacy-configs \
  && yum clean all

# Load Beaker client configurations
RUN cd /home/jenkins/entitlement-tests/CCI/Linchpin/beaker \
  && cp jenkins.keytab-entitlement-qe-jenkins.rhev-ci-vms.eng.rdu2.redhat.com /etc/ \
  && cp beaker.conf /etc/beaker/client.conf

WORKDIR /home/jenkins
CMD ["/home/jenkins/linchpin_install.sh"]
