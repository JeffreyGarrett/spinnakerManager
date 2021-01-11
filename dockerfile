FROM debian:buster-slim

# Things that might change (version numbers, etc.) or reused
ENV BIN_DIR "/usr/local/bin"
ENV AWSCLI_VERSION "1.16.*"
ENV KUBECTL_VERSION "1.18.9"
ENV AWS_IAM_AUTH_VERSION "1.11.5/2018-12-06"
ENV HELM_VERSION "v3.4.2"
ENV DEBIAN_FRONTEND=noninteractive

# Download and install kubectl
RUN apt-get update && apt-get install -f -y apt-transport-https gnupg2 curl awscli jq 
#issue with java needs this for fix
RUN mkdir -p /usr/share/man/man1 && \ 
    apt-get update && apt-get install --no-install-recommends -fy openjdk-11-jre
#KUBECTL
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update && apt-get install -y kubectl

# Download and install aws-iam-authenticator
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/aws-iam-authenticator \
    && chmod +x ./aws-iam-authenticator \
    && mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH \
    && echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

    # Download and configure eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
    && mv /tmp/eksctl /usr/local/bin

# Download and configure Halyard see avaialable commands for script
#usage: $0 [-y] [--version=<version>] [--user=<user>]
#    -y                              Accept all default options during install
#                                    (non-interactive mode).
#
#    --halyard-bucket-base-url <name>   The bucket the Halyard JAR to be installed
#                                       is stored in.
#
#    --download-with-gsutil          If specifying a GCS bucket using
#                                    --halyard-bucket-base-url, this flag causes the 
#                                   install script to rely on gsutil and its 
#                                    authentication to fetch the Halyard JAR.
#
#    --config-bucket <name>          The bucket the your Bill of Materials and
#                                    base profiles are stored in.
#
#    --spinnaker-repository <url>    Obtain Spinnaker artifact debians from <url>
#                                    rather than the default repository, which is
#                                    $SPINNAKER_REPOSITORY_URL.#
#
#    --spinnaker-registry <url>      Obtain Spinnaker docker images from <url>
#                                    rather than the default registry, which is
#                                    $SPINNAKER_DOCKER_REGISTRY.
#
#    --spinnaker-gce-project <name>  Obtain Spinnaker GCE images from <url>
#                                    rather than the default project, which is
#                                    $SPINNAKER_GCE_PROJECT.#
#
#    --version <version>             Specify the exact version of Halyard to
#                                    install.
#
#    --user <user>                   Specify the user to run Halyard as. This
#                                    user must exist.
RUN curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh \
    && useradd halyard \
    && bash InstallHalyard.sh -y --user halyard \
    && update-halyard

CMD [ "bash" ]