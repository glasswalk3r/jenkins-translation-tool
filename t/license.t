use warnings;
use strict;
use Test::More tests => 6;
use File::Spec;
use Test::TempDir::Tiny 0.018;
use Test::Exception 0.43;

use Jenkins::i18n::License;

my $license = Jenkins::i18n::License->new;
my $result  = $license->read_license;
is( ref($result), 'ARRAY', 'read_license() returns an array reference' );
is( scalar( @{$result} ),
    22, 'read_license() array reference has the expected length' );
my $year = $license->{current_year};
is(
    $result->[4],
    " Copyright (c) $year- Jenkins contributors.\n",
    'additional copyright has the expected year'
);
dies_ok { $license->print_license }
'print_license() dies without the file parameter';
like $@, qr/file\sparameter/, 'got the expected error message';
my $temp_dir  = tempdir();
my $file_path = File::Spec->catfile( ( $temp_dir, 'one', 'two', 'three' ),
    'foobar.properties' );
my $data_ref = [ 'some', 'text', 'to', 'print' ];
ok( $license->print_license($file_path),
    'print_license() executes properly with a valid parameter' );
