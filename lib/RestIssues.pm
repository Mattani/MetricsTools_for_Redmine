package RestIssues;
# redmine REST APIでIssueを取得するクラス
#
#######################################################

use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use Object::Simple -base;
use ClosedInEachMonth;
use UntouchedDays;
use CountEachWeek;

has Url => "";
has Apikey => "";
has Verbose => 0;
my @AggregateProcs = ();

sub new {
    my $class = shift;
    my $self = {
       @_,
    };
    if ( $self->{Verbose} == 1 ){
        @AggregateProcs = (\&defaultIssueFunc);
    }
    bless $self;
}

sub processAllIssues{		# 初期化時に与えられたURLとAPIKEYでREST APIにより全Issueを処理
    my $self = shift;

    my $limit=25;
    my $current_page=1; 
    my $pages=0;
    my $ua = LWP::UserAgent->new;
    my $nexturl = $self->Url;

    $self->Url($self->Url . "&limit=$limit");
    while($pages == 0 || $pages >= $current_page){		# 最後のページまでループ
        my $req = HTTP::Request->new(GET => $nexturl);
        $req->header("Content-Type" => "application/json");
        $req->header("X-Redmine-API-Key" => $self->Apikey );
        my $res = $ua->request($req);				# REST APIによりRedmineからデータを取得
        if ($res->is_success) {					# 成功した場合
            my $json = JSON->new->decode($res->content);
#            use Data::Dumper; print Dumper $json;		# debug用
            my $tmp=$json->{total_count}/$limit;
            $pages=($tmp==int($tmp)?$tmp:int($tmp+1));		# 最大のページ数を計算
            my $issues = $json->{issues};
            foreach my $issue( @$issues ){			# 取得したチケットについてループ
                processIssue($issue);				# processIssueメソッドを呼び出す
            }
            $current_page++;					# 現在ページをカウントアップ
            $nexturl=$self->Url."&page=".$current_page;		# 次のページのURLを作成する
        }
        else {							# 失敗した場合
            print $res->status_line, "\n";
        }
     }
}

sub processIssue{
    my $issue = shift;
    my $proc;
    foreach $proc ( @AggregateProcs ){
        $proc->($issue);
    }
}

sub addAggregateProc{
    my $class = shift;
    my $ref_func = shift;
    if ( ref($ref_func) eq "CODE" ){
        push( @AggregateProcs, $ref_func );
    } else {
        die "argument of addAggregateFunc should be reference to CODE",ref($ref_func),"\n";
    }
}

sub defaultIssueFunc{						# デフォルトのチケット処理メソッド
    my $issue = shift;
    print $issue->{id},"\t",$issue->{status}->{name},"\t",$issue->{subject},"\n";
}

1;
