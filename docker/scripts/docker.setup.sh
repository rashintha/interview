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
  set -a
  source docker/cfg/${env}.env
  set +a
else
  echo -e "${ERROR_TEXT} Environment file not found."
  exit 2
fi

echo -e "${INFO_TEXT} Building & Configuring..."

docker compose -f ./docker/docker-compose.yaml down
docker compose -f ./docker/docker-compose.yaml up --build -d

status=$?

if [[ $status -eq 0 ]]; then
  echo -e "${SUCCESS_TEXT} Build success."
else
  echo -e "${ERROR_TEXT} Error in building."
  exit 2
fi

exit 0
