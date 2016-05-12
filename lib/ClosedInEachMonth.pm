package ClosedInEachMonth;

use DateTime;
use DateTime::Format::Strptime;
use Object::Simple -base;

my %total_days;
my %close_count;
my %open_count;

sub aggregate{
    my $issue = shift; 


#use Data::Dumper;print Dumper $issue;

    return if $issue->{start_date} eq "";
    my $strp = DateTime::Format::Strptime->new( pattern => '%Y-%m-%d'); # 文字列 のパターンを指定
    my $start_date = $strp->parse_datetime($issue->{start_date});
    my $key_ym = $start_date->strftime("%Y-%m");
    if ( !exists $total_days{$key_ym} ) {
        $total_days{$key_ym}=0;
        $close_count{$key_ym}=0;
        $open_count{$key_ym}=0;
     }
    if ( $issue->{status}->{name} eq "終了" ){
        my $closed_on = $strp->parse_datetime($issue->{closed_on});
        my $ddays = $closed_on->delta_days($start_date);
        $total_days{$key_ym} = $total_days{$key_ym} + $ddays->delta_days;
        $close_count{$key_ym} ++;
    } elsif ( $issue->{status}->{name} eq "破棄" ){
        ;
    } else {
        $open_count{$key_ym} ++;
    }
}

sub putResult {
    my $opath = shift;
    my $queryname = shift;
    my $outfile = $opath ."/" . $queryname ."_". __PACKAGE__ . ".txt";
    open ( FILE, ">$outfile" ) || die "Cannot open(create) file: $outfile"; 
    print FILE "# 年月	未完了件数 完了件数  完了日数の和\n";
    foreach my $key ( sort keys %total_days ){
        print FILE $key,"\t\t",$open_count{$key},"\t\t",$close_count{$key},"\t\t", $total_days{$key},"\n";
    }
    close (FILE); 
}

1;


