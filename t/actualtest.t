#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
#use Test::More tests=>4;

#if ( $ENV{RELEASE_TESTING} ) {
#    plan( tests=>2 );
#} else {
#    plan( skip_all => "Author tests not required for installation, use env var RELEASE_TESTING to enable" );
#}



#unless ( $ENV{RELEASE_TESTING} ) {
#    plan( skip_all => "Author tests not required for installation" );
#}
#

my $perl = "$^X -w -Mstrict";   # warnings and strict on
my @out = btick( "$perl bin/prefix -host t/sample.dat" );
cmp_ok( scalar(@out), '==', 5, "prefix: read t/sample.dat" );
cmp_ok( $out[0], '=~', '.* OK: System operational', "line from test file looks as expected" );

my @tests = (

    [ "bin/prefix                  t/one_word.dat", 'sanguine$'],   # no option, no change
    [ "bin/prefix -host            t/one_word.dat", '.* sanguine$' ], # test -host
    [ "bin/prefix -host -suffix    t/one_word.dat", 'sanguine .*' ],  # test -suffix

    [ "bin/prefix -version",                        'prefix [0-9.]+$' ],   # test -version

    [ "bin/prefix -text=A          t/one_word.dat", 'A sanguine$' ],
    [ "bin/prefix -text=A -suffix  t/one_word.dat", 'sanguine A$' ],   # test -text=A
    [ "bin/prefix -text=A -no-space t/one_word.dat", 'Asanguine$' ],   # test -no-space
    [ "bin/prefix -text=A -quote   t/one_word.dat", 'A \'sanguine\'$' ],   # test -quote

    [ "bin/prefix -timestamp       t/one_word.dat", '[-:0-9 ]+ sanguine$'],   # 2013-10-16 23:23:35 sanguine
    [ "bin/prefix -utimestamp      t/one_word.dat", '[-:0-9. ]+ sanguine$'],   # 2013-10-16 23:23:35.12345 sanguine

    [ "bin/prefix -utimestamp      t/one_word.dat", '[-:0-9. ]+ sanguine$'],   # 2013-10-16 23:23:35 sanguine
    [ "bin/prefix -elapsed         t/one_word.dat", '[0-9.]+ \S+ elapsed sanguine$'],   

    [ "bin/prefix                  t/two_words.dat", 'cat--dog' ],      # basic test, no changes
    [ "bin/prefix -elapsed         t/two_words.dat", '([0-9.]+ \S+ elapsed (cat|dog)(--)?){2}'],   
);

for my $t (@tests) {
    my ($cmd, $regex) = @$t;
    (my $showcmd = $cmd) =~ s/  +/ /g;
    my @lines = btick( $cmd );  # no newlines
    my $line = join( "--", @lines );  
    ok( $line =~ /^$regex$/, "output of $showcmd =~ '$regex' ($line)" ); 
}
done_testing();



# like backtick, but auto-testing, and prettier
sub btick {
    my @lines = `@_`;
    if ($?) {
        warn "@_\n";
    }

    # $? : The status returned by the last pipe close, backtick(``) 
    # command or system operator. Note that this is the status 
    # word returned by the wait() system call, so the exit value 
    # of the subprocess is actually ($? >>*). $? & 255 gives 
    # which signal, if any, the process died from, and whether 
    # there was a core dump. 
    chomp(@lines);
    return @lines;
}

