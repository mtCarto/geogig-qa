# !/bin/sh
export PATH=$PATH:/home/ec2-user/apache-jmeter-3.1/bin
today=`date +%Y_%m_%d`
cd /home/ec2-user/jmeter_tests
#use input arg to separate baseline and indexed results
jmeter -n -t counties.jmx -l results/$1_counties_testresults.jtl
jmeter -n -t NYstreets.jmx -l results/$1_nystreets_testresults.jtl
jmeter -n -t NYbuildings.jmx -l results/$1_nybuildings_testresults.jtl

dirname="$today"_results
cd results && mkdir $dirname
mv *_testresults.jtl $dirname
mv *_graph $dirname
mv *_summary $dirname