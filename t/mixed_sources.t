use strict;
use warnings;
use Test::More tests => 3;

use Jenkins::i18n ( 'find_files', 'load_properties', 'load_jelly',
    'find_langs' );
use Jenkins::i18n::Stats;
use Jenkins::i18n::Warnings;
use Jenkins::i18n::ProcOpts;

my $path = 't/samples/mixed';

# TODO: this must be a temporary workaround
use Cwd;
chdir($path) or die "Cannot cd to $path: $!";
my $current_dir = getcwd;

# TODO: copied from the CLI, must be refactored to import functions instead
my $empty_regex  = qr/empty/i;
my $jelly_regex  = qr/.jelly$/;
my $hudson_regex = qr/Hudson/;
my $ignore_same  = Set::Tiny->new(
    (
        'https://www.jenkins.io/redirect/log-levels',
        'Maven',
        'Jenkins',
        'JDK',
        'Javadoc',
        'https://www.jenkins.io/redirect/fingerprint',
        'https://www.jenkins.io/redirect/search-box'
    )
);

my $all_langs = find_langs($current_dir);
my $result    = find_files( $current_dir, $all_langs );
is( $result->size, 2, 'Got the expected number of files' );
my $stats     = Jenkins::i18n::Stats->new;
my $warnings  = Jenkins::i18n::Warnings->new;
my $processor = Jenkins::i18n::ProcOpts->new(
    {
        source_dir  => $current_dir,
        target_dir  => $current_dir,
        use_counter => 0,
        is_remove   => 0,
        is_add      => 0,
        is_debug    => 0,
        lang        => 'pt_BR',
        search      => 'foobar'
    }
);

my $next_file = $result->files;

while ( my $file = $next_file->() ) {
    $stats->inc('files');
    my ( $curr_lang_file, $english_file ) = $processor->define_files($file);
    my ( $entries_ref, $lang_entries_ref, $english_entries_ref );
    if ( $file =~ $jelly_regex ) {
        $entries_ref = load_jelly($file);
        $english_entries_ref
            = load_properties( $english_file, $processor->is_debug );
    }
    else {
        $english_entries_ref = load_properties( $file, $processor->is_debug );
        $entries_ref         = $english_entries_ref;
    }

    $lang_entries_ref
        = load_properties( $curr_lang_file, $processor->is_debug );

    foreach my $entry ( keys %{$entries_ref} ) {
        $stats->inc('keys');

        # TODO: skip increasing missing if operation is to delete those
        unless (( exists( $lang_entries_ref->{$entry} ) )
            and ( defined( $lang_entries_ref->{$entry} ) ) )
        {
            $stats->inc('missing');
            $warnings->add( 'missing', $entry );
            next;
        }

        if ( $lang_entries_ref->{$entry} eq '' ) {
            unless ( $entry =~ $empty_regex ) {
                $stats->inc('empty');
                $warnings->add( 'empty', $entry );
            }
            else {
                $warnings->add( 'ignored', $entry );
            }
        }
    }

    foreach my $entry ( keys %{$lang_entries_ref} ) {
        unless ( defined $entries_ref->{$entry} ) {
            $stats->inc('unused');
            $warnings->add( 'unused', $entry );
        }
    }

    foreach my $entry ( keys %{$lang_entries_ref} ) {
        if (   $lang_entries_ref->{$entry}
            && $english_entries_ref->{$entry}
            && $lang_entries_ref->{$entry} eq $english_entries_ref->{$entry} )
        {
            unless ( $ignore_same->has( $lang_entries_ref->{$entry} ) ) {
                $stats->inc('same');
                $warnings->add( 'same', $entry );
            }
            else {
                $warnings->add( 'ignored', $entry );
            }
        }
    }

    foreach my $entry ( keys %{$lang_entries_ref} ) {
        if (   $lang_entries_ref->{$entry}
            && $lang_entries_ref->{$entry} =~ $hudson_regex )
        {
            $warnings->add( 'non_jenkins',
                ( "$entry -> " . $lang_entries_ref->{$entry} ) );
            $stats->inc('no_jenkins');
        }
    }

    if ( $processor->is_to_search ) {
        my $term = $processor->search_term;

        foreach my $entry ( keys %{$lang_entries_ref} ) {
            if (   $lang_entries_ref->{$entry}
                && $lang_entries_ref->{$entry} =~ $term )
            {
                $warnings->add( 'search_found',
                    ( "$entry -> " . $lang_entries_ref->{$entry} ) );
            }
        }

    }

    $warnings->summary($curr_lang_file);
    $warnings->reset;
}

is( $stats->perc_done, 100, 'Got 100% translated' );
is( $stats->get_keys, 3,
    'Have identified the expected number of translation keys' );
