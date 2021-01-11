#!/usr/bin/env bash
VERSION=0.0.1

function version () {
    echo "Spin-manager version v$VERSION"
    print_usage
}

function install_eks () {
    echo "Installing Spinnaker on eks cluster"
    aws eks update-kubeconfig --name eks-spinnaker --region us-west-2 --alias eks-spinnaker
    # Enable the Kubernetes provider
    hal config provider kubernetes enable

    # Set the current kubectl context to the cluster for Spinnaker
    kubectl config use-context $KUBE_CONTEXT
}

function install_mini () {
    echo "Installing Spinnaker on eks cluster"
}

function uninstall_eks () {
    echo "Uninstalling spinnaker"
    #hal deploy clean
    #~/.hal/uninstall.sh
}

function uninstall_mini () {
    echo "Installing Spinnaker on eks cluster"
}

function print_usage() {
  cat <<EOF
usage: $0 [COMMAND] 
    Commands: 
            version         gets the version
            install         installs on an eks cluster
            uninstall       uninstalls from an eks cluster
            update          updates the install based on the config
EOF
}


#./commands/hello.sh

case $1 in
    "version"|"v")
        version
        ;;
    "install"|"i")
        install_eks
        ;;
    "uninstall"|"u")
        uninstall_eks
        ;;
    *)
    echo "didn't match an available command"
    print_usage
    ;;
esac
