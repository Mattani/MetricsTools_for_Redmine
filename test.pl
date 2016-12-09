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

# 放置日数の集計で、対象とするトラッカー(2つ以上を指定する場合は、gp/UntouchedDays.gp を
# 変更する必要あり。)
&UntouchedDays::setTargetTracker(['バグ','仕様変更']);
# 放置日数の集計で、対象外とするステータス
&UntouchedDays::setExcludeStatus(['却下','破棄','終了']);
# 信頼度成長曲線の起点日
&CountEachWeek::setStartDate('2016-11-07');
# 信頼度成長曲線の終点日(未定義の場合は実行日になる)
#&CountEachWeek::setEndDate('2016-12-05');
# 信頼度成長曲線で、Open 状態と見なすステータス
&CountEachWeek::setOpenStatus(['新規','進行中','解決','フィードバック']);

$issues->addAggregateProc(\&ClosedInEachMonth::aggregate);
$issues->addAggregateProc(\&UntouchedDays::aggregate);
$issues->addAggregateProc(\&CountEachWeek::aggregate);
$issues->processAllIssues();

&ClosedInEachMonth::putResult($opath,$queryname);
&UntouchedDays::putResult($opath,$queryname);
&CountEachWeek::putResult($opath,$queryname);

