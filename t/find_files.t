use warnings;
use strict;
use Test::More tests => 9;
use File::Spec;
use Test::Exception 0.43;

use Jenkins::i18n qw(find_files);

my $results;
dies_ok { $results = find_files() } 'dies without directory parameter';
like $@, qr/invalid\sdirectory\sparameter/, 'get the expected error message';
dies_ok { $results = find_files( [] ) } 'dies without directory parameter';
like $@, qr/reference/, 'get the expected error message';
dies_ok { $results = find_files('/tmp/foobar') }
'dies with non-existing directory parameter';
like $@, qr/must\sexist/, 'get the expected error message';
my $samples_dir = File::Spec->catdir( 't', 'samples' );
note("Using $samples_dir as samples source");
my $known_langs = Set::Tiny->new(qw(pt_BR));
ok( $results = find_files( $samples_dir, $known_langs ),
    'find_files works' );
isa_ok( $results, 'Jenkins::i18n::FindResults', 'find_files returns an array reference' );

my $expected_ref = [
    File::Spec->catfile(qw(t samples Messages.properties)),
    File::Spec->catfile(qw(t samples config.jelly)),
    File::Spec->catfile(qw(t samples message.jelly)),
    File::Spec->catfile(qw(t samples mixed buildCaption.properties)),
    File::Spec->catfile(qw(t samples mixed buildCaption.jelly)),
];

is_deeply( $results->{files}, $expected_ref,
    'find_files returns the expected files' )
    or diag( explain($results) );

# -*- mode: perl -*-
# vi: set ft=perl :
