export PGPASSWORD="Open4Good"
# #pass rds endpoint as argument
export HOST="$1"
export PGREPO="postgresql://$HOST:5432/geogig_repos/counties?user=postgres&password=$PGPASSWORD"
export PGREPO_nys="postgresql://$HOST:5432/geogig_repos/NY_streets?user=postgres&password=$PGPASSWORD"
export PGREPO_nyb="postgresql://$HOST:5432/geogig_repos/NY_buildings?user=postgres&password=$PGPASSWORD"
export PATH="$PATH:/home/ec2-user/geogig/src/cli-app/target/geogig/bin"

#probably need to index an attribute as well
geogig --repo $PGREPO index create --tree us_histcounties_gen001_no_index 
geogig --repo $PGREPO_nys index create --tree NYstreets_lion
geogig --repo $PGREPO_nyb index create --tree building_0117

