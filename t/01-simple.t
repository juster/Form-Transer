#!/usr/bin/perl

use warnings;
use strict;
use Test::More qw(no_plan);
use Form::Transer;
use Data::Dumper;
use CGI;

my $cgi = CGI->new;
$cgi->param( 'number', 'blablabla' );

ok( my $ft = Form::Transer->new($cgi) );
ok( my $report = $ft->check( number => q{ number ! Please enter a number } ));
ok( $report->bad('number') );
is( $report->err('number'), q{Please enter a number} );

$cgi->param( 'number', '0' );
ok( $report = $ft->check( number => q{ number ! Please enter a number } ));
ok( ! $report->bad('number') );
ok( $report->ok('number') );

$cgi->param( 'number', '13505' );
ok( $report = $ft->check( number => q{ UINT ! Please enter an integer } ) );
ok( ! $report->bad('number') );
ok( $report->ok('number') );

$cgi->param( 'number2', '13505' );
ok( $report = $ft->check( [ qw/number number2/ ] => q{ SAME ! Must be the same } ));

printf STDERR "DEBUG: %s\n", Dumper($report);
