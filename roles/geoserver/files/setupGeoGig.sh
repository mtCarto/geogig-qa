#!/bin/bash

#set pass in env for psql
export PGPASSWORD="Open4Good"
#pass rds endpoint as argument
export HOST="$1"
export PGREPO="postgresql://$HOST:5432/geogig_repos/counties?user=postgres&password=$PGPASSWORD"
export PGREPO_nys="postgresql://$HOST:5432/geogig_repos/NY_streets?user=postgres&password=$PGPASSWORD"
export PGREPO_nyb="postgresql://$HOST:5432/geogig_repos/NY_buildings?user=postgres&password=$PGPASSWORD"
export PGREPO_nybike="postgresql://$HOST:5432/geogig_repos/NY_bikepaths?user=postgres&password=$PGPASSWORD"
export PATH="$PATH:/home/ec2-user/geogig/src/cli-app/target/geogig/bin"

#create workspace for repos
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<workspace><name>gig</name></workspace>" http://localhost:8080/geoserver/rest/workspaces

#init repo in geoserver, escape quotes so Env_Vars are correct
curl -X PUT -H "Content-Type: application/json" -d "{
        \"dbHost\": \"$HOST\", 
        \"dbPort\": \"5432\",
        \"dbName\": \"geogig_repos\",
        \"dbSchema\": \"public\",
        \"dbUser\": \"postgres\",
        \"dbPassword\": \"$PGPASSWORD\",
        \"authorName\": \"geogig\",
        \"authorEmail\": \"geogig@geogig.org\"
}" "http://localhost:8080/geoserver/geogig/repos/counties/init"

#add repo as datastore
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<dataStore><name>counties_store</name><connectionParameters><entry key=\"geogig_repository\">geoserver://counties</entry></connectionParameters></dataStore>" http://localhost:8080/geoserver/rest/workspaces/gig/datastores

#use cli to add data to that repo
geogig --repo $PGREPO config --global user.name tester
geogig --repo $PGREPO config --global user.email tester@test.org
geogig --repo $PGREPO pg import -t "us_histcounties_gen001_no_index" --host $HOST --database test_data --user postgres --password $PGPASSWORD
geogig --repo $PGREPO add
geogig --repo $PGREPO commit -m "initial import"

#publish the layer in GS
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<featureType><name>us_histcounties_gen001_no_index</name></featureType>" http://localhost:8080/geoserver/rest/workspaces/gig/datastores/counties_store/featuretypes

# something up with this layer, doesn't display now
# curl -v -u admin:geoserver -XPUT -H "Content-type: text/xml" -T /home/ec2-user/us_histcounties_gen001_no_index.xml  http://localhost:8080/geoserver/rest/workspaces/gig/datastores/counties_store/featuretypes/us_histcounties_gen001_no_index.xml

#########ny streets data
curl -X PUT -H "Content-Type: application/json" -d "{
        \"dbHost\": \"$HOST\", 
        \"dbPort\": \"5432\",
        \"dbName\": \"geogig_repos\",
        \"dbSchema\": \"public\",
        \"dbUser\": \"postgres\",
        \"dbPassword\": \"$PGPASSWORD\",
        \"authorName\": \"geogig\",
        \"authorEmail\": \"geogig@geogig.org\"
}" "http://localhost:8080/geoserver/geogig/repos/NY_streets/init"

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<dataStore><name>NY_streets_store</name><connectionParameters><entry key=\"geogig_repository\">geoserver://NY_streets</entry></connectionParameters></dataStore>" http://localhost:8080/geoserver/rest/workspaces/gig/datastores

geogig --repo $PGREPO_nys config --global user.name tester
geogig --repo $PGREPO_nys config --global user.email tester@test.org
geogig --repo $PGREPO_nys shp import /home/ec2-user/test_data/NYstreets_lion.shp
geogig --repo $PGREPO_nys add
geogig --repo $PGREPO_nys commit -m "initial import"
#publish
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<featureType><name>NYstreets_lion</name></featureType>" http://localhost:8080/geoserver/rest/workspaces/gig/datastores/NY_streets_store/featuretypes

#######ny buildings data
curl -X PUT -H "Content-Type: application/json" -d "{
        \"dbHost\": \"$HOST\", 
        \"dbPort\": \"5432\",
        \"dbName\": \"geogig_repos\",
        \"dbSchema\": \"public\",
        \"dbUser\": \"postgres\",
        \"dbPassword\": \"$PGPASSWORD\",
        \"authorName\": \"geogig\",
        \"authorEmail\": \"geogig@geogig.org\"
}" "http://localhost:8080/geoserver/geogig/repos/NY_buildings/init"

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<dataStore><name>NY_buildings_store</name><connectionParameters><entry key=\"geogig_repository\">geoserver://NY_buildings</entry></connectionParameters></dataStore>" http://localhost:8080/geoserver/rest/workspaces/gig/datastores

geogig --repo $PGREPO_nyb config --global user.name tester
geogig --repo $PGREPO_nyb config --global user.email tester@test.org
geogig --repo $PGREPO_nyb shp import /home/ec2-user/test_data/building_0117.shp
geogig --repo $PGREPO_nyb add
geogig --repo $PGREPO_nyb commit -m "initial import"
#publish
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<featureType><name>building_0117</name></featureType>" http://localhost:8080/geoserver/rest/workspaces/gig/datastores/NY_buildings_store/featuretypes

######ny bikepaths data
curl -X PUT -H "Content-Type: application/json" -d "{
        \"dbHost\": \"$HOST\", 
        \"dbPort\": \"5432\",
        \"dbName\": \"geogig_repos\",
        \"dbSchema\": \"public\",
        \"dbUser\": \"postgres\",
        \"dbPassword\": \"$PGPASSWORD\",
        \"authorName\": \"geogig\",
        \"authorEmail\": \"geogig@geogig.org\"
}" "http://localhost:8080/geoserver/geogig/repos/NY_bikepaths/init"

curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<dataStore><name>NY_bikepath_store</name><connectionParameters><entry key=\"geogig_repository\">geoserver://NY_bikepaths</entry></connectionParameters></dataStore>" http://localhost:8080/geoserver/rest/workspaces/gig/datastores

geogig --repo $PGREPO_nybike config --global user.name tester
geogig --repo $PGREPO_nybike config --global user.email tester@test.org
geogig --repo $PGREPO_nybike shp import /home/ec2-user/test_data/bikepaths.shp
geogig --repo $PGREPO_nybike add
geogig --repo $PGREPO_nybike commit -m "initial import"
#publish
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml" -d "<featureType><name>bikepaths</name></featureType>" http://localhost:8080/geoserver/rest/workspaces/gig/datastores/NY_bikepath_store/featuretypes