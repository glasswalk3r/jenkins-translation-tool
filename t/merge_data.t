use warnings;
use strict;
use Test::More;
use Test::Exception;

use Jenkins::i18n qw(merge_data);

my $expected_error = 'Got the expected exception message';

dies_ok { merge_data() } 'Dies with missing Jelly keys parameter';
like( $@, qr/Jelly\skeys\sis\srequired/, $expected_error );

dies_ok { merge_data(1) } 'Dies with invalid Jelly keys parameter';
like( $@, qr/Jelly\stype/, $expected_error );

dies_ok { merge_data( {} ) } 'Dies with missing Properties keys parameter';
like( $@, qr/Properties\skeys\sis\srequired/, $expected_error );

dies_ok { merge_data( {}, 2 ) } 'Dies with invalid Jelly keys parameter';
like( $@, qr/Properties\stype/, $expected_error );

dies_ok { merge_data( {}, {} ) }
'Dies with both Jelly and Properties referencing empty hashes';
like( $@, qr/at\sleast\sa\ssingle\skey/, $expected_error );

my @fixtures = (
    [
        'Best scenario',
        { user => 1, shutdown => 1, warn => 1 },
        {
            user     => 'Hello user!',
            shutdown => 'The system is goind down!',
            warn     => 'A serious warning'
        },
        {
            user     => 'Hello user!',
            shutdown => 'The system is goind down!',
            warn     => 'A serious warning'
        },
    ],
    [
        'No Jelly',
        {},
        {
            user     => 'Hello user!',
            shutdown => 'The system is goind down!',
            warn     => 'A serious warning'
        },
        {
            user     => 'Hello user!',
            shutdown => 'The system is goind down!',
            warn     => 'A serious warning'
        },
    ],
    [
        'Partial translation',
        {
            user                  => 1,
            'A\ serious\ warning' => 1,
            shutdown              => 1
        },
        {
            user     => 'Hello user!',
            shutdown => 'The system is going down!'
        },
        {
            user                  => 'Hello user!',
            shutdown              => 'The system is going down!',
            'A\ serious\ warning' => 'A\ serious\ warning',
        },
    ],
    [
        'Only Jelly',
        {
            'Hello\ User'                  => 1,
            'A\ serious\ warning'          => 1,
            'The\ system\ is\ going\ down' => 1
        },
        {},
        {
            'Hello\ User'                  => 'Hello\ User',
            'A\ serious\ warning'          => 'A\ serious\ warning',
            'The\ system\ is\ going\ down' => 'The\ system\ is\ going\ down'
        },
    ]
);

foreach my $test_case (@fixtures) {
    note( $test_case->[0] );
    my $current_ref = merge_data( $test_case->[1], $test_case->[2] );
    is( ref($current_ref), 'HASH', 'merge result is a hash reference' );
    is_deeply(
        $current_ref,
        $test_case->[3],
        (
                  'Have the expected Properties for "'
                . $test_case->[0]
                . '" test case'
        )
    ) or diag( explain($current_ref) );
}

done_testing;
