use warnings;
use strict;
use Test::More tests => 30;
use Test::Exception;
use Test::Warnings qw(:all);

use Jenkins::i18n::Warnings;

my $class = 'Jenkins::i18n::Warnings';
can_ok( $class,
    qw(new add has_unused reset summary has_missing _relative_path has_found)
);
my $instance = Jenkins::i18n::Warnings->new;
ok( $instance, 'got an instance' );
isa_ok( $instance, $class );
ok( exists( $instance->{types} ), 'instance has types attribute' );
my @types = sort( keys( %{ $instance->{types} } ) );
is_deeply(
    \@types,
    [
        'empty', 'ignored',      'missing', 'non_jenkins',
        'same',  'search_found', 'unused'
    ],
    'instance has the expected types'
);
dies_ok { $instance->{foo} = 'bar' } 'cannot change attributes of instance';
like( $@, qr/disallowed\skey\s'foo'/, 'got expected error message' );
dies_ok { $instance->add } 'dies with missing warning type argument';
my $required_regex = qr/required/;
like( $@, $required_regex, 'got the expected message' );
dies_ok { $instance->add('empty') } 'dies with missing value argument';
like( $@, $required_regex, 'got the expected message' );
dies_ok { $instance->add( 'foobar', 'barfoo' ) }
'dies with invalid warning type';
like( $@, qr/not\sa\svalid\stype/, 'got the expected error message' );
is( $instance->has_unused,  0, 'instance has not a unused warning' );
is( $instance->has_missing, 0, 'instance has not a missing warning' );
ok( $instance->add( 'unused', 'some key' ), 'adds a unused warning' );
ok( $instance->has_unused,                  'instance has a unused warning' );
ok( $instance->add( 'missing', 'another key' ), 'adds a missing warning' );
ok( $instance->has_missing, 'instance has a missing warning' );
dies_ok { $instance->summary } 'summary dies with missing file parameter';
like( $@, qr/translation\sfile/, 'got the expected error message' );
is_deeply(
    warning { $instance->summary('foo.properties') },
    [
        "Got warnings for foo.properties:\n",
        "\tMissing 'another key'\n",
        "\tUnused 'some key'\n"
    ],
    'summary works'
);
note('Testing search warnings');
is( $instance->has_found, 0, 'instance has no search warnings' );
ok( $instance->add( 'search_found', '/foo/bar.properties' ),
    'adds a search warning' );
is( $instance->has_found, 1, 'instance has one search warning' );
note('Reseting warnings');
ok( $instance->reset, 'instance reset works' );
is( $instance->has_unused,     0, 'instance has not a unused warning' );
is( $instance->has_missing,    0, 'instance has not a missing warning' );
is( $instance->summary('foo'), 0, 'summary warns nothing' );

# -*- mode: perl -*-
# vi: set ft=perl :
