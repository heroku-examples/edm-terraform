#!/bin/bash


# echo "Checking connection to Postgres database"
# database_fails=1
# while ! psql $DATABASE_URL --quiet --output /dev/null -c "SELECT 1"
# do
#   if [ "$database_fails" -eq "31" ]; then
#     echo "$(date -u) Connection to Postgres database could not be established within 15-minutes"
#     exit 2
#   else
#     echo "$(date -u) Attempt ${database_fails}/30: Postgres database not yet available"
#     sleep 30
#     database_fails=$[$database_fails +1]
#   fi
# done

if [ -z "$1" ]
then
  echo "ERROR: missing appname argument"
  exit 2
fi

heroku pg:wait --app $1

# use psql with DATABASE_URL
heroku pg:psql -f database-init.sql --app $1