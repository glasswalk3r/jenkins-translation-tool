use warnings;
use strict;
use Test::More tests => 6;
use File::Spec;

use Jenkins::i18n qw(load_jelly);

my ( $sample, $result );

$sample = File::Spec->catfile( 't', 'samples', 'message.jelly' );
note("Using $sample");
$result = load_jelly($sample);
is( ref $result, 'HASH', 'result is a hash reference' );
is_deeply( $result, { 'blurb' => 1 }, 'result has the expected content' )
    or diag( explain($result) );

$sample = File::Spec->catfile( 't', 'samples', 'config.jelly' );
note("Using sample $sample for complex keys");
$result = load_jelly($sample);
is( ref $result, 'HASH', 'result is a hash reference' );
is_deeply(
    $result,
    {
        'Disabled\\ jobs\\ only' => 1,
        'Enabled\\ jobs\\ only'  => 1,
        'Status\\ Filter'        => 1
    },
    'result has the expected content'
) or diag( explain($result) );

$sample = File::Spec->catfile( 't', 'samples', 'signup.jelly' );
note("Using sample $sample for even more complex keys");
$result = load_jelly($sample);
is( ref $result, 'HASH', 'result is a hash reference' );
is_deeply(
    $result,
    {
'A\\ strong\\ password\\ is\\ a\\ long\\ password\\ that\'s\\ unique\\ for\\ every\\ site.\\ Try\\ using\\ a\\ phrase\\ with\\ 5-6\\ words\\ for\\ the\\ best\\ security.'
            => 1,
        'Create\\ account'                                   => 1,
        'Create\\ an\\ account!'                             => 1,
        'Create\\ an\\ account!\\ [Jenkins]'                 => 1,
        'Email'                                              => 1,
        'Enter\\ text\\ as\\ shown'                          => 1,
        'Full\\ name'                                        => 1,
        'If\\ you\\ already\\ have\\ a\\ Jenkins\\ account,' => 1,
        'Password'                                           => 1,
        'Show'                                               => 1,
        'Strength'                                           => 1,
        'Username'                                           => 1,
        'please\\ sign\\ in.'                                => 1,
        'Strong'                                             => 1,
        'Moderate'                                           => 1,
        'Weak'                                               => 1,
        'Poor'                                               => 1,
        'Uninstall'                                          => 1,
        'Advanced\\ Settings'                                => 1,
        'Plugin\\ Manager'                                   => 1
    },
    'result has the expected content'
) or diag( explain($result) );

# -*- mode: perl -*-
# vi: set ft=perl :
