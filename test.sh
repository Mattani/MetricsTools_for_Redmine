#!/bin/sh -xe

PATH="/usr/local/bin:$PATH"
echo $BITNAMI_ROOT
echo $GDFONTPATH
gnuplot --version
DOCPATH=/var/www/html/statistics
APIKEY=***YOUR_API_KEY***
URL=***YOUR_URL_TO_REST_QUERY***

./test.pl --apikey=$APIKEY --url=$URL --queryname="Sample" --opath=$DOCPATH
gnuplot -e "infile='$DOCPATH/Sample_ClosedInEachMonth.txt';outfile='$DOCPATH/images/Sample_ClosedInEachMonth.png'" $WORKSPACE/gp/ClosedInEachMonth.gp 

