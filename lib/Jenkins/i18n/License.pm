package Jenkins::i18n::License;

use 5.014004;
use strict;
use warnings;
use Carp       qw(confess);
use File::Path qw(make_path);
use DateTime::Tiny;
use Hash::Util qw(lock_keys);

=pod

=head1 NAME

Jenkins::i18n::License

=head1 SYNOPSIS

    use Jenkins::i18n::License;
    my $license = Jenkins::i18n::License->new;
    $license->print_license($some_file);
    my $data_ref = $license->read_license;

=head1 DESCRIPTION

This class handles all license requirements for new translation files created.

It is intended to be used to provide the license text on new properties files.

=cut

our $VERSION = '0.10';

=head1 METHODS

=head2 new

Creates a new instance of the class and return it.

Doesn't expect any parameter.

=cut

sub new {
    my $class = shift;
    my $now   = DateTime::Tiny->now;
    my $self  = {
        current_year => $now->year,
        content      => undef
    };
    bless $self, $class;
    lock_keys( %{$self} );
    return $self;
}

=head2 print

Print the license text to a file.

Expects as parameters:

=over

=item 1

the complete path to the file

=back

=cut

sub print {
    my ( $self, $file ) = @_;
    confess 'The complete path to the file parameter is required'
        unless ($file);

    # only dirs part is desired
    my $dirs = ( File::Spec->splitpath($file) )[1];
    make_path($dirs) unless ( -d $dirs );
    open( my $out, '>', $file ) or confess "Cannot write to $file: $!\n";
    my $data_ref = $self->read;

    foreach my $line ( @{$data_ref} ) {
        print $out "#$line";
    }

    close($out);
}

=head2 read

Returns the license, as an array reference.

The license itself will include a line referencing the translators, which will
include the current year.

=cut

sub read {
    my $self = shift;

    unless ( $self->{content} ) {
        my @license                  = <DATA>;
        my $additional_license_index = 4;

        # right after the copyright line
        confess
            "Unexpected license content, expected only a new line at 4 index"
            unless ( $license[$additional_license_index] eq "\n" );

        $license[$additional_license_index]
            = ' Copyright (c) '    # a space in the beginning is required
            . $self->{current_year} . "- Jenkins contributors.\n";

        $self->{content} = \@license;
    }

    return $self->{content};
}

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
License, copyright (c) 2004, Kohsuke Kawaguchi, Sun Microsystems, Inc., and a
number of other of contributors. Translations files generated by the Jenkins
Translation Tool CLI are distributed with the same MIT License.

=cut

1;

__DATA__
 The MIT License

 Copyright (c) 2004-, Kohsuke Kawaguchi, Sun Microsystems, Inc., and a number
 of other of contributors.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
