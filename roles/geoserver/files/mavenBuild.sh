export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
export M2=/opt/apache-maven/bin
export PATH=$PATH:$M2

echo "Building GeoGig"
cd /home/ec2-user/geogig/src/parent && mvn clean install -DskipTests

echo "Building GeoServer"
cd /home/ec2-user/geoserver/src && mvn clean install -DskipTests

echo "Building War"
cd /home/ec2-user/geoserver/src/web/app && mvn install

echo "Done"
