#!perl -T

use strict;
use warnings;
use Test::More tests => 4;
use App::Prefix;

my $version = $App::Prefix::VERSION;
(my $version_regex = $version) =~ s{\.}{\\.};
my $date = scalar(localtime(time()));
#my $year = substr($date, -4);
my $year = 2013;

in_file_ok( "dist.ini",              dist_ini_version => 'version\s*=.*' . $version_regex);
in_file_ok( "Changes",               version          => "^$version_regex" );

in_file_ok( "bin/prefix",            copyright        => "Copyright.*$year" );
in_file_ok( "lib/App/Prefix.pm",     code_version     => 'VERSION\s*=.*' . $version_regex, 
                                     pod_version      => 'Version\s+'    . $version_regex );

sub in_file_ok {
    my ($filename, %regex) = @_;
    open( my $fh, '<', $filename )
        or die "couldn't open $filename for reading: $!";

    my %has;

    while (my $line = <$fh>) {
        while (my ($desc, $regex) = each %regex) {
            if ($line =~ $regex) {
                push @{$has{$desc}||=[]}, $.;
            }
        }
    }

    if (! %has) {
        fail("$filename doesn't match regex in (" . join(", ", values %regex) . ")" );
    } else {
        #diag "$_ appears on lines @{$has{$_}}" for keys %has;
        my $desc = join(", ", keys %has);
        pass("$filename matches regex(es) ($desc)" );
    }
}


