use warnings;
use strict;
use Test::More tests => 7;
use Jenkins::i18n;

my %entries;
ok( Jenkins::i18n::jelly_entry( '${%Enabled jobs only}', \%entries ),
    'jelly_entry works' );
ok(
    Jenkins::i18n::jelly_entry( q{${%blurb(rootURL+'/'+it.url)}}, \%entries ),
    'jelly_entry works'
);
ok( Jenkins::i18n::jelly_entry( '${%Username}', \%entries ),
    'jelly_entry works' );
ok(
    Jenkins::i18n::jelly_entry(
        '${%Create an account! [Jenkins]}', \%entries
    ),
    'jelly_entry works'
);
ok( Jenkins::i18n::jelly_entry( '${%Create an account!}', \%entries ),
    'jelly_entry works' );
ok(
    Jenkins::i18n::jelly_entry(
q{${%A strong password is a long password that's unique for every site. Try using a phrase with 5-6 words for the best security.}},
        \%entries
    ),
    'jelly_entry works'
);

is_deeply(
    \%entries,
    {
        'Enabled\ jobs\ only'             => 1,
        'blurb'                           => 1,
        'Username'                        => 1,
        'Create\ an\ account!'            => 1,
        'Create\ an\ account!\ [Jenkins]' => 1,
q{A\ strong\ password\ is\ a\ long\ password\ that's\ unique\ for\ every\ site.\ Try\ using\ a\ phrase\ with\ 5-6\ words\ for\ the\ best\ security.}
            => 1
    },
    'have expected outcome'
) or diag( explain( \%entries ) );

# -*- mode: perl -*-
# vi: set ft=perl :
