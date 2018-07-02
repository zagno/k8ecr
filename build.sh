#!/bin/bash -ex

NAME=k8ecr
TAG="${1:-dev}"

# Building docker image
docker build . -t "$NAME:$TAG"

# Copy the binary from Docker back to the host
docker run --rm -v "$(pwd)/build:/build" "$NAME:$TAG" sh -c "cp /k8ecr /build/k8ecr"
