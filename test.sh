#!/bin/sh -xe

PATH="/usr/local/bin:$PATH"
WORKSPACE=.
echo $BITNAMI_ROOT
echo $GDFONTPATH
gnuplot --version
DOCPATH=/var/www/html/statistics
APIKEY=***YOUR_API_KEY***
URL=http://YOUR.HOSTNAME.COM/YOU_REDMINE/projects/YOUR_PROJECT/issues.json?status_id='*'

./test.pl --apikey=$APIKEY --url=$URL --queryname="Sample" --opath=$DOCPATH

gnuplot -e "infile='$DOCPATH/Sample_ClosedInEachMonth.txt';outfile='$DOCPATH/images/Sample_ClosedInEachMonth.png'" $WORKSPACE/gp/ClosedInEachMonth.gp 

gnuplot -e "infile='$DOCPATH/Sample_UntouchedDays.txt';outfile='$DOCPATH/images/Sample_UntouchedDays.png'" $WORKSPACE/gp/UntouchedDays.gp 

gnuplot -e "infile='$DOCPATH/Sample_CountEachWeek.txt';outfile='$DOCPATH/images/Sample_CountEachWeek.png'" $WORKSPACE/gp/Gompertz.gp 

