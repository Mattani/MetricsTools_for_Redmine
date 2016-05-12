#!/usr/bin/perl

use FindBin;
use lib "$FindBin::Bin/lib";
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);

use RestIssues;

my %opts;
GetOptions(\%opts, qw( apikey=s url=s queryname=s opath=s));

my $apikey=$opts{apikey};
my $url=$opts{url};
my $queryname=$opts{queryname};
my $opath=$opts{opath};

print $apikey,"\n";
print $url,"\n";

my $issues = RestIssues->new(Url =>$url, Apikey => $apikey, Verbose => 1);
&UntouchedDays::setTargetTracker(['バグ']);
&UntouchedDays::setExcludeStatus(['破棄','終了']);
&CountEachWeek::setStartDate('2016-4-2');
&CountEachWeek::setOpenStatus(['新規','進行中','解決','フィードバック']);

$issues->addAggregateProc(\&ClosedInEachMonth::aggregate);
$issues->addAggregateProc(\&UntouchedDays::aggregate);
$issues->addAggregateProc(\&CountEachWeek::aggregate);
$issues->processAllIssues();

&ClosedInEachMonth::putResult($opath,$queryname);
&UntouchedDays::putResult($opath,$queryname);
&CountEachWeek::putResult($opath,$queryname);

