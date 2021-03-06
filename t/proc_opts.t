use warnings;
use strict;
use Test::More tests => 29;
use Test::Exception;
use Test::Warnings qw(:all);
use File::Spec;

use Jenkins::i18n::ProcOpts;

my $class = 'Jenkins::i18n::ProcOpts';
can_ok( $class,
    qw(new inc use_counter get_counter is_remove is_add is_debug get_language is_to_search search_term)
);
dies_ok { Jenkins::i18n::ProcOpts->new( 'foo', 'bar', 1, 1, 1, 0, 'foobar' ) }
'dies with both removing and adding is configured';
like( $@, qr/excluding\soperations/, 'got the expected error message' );
dies_ok { Jenkins::i18n::ProcOpts->new } 'dies with missing parameters';
like( $@, qr/must\sreceive/, 'got the expected error message' );
my $source = File::Spec->catdir( File::Spec->rootdir(), 'foo' );
my $target = File::Spec->catdir( File::Spec->rootdir(), 'bar' );
my $instance
    = Jenkins::i18n::ProcOpts->new( $source, $target, 1, 0, 0, 0, 'pt_BR' );
isa_ok( $instance, $class );
my @attribs = sort( keys( %{$instance} ) );
is_deeply(
    \@attribs,
    [
        'counter',    'ext_sep',   'has_search', 'is_add',
        'is_debug',   'is_remove', 'language',   'source_dir',
        'target_dir', 'use_counter'
    ],
    'instance has the expected attributes'
);
is( $instance->get_counter, 0, 'got the expected files counter' );
ok( $instance->inc, 'can invoke inc' );
is( $instance->get_counter, 1, 'got the expected files counter' );
ok( $instance->use_counter, 'file counter is in use' );
is( $instance->is_remove,    0,       'file removal is disabled' );
is( $instance->is_add,       0,       'file addition is disabled' );
is( $instance->is_debug,     0,       'debugging is disabled' );
is( $instance->get_language, 'pt_BR', 'get_language() works as expected' );
is( $instance->get_source,   $source, 'get_source() works as expected' );
is( $instance->get_target,   $target, 'get_target() works as expected' );
is( $instance->is_to_search, 0,       'is_to_search() works as expected' );

foreach my $new_target ( ( $source, $target ) ) {
    note("Using $new_target as target directory, source as $source");
    my $instance2
        = Jenkins::i18n::ProcOpts->new( $source, $new_target, 1, 0, 0, 0,
        'pt_BR' );
    my $file_in = File::Spec->catfile( $source, 'message.properties' );
    my $file_out
        = File::Spec->catfile( $new_target, 'message_pt_BR.properties' );
    my %expected_files = (
        $file_in => [ $file_out, $file_in ],
        File::Spec->catfile( $source, 'message.jelly' ) =>
            [ $file_out, $file_in ],
    );

    foreach my $file_path ( keys(%expected_files) ) {
        my @files = $instance2->define_files($file_path);
        is_deeply( \@files, $expected_files{$file_path},
'got the expected results from define_files() with a given file type'
        ) or diag( explain( \@files ) );
    }
}

note('Testing with long paths');
$source = File::Spec->catdir( File::Spec->rootdir(), 'home', 'foobar',
    'Projects', 'jenkins' );
my $relative_path = File::Spec->catdir(
    'jenkins',   'cli',    'src', 'main',
    'resources', 'hudson', 'cli', 'client'
);
my $input
    = File::Spec->catfile( $source, $relative_path, 'Messages.properties' );
$instance
    = Jenkins::i18n::ProcOpts->new( $source, $source, 1, 0, 0, 0, 'pt_BR' );
my @files = $instance->define_files($input);
is_deeply(
    \@files,
    [
        File::Spec->catfile(
            $source, $relative_path, 'Messages_pt_BR.properties'
        ),
        $input
    ],
    'got the expected results from define_files with source = target'
) or diag( explain(@files) );

$target = File::Spec->catdir( File::Spec->rootdir(), 'home', 'barfoo',
    'Projects', 'jenkins' );
$instance
    = Jenkins::i18n::ProcOpts->new( $source, $target, 1, 0, 0, 0, 'pt_BR' );
@files = $instance->define_files($input);
is_deeply(
    \@files,
    [
        File::Spec->catfile(
            $target, $relative_path, 'Messages_pt_BR.properties'
        ),
        $input
    ],
    'got the expected results from define_files source != target'
);

note('New instance with file counter disabled and a search term');
$instance
    = Jenkins::i18n::ProcOpts->new( 'foo', 'bar', 0, 0, 0, 0, 'foobar',
    '[Bb]uild' );
my $result;
like( warning { $result = $instance->inc },
    qr/^Useless/, 'got expected warning' );
is( $result,                 0, 'inc returns false' );
is( $instance->is_to_search, 1, 'is_to_search() works as expected' );
is( ref( $instance->search_term ),
    'Regexp', 'search_term() returns a regular expression' );

# -*- mode: perl -*-
# vi: set ft=perl :
