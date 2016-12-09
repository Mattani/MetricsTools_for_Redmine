package UntouchedDays;

use DateTime;
use DateTime::Format::Strptime;
use Object::Simple -base;

my @UntouchedDaysCnt;
my %UntouchedDaysHash;
my @TargetTracker;
my @ExcludeStatus;
my $Max=0;

sub setTargetTracker{
    my $ref_array = shift;
    @TargetTracker = @{$ref_array};
}

sub setExcludeStatus{
    my $ref_array = shift;
    @ExcludeStatus = @{$ref_array};
}

sub aggregate{
    my $issue = shift; 
    if (grep {$_ eq $issue->{status}->{name}} @ExcludeStatus) {
        return;
    }
    my $strp = DateTime::Format::Strptime->new( pattern => '%Y-%m-%dT%H:%M:%SZ'); # 文字列 のパターンを指定
    my $updated_on = $strp->parse_datetime($issue->{updated_on});
    my $today = DateTime->today();
    my $dur = $updated_on->delta_days($today);
    my $durdays = $dur->in_units('days');
    if ( defined($UntouchedDaysHash{$issue->{tracker}->{name}}[$durdays]) ){ 
        $UntouchedDaysHash{$issue->{tracker}->{name}}[$durdays] ++;
    }else{
        $UntouchedDaysHash{$issue->{tracker}->{name}}[$durdays] = 1;
    }
    if ( $Max < $durdays ){ $Max = $durdays; }
}

sub putResult {
    my $opath = shift;
    my $queryname = shift;
    my $outfile = $opath ."/" . $queryname ."_". __PACKAGE__ . ".txt";
    my $tracker;

    open ( FILE, ">$outfile" ) || die "Cannot open(create) file: $outfile"; 
    print FILE "放置日数\t";
    foreach $tracker( @TargetTracker)
        { print FILE $tracker,"\t"; } 
    print FILE "\n";
    
    for ( my $i = 0; $i <= $Max ; $i++){
        print FILE $i,"\t\t";
        foreach $tracker (@TargetTracker){
            if (defined($UntouchedDaysHash{$tracker}[$i])){
                print FILE $UntouchedDaysHash{$tracker}[$i],"\t";
            } else {
                print FILE "0\t";
            }
        }
        print FILE "\n";
    }
    close (FILE); 
}


1;
