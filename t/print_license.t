use warnings;
use strict;
use Test::More tests => 7;
use File::Spec;
use Test::TempDir::Tiny 0.018;
use Test::Exception 0.43;

use Jenkins::i18n qw(print_license);

dies_ok { print_license } 'dies without the file parameter';
like $@, qr/file\sparameter/, 'got the expected error message';

dies_ok { print_license('/foobar/yayda.properties') }
'dies without the data reference parameter';
like $@, qr/data\sreference\sparameter/, 'got the expected error message';

dies_ok { print_license( '/foobar/yada.properties', 'foo' ) }
'dies with invalid reference type for data reference parameter';
like $@, qr/array/, 'got the expected error message';

my $temp_dir  = tempdir();
my $file_path = File::Spec->catfile( ( $temp_dir, 'one', 'two', 'three' ),
    'foobar.properties' );
my $data_ref = [ 'some', 'text', 'to', 'print' ];
ok(
    print_license( $file_path, $data_ref ),
    'executes properly with all valid parameters'
);

