use strict;
use warnings;
use Test::More tests => 3;

use Jenkins::i18n
    qw(find_files load_properties load_jelly find_langs all_data );
use Jenkins::i18n::Stats;
use Jenkins::i18n::Warnings;
use Jenkins::i18n::ProcOpts;
use Jenkins::i18n::Assertions qw(has_empty can_ignore has_hudson);

my $path = 't/samples/mixed';

# TODO: this must be a temporary workaround
use Cwd;
chdir($path) or die "Cannot cd to $path: $!";
my $current_dir = getcwd;

# TODO: copied from the CLI, must be refactored to import functions instead

my $all_langs = find_langs($current_dir);
my $result    = find_files( $current_dir, $all_langs );
is( $result->size, 2, 'Got the expected number of files' );
my $stats     = Jenkins::i18n::Stats->new;
my $warnings  = Jenkins::i18n::Warnings->new(1);
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
    my ( $entries_ref, $lang_entries_ref, $english_entries_ref )
        = all_data( $file, $processor );

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
            unless ( has_empty($entry) ) {
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
            unless ( can_ignore( $lang_entries_ref->{$entry} ) ) {
                $stats->inc('same');
                $warnings->add( 'same', $entry );
            }
            else {
                $warnings->add( 'ignored', $entry );
            }
        }
    }

    foreach my $entry ( keys %{$lang_entries_ref} ) {
        if ( $lang_entries_ref->{$entry}
            && has_hudson( $lang_entries_ref->{$entry} ) )
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
is( $stats->get_keys, 4,
    'Have identified the expected number of translation keys' );
