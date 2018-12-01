#!/bin/bash

if [ -z "$1" ]
then
  echo "ERROR: missing appname argument"
  exit 2
fi

# which heroku login is used here?
# heroku whoami?
# error if not logged in
# echo logged in username

heroku kafka:wait -a $1

export topic1='edm-ui-click'
export topic1Dev='edm-ui-click-local'
export topic2='edm-ui-pageload'
export topic2Dev='edm-ui-pageload-local'

heroku kafka:topics:create $topic1 -a $1
heroku kafka:topics:create $topic1Dev -a $1
heroku kafka:topics:create $topic2 -a $1
heroku kafka:topics:create $topic2Dev -a $1

export cg1='edm-consumer-group-1'
export cg1Dev='edm-consumer-group-1-local'
export cg2='edm-consumer-group-2'
export cg2Dev='edm-consumer-group-2-local'

heroku kafka:consumer-groups:create $cg1 -a $1
heroku kafka:consumer-groups:create $cg1Dev -a $1
heroku kafka:consumer-groups:create $cg2 -a $1
heroku kafka:consumer-groups:create $cg2Dev -a $1


# Before we proceed, make sure topics & consumer groups are created
args=("edm-ui-click" "edm-ui-pageload")
pat=$(echo ${args[@]}|tr " " "|")
end=$((SECONDS+120))
while [ $SECONDS -lt $end ]; do 
  if heroku kafka:topics -a $1 | grep -Eow "$pat"; then
      echo "Kafka Topics Ready."
      break
  fi
  echo "Waiting for Kafka Topics..."
  sleep 1
done

args2=("edm-consumer-group-1" "edm-consumer-group-2")
pat2=$(echo ${args2[@]}|tr " " "|")
end=$((SECONDS+120))
while [ $SECONDS -lt $end ]; do 
  if heroku kafka:consumer-groups -a $1 | grep -Eow "$pat2"; then
      echo "Kafka Consumer Groups Ready."
      break
  fi
  echo "Waiting for Kafka Consumer Groups..."
  sleep 1
done
