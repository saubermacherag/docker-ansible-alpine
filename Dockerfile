FROM python:2.7.18-alpine3.11

MAINTAINER Patrick Pötz <devops@wastebox.biz>

ENV ANSIBLE_VERSION=2.9.11

RUN echo "=== INSTALLING SYS DEPS" && \
    apk update && \
    apk add --no-cache \
        git \
        openssh-client \
        openssl \
        rsync \
        sshpass \
        which \
        gettext && \
    apk --update add --virtual \
        builddeps \
        libffi-dev \
        openssl-dev \
        build-base && \
    \
    echo "=== INSTALLING PIP DEPS" && \
    pip install --upgrade \
        pip \
        cffi && \
    pip install \
        ansible==$ANSIBLE_VERSION \
        botocore \
        boto \
        boto3 && \
    \
    echo "=== Cleanup this mess ===" \
    apk upgrade && \
    apk del builddeps && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /etc/ansible \
 && echo 'localhost' > /etc/ansible/hosts \
 && echo -e """\
\n\
Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config

RUN which python
RUN ansible --version
