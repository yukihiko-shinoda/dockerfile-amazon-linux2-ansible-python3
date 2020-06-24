FROM amazonlinux:2.0.20200406.0
# @see https://aws.amazon.com/jp/premiumsupport/knowledge-center/ec2-enable-epel/
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
 && yum --enablerepo=epel install -y ansible \
 && yum clean all
COPY ./ansible-playbook-base /tmp/ansible-playbook
RUN cd /tmp/ansible-playbook \
 && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook playbook.yml \
    -vvv -c local -i inventories/container -t pip,cleaning \
 && yum remove -y ansible
ENV PYENV_ROOT /opt/pyenv
ENV PATH /opt/pyenv/shims:${PYENV_ROOT}/bin:${PATH}
RUN python -m pip install ansible \
 && yum clean all \
 && rm -rf /tmp/*
ENTRYPOINT ["/bin/bash", "-l"]
