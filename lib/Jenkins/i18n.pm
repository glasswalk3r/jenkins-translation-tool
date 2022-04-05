package Jenkins::i18n;

use 5.014004;
use strict;
use warnings;
use Carp qw(confess);
use File::Find;

use Jenkins::i18n::Properties;

=pod

=head1 NAME

Jenkins::i18n - functions for translation-tool

=head1 SYNOPSIS

  use Jenkins::i18n qw(remove_unused);

=head1 DESCRIPTION

C<translation-tool.pl> is a CLI program used to help translating the Jenkins
properties file.

This module implements the functions used by the CLI.

=cut

use Exporter 'import';
our @EXPORT_OK = qw(
    remove_unused find_files print_license load_properties
);

our $VERSION = '0.01';

=head2 EXPORT

None by default.

=head2 FUNCTIONS

=head3 remove_unused

Remove unused keys from a properties file.

Each translation in every language depends on the original properties files
that are written in English.

This function gets a set of keys and compare with those that are stored in the
translation file: anything that exists outside the original set in English is
considered deprecated and so removed.

Expects as positional parameters:

=over

=item 1

file: the complete path to the translation file to be checked.

=item 2

keys: a L<Set::Tiny> instance of the keys from the original English properties
file.

=item 3

license: a scalar reference with a license to include the header of the
translated properties file.

=item 4

backup: a boolean (0 or 1) if a backup file should be created in the same path
of the file parameter. Optional.

=back

Returns the number of keys removed (as an integer).

=cut

sub remove_unused {
    my $file = shift;
    confess "file is a required parameter\n" unless ( defined($file) );
    my $keys = shift;
    confess "keys is a required parameter\n" unless ( defined($keys) );
    confess "keys must be a Set::Tiny instance\n"
        unless ( ref($keys) eq 'Set::Tiny' );
    my $license_ref = shift;
    confess "license must be an array reference"
        unless ( ref($license_ref) eq 'ARRAY' );
    my $use_backup = shift;
    $use_backup = 0 unless ( defined($use_backup) );

    my $props_handler;

    if ($use_backup) {
        my $backup = "$file.bak";
        rename( $file, $backup )
            or confess "Cannot rename $file to $backup: $!\n";
        $props_handler = Jenkins::i18n::Properties->new( file => $backup );
    }
    else {
        $props_handler = Jenkins::i18n::Properties->new( file => $file );
    }

    my %curr_props = $props_handler->properties;
    my $removed    = 0;

    foreach my $key ( keys(%curr_props) ) {
        $removed++ unless ( $keys->has($key) );
    }

    open( my $out, '>', $file ) or confess "Cannot write to $file: $!\n";
    $props_handler->save( $out, $license_ref );
    close($out) or confess "Cannot save $file: $!\n";

    return $removed;
}

=head2 find_files

Find all files Jelly and Java Properties files that could be translated from
English, i.e., files that do not have a ISO 639-1 standard language based code
as a filename prefix (before the file extension).

Expects as parameter a complete path to a directory that might contain such
files.

Returns an array reference with the complete path to those files.

=cut

sub find_files {
    my $dir = shift;
    confess "Must provide a string, invalid directory parameter"
        unless ($dir);
    confess "Must provide a string, invalid directory parameter"
        unless ( ref($dir) eq '' );
    confess "Directory $dir must exists" unless ( -d $dir );
    my @files;
    find(
        sub {
            my $file = $File::Find::name;
            push( @files, $file )
                if ( $file !~ m#(/src/test/)|(/target/)#
                && $file =~ /(Messages.properties)$|(.*\.jelly)$/ );
        },
        $dir
    );
    return \@files;
}

=head2 print_license

Print a license text to new files.

Expects as parameters:

=over

=item *

the complete path to the file

=item *

an array reference with the license text.

=back

=cut

sub print_license {
    my ( $file, $data_ref ) = @_;
    my $dir_name = dirname($file);
    mkpath($dir_name) unless ( -d $dir_name );
    open( my $out, ">" . $file ) or die "Cannot write to $file: $!\n";

    foreach my $line ( @{$data_ref} ) {
        print $out "#$line";
    }

    close($out);
}

=head2 load_properties

Loads the content of a Java Properties file into a hash.

Expects as parameter the complete path to a Java Properties file.

Returns an hash reference. If the file doesn't exist, prints a warning to
C<STDERR> and returns an empty hash reference.

=cut

sub load_properties {
    my $file = shift;

    unless (-f $file) {
        warn "File $file doesn't exist, skipping it...";
        return {};
    }

    my $props_handler = Jenkins::i18n::Properties->new( file => $file );
    return $props_handler->getProperties;
}

1;

__END__


=head1 SEE ALSO

=over

=item *

L<Jenkins::i18n::Properties>

=item *

L<Set::Tiny>

=back

=head1 AUTHOR

Alceu Rodrigues de Freitas Junior, E<lt>arfreitas@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2022 of Alceu Rodrigues de Freitas Junior,
arfreitas@cpan.org

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
copyright (c) 2004-, Kohsuke Kawaguchi, Sun Microsystems, Inc., and a number
of other of contributors. Translations files generated by the Jenkins
Translation Tool CLI are distributed with the same MIT License.

=cut

