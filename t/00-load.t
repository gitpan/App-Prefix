#!perl -T

use Test::More tests => 2;

BEGIN { 
    use_ok( 'App::Prefix' ); 
    ok( -e "bin/prefix", "bin/prefix exists" );
    #ok( -x "bin/prefix", "bin/prefix is executable" );
}

#diag( "Testing App::Prefix $App::Prefix::VERSION, Perl $], $^X" );
1;
