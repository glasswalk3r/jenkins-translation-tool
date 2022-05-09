#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use File::Find;
use File::Spec;
use Config;
use Benchmark::Dumb qw(:all);

# Relative paths inside the Jenkins project repository
my $src_test_path = File::Spec->catfile( 'src',    'test' );
my $target_path   = File::Spec->catfile( 'target', '' );

sub find_files {
    my $dir = shift;
    die "Must provide a string, invalid directory parameter"
        unless ($dir);
    die "Must provide a string, invalid directory parameter"
        unless ( ref($dir) eq '' );
    die "Directory $dir must exists" unless ( -d $dir );
    my @files;

    # BUGFIX: File::Find::name is not returning with MS Windows separator
    my $is_windows = 0;
    my $separator;

    if ( $Config{osname} eq 'MSWin32' ) {
        $is_windows = 1;
        $separator  = qr#/#;
    }

    find(
        sub {
            my $file = $File::Find::name;
            $file =~ s#$separator#\\# if ($is_windows);
            if (   $file !~ m#($src_test_path)|($target_path)#
                && $file =~ /(Messages.properties)$|(.*\.jelly)$/ )
            {
                push( @files, $file );

            }
        },
        $dir
    );
    my @sorted = sort(@files);
    return \@sorted;
}

my $src_regex    = qr/$src_test_path/;
my $target_regex = qr/$target_path/;
my $msgs_regex   = qr/Messages\.properties$/;
my $jelly_regex  = qr/\.jelly$/;

my $win_sep_regex;

if ( $Config{osname} eq 'MSWin32' ) {
    $win_sep_regex = qr#/#;
}

sub find_files2 {
    my $dir = shift;
    die "Must provide a string, invalid directory parameter"
        unless ($dir);
    die "Must provide a string, invalid directory parameter"
        unless ( ref($dir) eq '' );
    die "Directory $dir must exists" unless ( -d $dir );
    my @files;

    # BUGFIX: File::Find::name is not returning with MS Windows separator
    my $is_windows = 0;
    $is_windows = 1 if ( $Config{osname} eq 'MSWin32' );

    find(
        sub {
            my $file = $File::Find::name;
            $file =~ s#$win_sep_regex#\\# if ($is_windows);

            unless ( ( $file =~ $src_regex ) or ( $file =~ $target_regex ) ) {
                push( @files, $file )
                    if ( ( $file =~ $msgs_regex )
                    or ( $file =~ $jelly_regex ) );
            }

        },
        $dir
    );
    my @sorted = sort(@files);
    return \@sorted;
}

my $dir    = shift;
my $result = timethese(
    100,
    {
        find_files  => sub { find_files($dir) },
        find_files2 => sub { find_files2($dir) }
    }
);
cmpthese($result);
