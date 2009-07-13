#!/usr/bin/perl

use warnings;
use strict;
use Test::More qw(no_plan);

use Form::Transer;
use CGI;

my $cgi = CGI->new;
$cgi->param( 'phone', '19495555484' );

ok( my $ft = Form::Transer->new($cgi) );
ok( my $report = $ft->check( phone => q{ USPHONE ! Invalid phone number } ));
ok( ! $report->bad('phone') );
ok( $report->ok('phone') );
is( $report->err('phone'), undef );

$cgi->param( 'phone', '1(949)555-5484' );
ok( $report = $ft->check( phone => q{ USPHONE ! Invalid phone number } ));
ok( ! $report->bad('phone') );
ok( $report->ok('phone') );
is( $report->err('phone'), undef );

$cgi->param( 'phone', 'asl;dkasd;f' );
ok( $report = $ft->check( phone => q{ USPHONE ! Invalid phone number } ));
ok( $report->bad('phone') );
ok( ! $report->ok('phone') );
is( $report->err('phone'), 'Invalid phone number' );

$cgi->param( 'phone1',    '1 800 555 5484 ext 321'   );
$cgi->param( 'phone2',    '1 (800) 555-5484ext321' );
$cgi->param( 'phone3',    '1-800-555-1234X321' );

$cgi->param( 'badphone1', '#@#$(*!@#$^!@#$)' );
$cgi->param( 'badphone2', 'Hi my name is Bill.' );

ok( $report = $ft->check
    ( [ qw/phone1 phone2 phone3 badphone1 badphone2/ ] =>
      q{ USPHONE ! Invalid phone number } ));

ok( $report->bad );
is( $report->err('phone1'), undef );
is( $report->err('phone2'), undef );
is( $report->err('phone3'), undef );

is( $report->err('badphone1'), 'Invalid phone number' );
is( $report->err('badphone2'), 'Invalid phone number' );

