#!/bin/bash
#set pass in env for psql
export PGPASSWORD="Open4Good"
#pass rds endpoint as argument
export HOST="$1"
export REPO="postgresql://$HOST:5432/geogig_repos/counties?user=postgres&password=$PGPASSWORD"
export PATH="$PATH:/home/ec2-user/geogig/src/cli-app/target/geogig/bin"

#create workspace for repos
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<workspace><name>gig</name></workspace>" http://localhost:8080/geoserver/rest/workspaces

#init repo in geoserver
curl -X PUT -H "Content-Type: application/json" -d '{
        "dbHost": "$HOST", 
        "dbPort": "5432",
        "dbName": "geogig_repos",
        "dbSchema": "public",
        "dbUser": "postgres",
        "dbPassword": "$PGPASSWORD",
        "authorName": "geogig",
        "authorEmail": "geogig@geogig.org"
}' "http://localhost:8080/geoserver/geogig/repos/counties/init"
#add repo as datastore
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<dataStore><name>counties_store</name><connectionParameters><entry key=\"geogig_repository\">geoserver://counties</entry></connectionParameters></dataStore>" http://localhost:8080/geoserver/rest/workspaces/gig/datastores

#use cli to add data to that repo
geogig --repo $REPO config --global user.name tester
geogig --repo $REPO config --global user.email tester@test.org
geogig --repo $REPO pg import -t "us_histcounties_gen001_no_index" --host $HOST --database test_data --user postgres --password $PGPASSWORD
geogig --repo $REPO add
geogig --repo $REPO commit -m "initial import"
