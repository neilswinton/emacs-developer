FROM ubuntu:18.04

ARG BUILD_DATE
ARG VCS_REF

# Open X-Windows ports
EXPOSE 6000-6010

# Open docker network port to use docker client on Windows
EXPOSE 2375 

LABEL   org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.vcs-url="https://github.com/neilswinton/emacs-developer" \
        org.label-schema.vcs-ref=$VCS_REF

# Install pre-reqs to docker install plus tools
RUN apt -y update && apt -y install \
    apt-transport-https \
    ca-certificates \ 
    curl \
    iputils-ping \
    dnsutils \
    jq \
    software-properties-common \
    sudo

# Add Microsoft Azure CLI repo to sources
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/azure-cli.list && \
    curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Add docker repo
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

# Add docker, emacs, Azure CLI, Python
RUN apt -y update && \
    apt-cache policy docker-ce && \
    DEBIAN_FRONTEND=noninteractive apt -y install \
    azure-cli \
    docker-ce \
    emacs \
    git \
    make \
    man-db \
    net-tools \
    python-pip \
    sudo \
    tzdata \
    wget 

# Remove the install info in a seperate step so adding extras doesn't cost much time
RUN rm -rf /var/lib/apt/lists/*

# Install docker-compose
RUN curl -sL "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose


ENV developer="developer"
RUN echo '%sudo  ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN useradd  -ms /bin/bash $developer && usermod -aG sudo $developer

VOLUME /home
WORKDIR /home/$developer

USER $developer
CMD DISPLAY=host.docker.internal:0 bash -l -c emacs
