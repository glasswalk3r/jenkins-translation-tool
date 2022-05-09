#!/usr/bin/env perl
use warnings;
use strict;
use File::Spec;
use Benchmark::Dumb qw(:all);
use Data::Dumper;

sub regex_process {
    my ( $file, $source, $target, $lang ) = @_;
    my ( $curr_lang_file, $english_file ) = ( $file, $file );
    $curr_lang_file =~ s/$source/$target/;
    $curr_lang_file =~ s/(\.jelly)|(\.properties)/_$lang.properties/;
    $english_file   =~ s/(\.jelly)/.properties/;
    return ( $curr_lang_file, $english_file );
}

my $both_regex  = qr/(\.jelly$)|(\.properties$)/;
my $jelly_regex = qr/\.jelly$/;

sub regex_process2 {
    my ( $file, $source, $target, $lang ) = @_;
    my ( $curr_lang_file, $english_file ) = ( $file, $file );
    $curr_lang_file =~ s/$source/$target/;
    $curr_lang_file =~ s/$both_regex/_$lang.properties/;
    $english_file   =~ s/$jelly_regex/.properties/;
    return ( $curr_lang_file, $english_file );
}

sub spec_process {
    my ( $file, $target, $lang ) = @_;
    my ( $source, $filename ) = ( File::Spec->splitpath($file) )[ 1, 2 ];
    my ( $filename_prefix, $filename_ext ) = split( /\./, $filename );
    my ( $curr_lang_file,  $english_file );

    if ( $filename_ext eq 'jelly' ) {
        $curr_lang_file = $filename_prefix . '_' . $lang . '.properties';
        $english_file   = "$filename_prefix.properties";
    }
    elsif ( $filename_ext eq 'properties' ) {
        $curr_lang_file = $filename_prefix . '_' . $lang . '.properties';
        $english_file   = $filename;
    }
    else {
        die "Unexpected file extension '$filename_ext'";
    }

    my @source_dirs = File::Spec->splitdir($source);

    if ( $source eq $target ) {
        $curr_lang_file
            = File::Spec->catfile( @source_dirs, $curr_lang_file );
        $english_file = File::Spec->catfile( @source_dirs, $english_file );
    }
    else {
        my @target_dirs = File::Spec->splitdir($target);
        $curr_lang_file
            = File::Spec->catfile( @target_dirs, $curr_lang_file );
        $english_file = File::Spec->catfile( @source_dirs, $english_file );
    }

    return ( $curr_lang_file, $english_file );
}

my $ext_sep = qr/\./;

sub spec_process2 {
    my ( $file, $target, $lang ) = @_;
    my ( $source, $filename ) = ( File::Spec->splitpath($file) )[ 1, 2 ];
    my ( $filename_prefix, $filename_ext ) = split( $ext_sep, $filename );
    my ( $curr_lang_file,  $english_file );

    if ( $filename_ext eq 'jelly' ) {
        $curr_lang_file = $filename_prefix . '_' . $lang . '.properties';
        $english_file   = "$filename_prefix.properties";
    }
    elsif ( $filename_ext eq 'properties' ) {
        $curr_lang_file = $filename_prefix . '_' . $lang . '.properties';
        $english_file   = $filename;
    }
    else {
        die "Unexpected file extension '$filename_ext'";
    }

    if ( $source eq $target ) {
        return (
            File::Spec->catfile( $source, $curr_lang_file ),
            File::Spec->catfile( $source, $english_file )
        );
    }

    return (
        File::Spec->catfile( $target, $curr_lang_file ),
        File::Spec->catfile( $source, $english_file )
    );

}

print "regex_process\n";
print Dumper(
    regex_process(
        '/foo/bar/message.jelly', '/foo/bar', '/bar/foo', 'pt_BR'
    )
);
print "regex_process2\n";
print Dumper(
    regex_process2(
        '/foo/bar/message.jelly', '/foo/bar', '/bar/foo', 'pt_BR'
    )
);
print "spec_process\n";
print Dumper( spec_process( '/foo/bar/message.jelly', '/bar/foo', 'pt_BR' ) );
print "spec_process2\n";
print Dumper(
    spec_process2( '/foo/bar/message.jelly', '/bar/foo', 'pt_BR' ) );

my $result = timethese(
    1000,
    {
        regex_process => {
            regex_process(
                '/foo/bar/message.jelly', '/foo/bar', '/bar/foo', 'pt_BR'
            )
        },
        regex_process2 => {
            regex_process2(
                '/foo/bar/message.jelly', '/foo/bar', '/bar/foo', 'pt_BR'
            )
        },
        spec_process => {
            spec_process(
                '/foo/bar/message.jelly', '/foo/bar', '/bar/foo', 'pt_BR'
            )
        },
        spec_process2 => {
            spec_process2(
                '/foo/bar/message.jelly', '/foo/bar', '/bar/foo', 'pt_BR'
            )
        }
    }
);
cmpthese($result);

