#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to display usage information
usage() {
    echo "Usage: $0 <image_name> <version> [registry]"
    echo "Example: $0 your-registry/your-image-name 1.3.54 [docker.io]"
    exit 1
}

# Check if correct number of arguments are provided
if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    usage
fi

# Set variables from command-line arguments
IMAGE_NAME="$1"
VERSION="$2"
REGISTRY="${3:-docker.io}"  # Use docker.io as default if not provided

# Validate semantic version format
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in semantic format (major.minor.patch)"
    exit 1
fi

# Extract major and minor versions
MAJOR_VERSION=$(echo $VERSION | cut -d. -f1)
MINOR_VERSION=$(echo $VERSION | cut -d. -f1,2)

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Login to Docker registry
echo "Logging in to Docker registry: $REGISTRY"
docker login $REGISTRY || handle_error "Failed to login to $REGISTRY"

# Build the Docker image
echo "Building Docker image: $IMAGE_NAME:$VERSION"
docker build -t "$IMAGE_NAME:$VERSION" . || handle_error "Failed to build image"

# Tag the image with different versions
echo "Tagging image with version tags"
docker tag "$IMAGE_NAME:$VERSION" "$IMAGE_NAME:latest" || handle_error "Failed to tag image as latest"
docker tag "$IMAGE_NAME:$VERSION" "$IMAGE_NAME:$MAJOR_VERSION" || handle_error "Failed to tag image with major version"
docker tag "$IMAGE_NAME:$VERSION" "$IMAGE_NAME:$MINOR_VERSION" || handle_error "Failed to tag image with minor version"

# Push the images to the registry
echo "Pushing images to registry"
docker push "$IMAGE_NAME:$VERSION" || handle_error "Failed to push $VERSION tag"
docker push "$IMAGE_NAME:latest" || handle_error "Failed to push latest tag"
docker push "$IMAGE_NAME:$MAJOR_VERSION" || handle_error "Failed to push major version tag"
docker push "$IMAGE_NAME:$MINOR_VERSION" || handle_error "Failed to push minor version tag"

echo "Images built and published successfully!"

# Optional: Logout from Docker registry
# Uncomment the following line if you want to logout after pushing
# docker logout $REGISTRY

# Optional: Clean up local images
# Uncomment the following lines if you want to remove the local images after pushing
# echo "Cleaning up local images"
# docker rmi "$IMAGE_NAME:$VERSION"
# docker rmi "$IMAGE_NAME:latest"
# docker rmi "$IMAGE_NAME:$MAJOR_VERSION"
# docker rmi "$IMAGE_NAME:$MINOR_VERSION"