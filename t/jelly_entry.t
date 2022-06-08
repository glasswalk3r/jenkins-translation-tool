use warnings;
use strict;
use Test::More;    # tests => 7;
use Jenkins::i18n;

my %entries;
my @raw_entries = (
    '${%Enabled jobs only}',
    q{${%blurb(rootURL+'/'+it.url)}},
    '${%Username}',
    '${%Create an account! [Jenkins]}',
    '${%Create an account!}',
q{${%A strong password is a long password that's unique for every site. Try using a phrase with 5-6 words for the best security.}},
    '${%about(app.VERSION)}',
    '${%Build Queue(items.size())}'
);

foreach my $raw_entry (@raw_entries) {
    ok( Jenkins::i18n::jelly_entry( $raw_entry, \%entries ),
        "jelly_entry works with >>$raw_entry<<" );
}

is_deeply(
    \%entries,
    {
        'Enabled\ jobs\ only'             => 1,
        'blurb'                           => 1,
        'Username'                        => 1,
        'Create\ an\ account!'            => 1,
        'Create\ an\ account!\ [Jenkins]' => 1,
        'about'                           => 1,
        'Build\ Queue'                    => 1,
q{A\ strong\ password\ is\ a\ long\ password\ that's\ unique\ for\ every\ site.\ Try\ using\ a\ phrase\ with\ 5-6\ words\ for\ the\ best\ security.}
            => 1
    },
    'have expected outcome'
) or diag( explain( \%entries ) );

done_testing;

# -*- mode: perl -*-
# vi: set ft=perl :
