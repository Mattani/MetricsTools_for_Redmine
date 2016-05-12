package UserProcObj;

use DateTime;
use DateTime::Format::Strptime;
use Object::Simple -base;

# Class variable
my $opath;
my $queryname;
my $outfile;
# other class variable should be defined in the sub-class

sub aggregate{
    my $issue = shift; 
    use Data::Dumper; print Dumper $issue;
}

sub putResult {
    $opath = shift;
    $queryname = shift;
    $outfile = $opath ."/" . $queryname ."_". __PACKAGE__ . ".txt";
}

1;


