package Jenkins::i18n::FindResults;

use 5.014004;
use strict;
use warnings;
use Hash::Util qw(lock_keys);

=pod

=head1 NAME

Jenkins::i18n::FindResults - class that represents the results of
Jenkins::i18n::find_files

=head1 SYNOPSIS

=head1 METHODS

=head2 new

Creates and returns an instance.

No parameter is expected.

=cut

sub new {
    my $class = shift;
    my $self  = {
        files    => [],
        warnings => []
    };
    bless $self, $class;
    lock_keys( %{$self} );
    return $self;
}

=head2 add_file

Adds a file to the files set.

Expects a string as parameters.

Return nothing.

=cut

sub add_file {
    my ( $self, $file_path ) = @_;
    push( @{ $self->{files} }, $file_path );
}

=head2 add_warning

Adds a warning to the warnings set.

Expects as parameters a string.

Return nothing.

=cut

sub add_warning {
    my ( $self, $warning ) = @_;
    push( @{ $self->{warnings} }, $warning );
}

sub _generic_iterator {
    my ( $self, $items_ref ) = @_;
    my $current_index = -1;
    my $last_index    = scalar( @{$items_ref} ) - 1;

    return sub {
        return if ( $current_index == $last_index );
        $current_index++;
        return $items_ref->[$current_index];
    }
}

=head2 files

Returns an iterator for the files set, as a C<sub> reference.

The iterator will return C<undef> when there are no more elements so you can
use it inside an C<while> loop.

The iterator only moves foward and the items will be alphabetically sorted.

Adding new files to the set after an iterator is created won't update it
automatically, one will need to create a new one with this method.

Expects no parameter.

=cut

sub files {
    my $self   = shift;
    my @sorted = sort( @{ $self->{files} } );
    return $self->_generic_iterator( \@sorted );
}

=head2 warnings

Returns an iterator for the warnings set, as a C<sub> reference.

The iterator will return C<undef> when there are no more elements so you can
use it inside an C<while> loop.

The iterator only moves foward, the order of items will be in the sequence of
registry of each warning.

Adding new files to the set after an iterator is created won't update it
automatically, one will need to create a new one with this method.

Expects no parameter.

=cut

sub warnings {
    my $self = shift;
    return $self->_generic_iterator( $self->{warnings} );
}

=head2 size

Returns a integer with the total of elements for the files.

=cut

sub size {
    my $self = shift;
    return scalar( @{ $self->{files} } );
}

=head1 SEE ALSO

=over

=item *

L<Hash::Util>

=back

=cut

1;
__END__
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

The original C<translation-tool.pl> script was licensed through the MIT
License, copyright (c) 2004-, Kohsuke Kawaguchi, Sun Microsystems, Inc., and a
number of other of contributors. Translations files generated by the Jenkins
Translation Tool CLI are distributed with the same MIT License.

=cut
