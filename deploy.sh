#!/bin/bash

function package() {
  echo "removing out directory..."
  rm -rf out
  
  echo "removing artifacts directory..."
  rm -rf artifacts

  echo "creating artifacts directory..."
  mkdir artifacts

  echo "building lambda assets..."
  node esbuild.js

  echo "assets built"

  echo "deploying resources..."
  cd terraform

  echo "validating terrform config..."
  terraform validate

  echo "generating terraform plan"
  terraform plan

  echo "applying terraform plan"
  terraform apply
}

package