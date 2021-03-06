use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Form::Transer',
    license             => 'perl',
    dist_author         => 'Justin Davis <jrcd83@gmail.com>',
    dist_version_from   => 'lib/Form/Transer.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Form-Transer-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
