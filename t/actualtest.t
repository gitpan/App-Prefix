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
    [ "bin/prefix -host            t/one_word.dat", '^.* sanguine$' ], # test -host
    [ "bin/prefix -host -suffix    t/one_word.dat", '^sanguine .*' ],  # test -suffix

    [ "bin/prefix -version",                        '^prefix [0-9.]+$' ],   # test -version

    [ "bin/prefix -text=A          t/one_word.dat", '^A sanguine$' ],
    [ "bin/prefix -text=A -suffix  t/one_word.dat", '^sanguine A$' ],   # test -text=A
    [ "bin/prefix -text=A -no-space t/one_word.dat", '^Asanguine$' ],   # test -no-space
    [ "bin/prefix -text=A -quote   t/one_word.dat", '^A \'sanguine\'$' ],   # test -quote
);
for my $t (@tests) {
    my ($cmd, $regex) = @$t;
    my ($line) = btick( $cmd );
    cmp_ok( $line, '=~', $regex, "output of $cmd =~ '$regex'" ); 
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

