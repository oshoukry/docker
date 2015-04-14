#!/bin/sh

SCRIPT_PATH=${0%/*}

shutdown_all_containers() {
  COUNT=`docker ps -q |wc -l`
  echo "INFO: Stopping all containers [$COUNT]" 
  if [ $COUNT -gt 0 ]; then
    docker stop $(docker ps -q)
  fi
}

delete_all_containers() {
  COUNT=`docker ps -a -q |wc -l`
  echo "INFO: Deleting all containers [$COUNT]" 
  if [ $COUNT -gt 0 ]; then
    docker rm $(docker ps -a -q)
  fi
}

delete_all_images() {
  COUNT=`docker images -qa |wc -l`
  echo "INFO: Deleting all images [$COUNT]" 
  if [ $COUNT -gt 0 ]; then
    docker rmi -f $(docker images -q)
  fi
}

usage() {
  echo "Usage: $0 [stop|cleanup]"
}

case "$1" in
  stop)
    shutdown_all_containers
    ;;
  cleanup)
    shutdown_all_containers
    delete_all_containers
    delete_all_images
    ;;
  *)
    usage
    exit 1
esac
