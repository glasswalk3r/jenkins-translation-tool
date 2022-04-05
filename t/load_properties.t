use warnings;
use strict;
use Test::More;
use File::Spec;
use Test::Warnings ':all';

use Jenkins::i18n qw(load_properties);
like( warning { load_properties('foobar.properties') },
    qr/foo/, 'got expected warning' );
my $sample = File::Spec->catfile( 't', 'samples', 'table_pt_BR.properties' );
my $result = load_properties($sample);
is( ref $result, 'HASH', 'result is a hash reference' );
cmp_ok(scalar(keys(%{$result})), '>', 0, 'result has some keys on it');

done_testing;

# -*- mode: perl -*-
# vi: set ft=perl :
