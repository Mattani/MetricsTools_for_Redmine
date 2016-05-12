package CountEachWeek;

use DateTime;
use DateTime::Format::Strptime;
use Object::Simple -base;

my $StartDate;
my @Cnt;
my @OpenStatus=();
my @OpenIssueCnt;

sub setStartDate{
    my $day_str = shift;
    my $strp = DateTime::Format::Strptime->new( pattern => '%Y-%m-%d'); # 文字列 のパターンを指定
    $StartDate = $strp->parse_datetime($day_str);
}

sub setOpenStatus{
    my $ref_array = shift;
    @OpenStatus = @{$ref_array};
}

sub aggregate{
    my $issue = shift; 

    return if $issue->{start_date} eq "";
    die "StartDateが設定されていません\n" unless defined($StartDate);

    my $strp = DateTime::Format::Strptime->new( pattern => '%Y-%m-%d'); # 文字列 のパターンを指定
    my $start_date = $strp->parse_datetime($issue->{start_date});
    return if ($start_date < $StartDate );

    my $ddays = $start_date->delta_days($StartDate);

    my $week = int($ddays->in_units('days')/7);
    if ( !exists $Cnt[$week] ) {
        $Cnt[$week]=0;
        $OpenIssueCnt[$week]=0
    }
    $Cnt[$week]++;
    if (grep {$_ eq $issue->{status}->{name}} @OpenStatus) {
        $OpenIssueCnt[$week]++;
    }
}

sub putResult {
    my $opath = shift;
    my $queryname = shift;
    my $outfile = $opath ."/" . $queryname ."_". __PACKAGE__ . ".txt";
    my $sum = 0;
    open ( FILE, ">$outfile" ) || die "Cannot open(create) file: $outfile"; 
    print FILE "# week\t\t未完了\t件数\t累積件数\n";
    my $date = $StartDate->clone();
    foreach my $week (0 .. $#Cnt ){
        $sum = $sum + $Cnt[$week];
        #print FILE $date->ymd,"\t",$OpenIssueCnt[$week],"\t",$Cnt[$week],"\t",$sum,"\n";
        printf( FILE "%s\t%d\t%d\t%d\n", $date->ymd,$OpenIssueCnt[$week],$Cnt[$week],$sum);
        $date = $date->add(days=>7);
    }
    close (FILE); 
}

1;


