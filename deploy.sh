#!/bin/bash

function deploy() {
  bash ./build.sh
  
  echo "deploying assets..."

  echo "deploying resources..."
  cd terraform

  echo "validating terrform config..."
  terraform validate

  echo "generating terraform plan"
  terraform plan

  echo "applying terraform plan"
  terraform apply
}

deploy