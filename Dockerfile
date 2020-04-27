FROM ubuntu:20.04

# Open X-Windows ports
EXPOSE 6000-6010

# Open docker network port to use docker client on Windows
EXPOSE 2375 

# Install packages needed for adding more package repositories
RUN apt -y update \
    && apt -y install \
        apt-transport-https \
        curl \
        software-properties-common \
    && (yes | unminimize )

# Add Microsoft Azure CLI package repo for az command
# RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
#     tee /etc/apt/sources.list.d/azure-cli.list && \
#     curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Add Google Cloud repo to package sources for kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list

# Get the latest git
RUN apt-add-repository ppa:git-core/ppa

# Add Google Cloud repo to package sources for kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list

# Add docker, emacs, Azure CLI, Python
RUN apt -y update && \
    DEBIAN_FRONTEND=noninteractive apt -y install \
    dnsutils \
    docker.io \
    emacs \
    git \
    iputils-ping \
    ispell \
    jq \
    kubectl \
    make \
    man-db \
    meld \
    net-tools \
    python3-pip \
    software-properties-common \
    sudo \
    tzdata \
    wget \
    zip


# Remove the install info in a seperate step so adding extras doesn't cost much time
#RUN rm -rf /var/lib/apt/lists/*

# Install Azure CLI -- until it's in Ubuntu 20.04 -- package was azure-cli 
# curl -L https://aka.ms/InstallAzureCli | bash

# Install docker-compose
RUN curl -sL "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

RUN curl --silent --location --fail https://manpages.ubuntu.com/dman > /usr/bin/dman && chmod 555 /usr/bin/dman && echo '(setq manual-program "dman")' >> /etc/skel/.emacs

# Make python point to python3
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

RUN pip3 install pipenv

ENV developer="developer"
RUN echo '%sudo  ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN useradd  -ms /bin/bash $developer && usermod -aG sudo $developer

VOLUME /home
WORKDIR /home/$developer

USER $developer
CMD DISPLAY=host.docker.internal:0 bash -l -c emacs

# These change on every build -- don't bust the caching
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL

LABEL   org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.vcs-url="https://github.com/neilswinton/emacs-developer" \
        org.label-schema.vcs-ref=$VCS_REF

