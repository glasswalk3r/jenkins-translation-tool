use 5.014004;
use ExtUtils::MakeMaker;

if ( $^O eq 'MSWin32' ) {
    die "OS unsupported\n";
}

WriteMakefile(
    NAME          => 'Jenkins::i18n',
    VERSION_FROM  => 'lib/Jenkins/i18n.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    ABSTRACT_FROM => 'lib/Jenkins/i18n.pm',
    AUTHOR        => 'Alceu Rodrigue de Freitas Junior',
    EXE_FILES     => ['bin/jtt'],
    PREREQ_PM     => {
        'Class::Accessor'    => 0.51,
        'Config::Properties' => 1.80,
        'DateTime::Tiny'     => 1.07,
        'File::Path'         => 2.18,
        'Set::Tiny'          => 0.04,
        'Term::ANSIColor'    => 5.01,
        'Term::ProgressBar'  => 2.22,
        'IO::Interactive'    => 1.023
    },
    TEST_REQUIRES => {
        'Test::TempDir::Tiny' => 0.018,
        'Test::Exception'     => 0.43,
        'Test::Warnings'      => 0.031,
    },
    LICENSE          => 'gpl',
    MIN_PERL_VERSION => 5.014004
);
