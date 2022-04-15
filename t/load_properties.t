use warnings;
use strict;
use Test::More;
use File::Spec;
use Test::Warnings ':all';

use Jenkins::i18n qw(load_properties);
like( warning { load_properties('foobar.properties') },
    qr/foo/, 'got expected warning' );
my $sample = File::Spec->catfile( 't', 'samples', 'table_pt_BR.properties' );
note("Using sample $sample");
my $result = load_properties($sample);
is( ref $result, 'HASH', 'result is a hash reference' );
cmp_ok( scalar( keys( %{$result} ) ), '>', 0, 'result has some keys on it' );

#is_deeply( $result, {}, 'got the expected content' )
#    or diag( explain($result) );
ok( exists( $result->{'No\ updates'} ), 'can find expected complex key' );

done_testing;

# -*- mode: perl -*-
# vi: set ft=perl :
