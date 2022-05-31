#!/bin/bash
echo "========================================"
echo "Bootstrapping"
echo "========================================"

echo "========================================"
echo "Checking if any of the required resources actually exists"
echo "========================================"

if [[ $(oc get deployment minio -n minio  --ignore-not-found) ]]
then
  echo "At the cluster exists the MinIO deployment"
  echo "========================================"
  echo "Please, clean all the pre-existing resources"
  echo "========================================"
  exit
else
  echo "File Browser it's not deployed"
  echo "========================================"
  if [[ $(oc get ns filebrowser --ignore-not-found) ]]
  then
    echo "FileBrowser namespace exists"
    echo "========================================"
    echo "========================================"
    echo "Please, clean all the pre-existing resources"
    echo "oc delete project filebrowser"
    echo "========================================"
    exit
  fi
fi

while true; do
    echo "========================================"
    echo "  Do you wish to deploy File Browser?"
    echo "    - Yes   : Deploy File Browser"
    echo "    - No    : Skip the File Browser deployment"
    echo "========================================"
    read -p "" filebrowser
    case $filebrowser in
        [Yy]* ) echo ""

                echo ""
                echo "Creating the required namespace"

                oc create -f manifests/namespace.yaml

                while [[ $(oc get ns filebrowser -o 'jsonpath={..status.phase}') != Active ]]; do
                  echo "The namespace is not still Active"
                  echo "..."
                  sleep 5
                done

                echo ""
                echo ""
                echo "Creating a privileged SA"

                oc apply -f manifests/serviceaccount.yaml
                oc apply -f manifests/clusterrolebinding.yaml

                echo ""
                echo ""
                echo "Deploying File Browser Statefulset"

                oc apply -f manifests/configmap.yaml
                oc apply -f manifests/statefulset.yaml
                oc apply -f manifests/service.yaml
                oc apply -f manifests/route.yaml


                while [[ $( oc get po -n filebrowser -l app=filebrowser -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
                  sleep 1
                  echo "File Browser is still starting"
                  echo "..."
                  sleep 5
                done

                echo "========================================"
                echo "File Browser WEBUI Route."
                echo "========================================"
                echo ""
                oc get route filebrowser -n filebrowser -o 'jsonpath={..spec.host}'
                echo ""
                echo "========================================"
                echo ""
                echo ""
                echo ""
                echo ""
                echo "========================================"
                echo "Access to the UI with default credentials:"
                echo ""
                echo "Username: admin"
                echo "Password: admin"
                echo ""
                echo "========================================"

            break;;
        [Nn]* ) echo "File Browser is not going to be deployed"; break;;
        * ) for run in {1..10}; do
              echo ""
            done
            echo "========================================"
            echo "Please answer Yes or No."
            echo "========================================" ;;
    esac
done
