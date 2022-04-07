package Jenkins::i18n::Warnings;

use 5.014004;
use strict;
use warnings;
use Hash::Util qw(lock_keys);
use Carp qw(confess);

our $VERSION = '0.01';

=pod

=head1 NAME

Jenkins::i18n::Warnings - class to handle translation warnings

=head1 SYNOPSIS

  use Jenkins::i18n::Warnings;

=head1 DESCRIPTION

C<Jenkins::i18n::Warnings>

=head2 EXPORT

None by default.

=head1 ATTRIBUTES

All attributes are counters.

=over

=item *

files: all the processed translation files.

=back

=head1 METHODS

=head2 new

Creates a new instance.

=cut

sub new {
    my ( $class, $opts_ref ) = @_;
    confess 'must receive a hash reference as argument'
        unless ( ref($opts_ref) eq 'HASH' );
    confess 'is_add option in required'
        unless ( exists( $opts_ref->{is_add} ) );

    my $self = {
        is_add => $opts_ref->{is_add},
        types  => {
            empty       => 'Empty',
            unused      => 'Unused',
            same        => 'Same',
            non_jenkins => 'Non Jenkins',
        }
    };

    if ( $self->{is_add} ) {
        $self->{types}->{missing} = 'Adding';
    }
    else {
        $self->{types}->{missing} = 'Missing';
    }

    bless $self, $class;
    $self->reset;
    lock_keys( %{$self} );
    return $self;
}

sub has_unused {
    my $self = shift;
    return ( scalar( @{ $self->{unused} } ) ) > 0;
}

sub reset {
    my $self = shift;

    foreach my $type ( keys %{ $self->{types} } ) {
        $self->{$type} = [];
    }
}

=head2 inc

Increments a counter.

=cut

sub add {
    my ( $self, $item, $value ) = @_;
    confess "item is a required parameter"  unless ($item);
    confess "value is a required parameter" unless ($value);
    push( @{ $self->{$item} }, $value );
}

sub summary {
    my $self = shift;

    while ( my ( $type, $desc ) = each( %{ $self->{types} } ) ) {
        foreach my $item ( @{ $self->{$type} } ) {
            warn "$desc '$item'\n";
        }
    }

}

sub ok_to_add {
    my $self  = shift;
    my $total = scalar( $self->{missing} );
    return ( $self->{is_add} and ( $total == 0 ) );
}

1;
__END__

=head1 SEE ALSO

=over

=item *

L<Config::Properties>

=back

=head1 AUTHOR

Alceu Rodrigues de Freitas Junior, E<lt>arfreitas@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2022 of Alceu Rodrigues de Freitas Junior,
E<lt>arfreitas@cpan.orgE<gt>

This file is part of Jenkins Translation Tool project.

Jenkins Translation Tool is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your option)
any later version.

Jenkins Translation Tool is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public License along with
Jenkins Translation Tool. If not, see (http://www.gnu.org/licenses/).

The original `translation-tool.pl` script was licensed through the MIT License,
copyright (c) 2004-, Kohsuke Kawaguchi, Sun Microsystems, Inc., and a number of
other of contributors. Translations files generated by the Jenkins Translation
Tool CLI are distributed with the same MIT License.

=cut
