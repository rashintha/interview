#!/bin/bash

env='prod'

INFO_C="\e[46m"
SUCCESS_C="\e[42m"
ERROR_C="\e[41m"
END_C="\e[0m"

INFO_TEXT="${INFO_C}INFO:${END_C}"
SUCCESS_TEXT="${SUCCESS_C}SUCCESS:${END_C}"
ERROR_TEXT="${ERROR_C}ERROR:${END_C}"

if [[ $# -eq 0 ]]; then
  echo -e "${INFO_TEXT} No environment provided. Using prod environment."
else

  for i in $@; do
    case $i in
    --*)
      if [[ $i == *"--env"* ]]; then
        IFS='=' read -ra PARAM <<<"$i"
        env=${PARAM[1]}
      fi
      ;;

    *)
      echo -e "${INFO_TEXT} No environment provided. Using prod environment."
      ;;
    esac
  done

fi

if [[ -e docker/cfg/${env}.env ]]; then
  source docker/cfg/${env}.env
else
  echo -e "${ERROR_TEXT} Environment file not found."
  exit 2
fi

## WebApp -----------------------------------------------------------------------

echo -e "${INFO_TEXT} Building the WebApp..."

# Remove existing containers
result=$(docker ps -a -q --filter ancestor=$SRVICE_WEBAPP_INSTANCE:local --format="{{.ID}}")

if [[ ${#result} -ne 0 ]]; then
  echo -e "${INFO_TEXT} Removing existing containers."
  result=$(docker rm $(docker stop $(docker ps -a -q --filter ancestor=$SRVICE_WEBAPP_INSTANCE:local --format="{{.ID}}")))
  status=$?

  if [[ $status -eq 0 ]]; then
    echo -e "${SUCCESS_TEXT} Containers removed."
  else
    echo -e "${ERROR_TEXT} Error in removing containers."
    exit 2
  fi
fi

# Docker build
echo -e "${INFO_TEXT} Preparing builder..."
result=$(docker buildx rm --all-inactive --force)
result=$(docker buildx create --use --name interviewX)

echo -e "${INFO_TEXT} Building..."
docker buildx build --tag $SRVICE_WEBAPP_INSTANCE:local --file $DOCKER_WEBAPP_FILE --load .
status=$?

result=$(docker buildx stop interviewX)

if [[ $status -eq 0 ]]; then
  echo -e "${SUCCESS_TEXT} Building finished."
else
  echo -e "${ERROR_TEXT} Error in building."
  exit 2
fi

# Creating a new container
echo -e "${INFO_TEXT} Creating a new container."
result=$(docker run -d -p $WEBAPP_PORT:80 $SRVICE_WEBAPP_INSTANCE:local)
status=$?

if [[ $status -eq 0 ]]; then
  echo -e "${SUCCESS_TEXT} Container ($result) created."
else
  echo -e "${ERROR_TEXT} Error in creating container."
  exit 2
fi

## Server -----------------------------------------------------------------------

echo -e "${INFO_TEXT} Building the Server..."

# Remove existing containers
result=$(docker ps -a -q --filter ancestor=$SRVICE_SERVER_INSTANCE:local --format="{{.ID}}")

if [[ ${#result} -ne 0 ]]; then
  echo -e "${INFO_TEXT} Removing existing containers."
  result=$(docker rm $(docker stop $(docker ps -a -q --filter ancestor=$SRVICE_SERVER_INSTANCE:local --format="{{.ID}}")))
  status=$?

  if [[ $status -eq 0 ]]; then
    echo -e "${SUCCESS_TEXT} Containers removed."
  else
    echo -e "${ERROR_TEXT} Error in removing containers."
    exit 2
  fi
fi

# Docker build
echo -e "${INFO_TEXT} Preparing builder..."
result=$(docker buildx rm --all-inactive --force)
result=$(docker buildx create --use --name interviewX)

echo -e "${INFO_TEXT} Building..."
docker buildx build --tag $SRVICE_SERVER_INSTANCE:local --file $DOCKER_SERVER_FILE --load .
status=$?

result=$(docker buildx stop interviewX)

if [[ $status -eq 0 ]]; then
  echo -e "${SUCCESS_TEXT} Building finished."
else
  echo -e "${ERROR_TEXT} Error in building."
  exit 2
fi

# Creating a new container
echo -e "${INFO_TEXT} Creating a new container."
result=$(docker run -d -p $SERVER_PORT:80 $SRVICE_SERVER_INSTANCE:local)
status=$?

if [[ $status -eq 0 ]]; then
  echo -e "${SUCCESS_TEXT} Container ($result) created."
else
  echo -e "${ERROR_TEXT} Error in creating container."
  exit 2
fi

exit 0
