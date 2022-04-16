package Jenkins::i18n::Stats;

use 5.014004;
use strict;
use warnings;
use Hash::Util qw(lock_keys);
use Carp qw(confess);

our $VERSION = '0.01';

=pod

=head1 NAME

Jenkins::i18n::Stats - class to provide translations processing statistics

=head1 SYNOPSIS

  use Jenkins::i18n::Stats;

=head1 DESCRIPTION

C<Jenkins::i18n::Stats>

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
    my $class = shift;
    my $self  = {
        files      => 0,
        keys       => 0,
        missing    => 0,
        unused     => 0,
        empty      => 0,
        same       => 0,
        no_jenkins => 0
    };

    bless $self, $class;
    lock_keys( %{$self} );
    return $self;
}

=head2 inc

Increments a counter.

=cut

sub inc {
    my ( $self, $item ) = @_;
    confess "item is a required parameter" unless ($item);
    $self->{$item}++;
}

sub summary {
    my $self = shift;

    my $done
        = $self->{keys}
        - $self->{missing}
        - $self->{unused}
        - $self->{empty}
        - $self->{same}
        - $self->{no_jenkins};

    unless ( $self->{keys} == 0 ) {
        my $pdone      = $done / $self->{keys} * 100;
        my $pmissing   = $self->{missing} / $self->{keys} * 100;
        my $punused    = $self->{unused} / $self->{keys} * 100;
        my $pempty     = $self->{empty} / $self->{keys} * 100;
        my $psame      = $self->{same} / $self->{keys} * 100;
        my $pnojenkins = $self->{no_jenkins} / $self->{keys} * 100;
    }
    else {
        warn "Not a single key was processed\n";
    }

#printf
#"\nTOTAL: Files: %d Keys: %d Done: %d(%.2f%%)\n       Missing: %d(%.2f%%) Orphan: %d(%.2f%%) Empty: %d(%.2f%%) Same: %d(%.2f%%) NoJenkins: %d(%.2f%%)\n\n",
#    (@formatParameters);
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