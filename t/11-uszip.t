#!/usr/bin/perl

use warnings;
use strict;
use Test::More qw(no_plan);

use Form::Transer;
use CGI;

my $cgi = CGI->new;

$cgi->param( 'goodzip1' => '92663' );
$cgi->param( 'goodzip2' => '92007' );
$cgi->param( 'goodzip3' => '90210' );

ok( my $ft = Form::Transer->new($cgi) );
ok( my $r = $ft->check( [ map { "goodzip$_" } ( 1 .. 3 ) ] =>
                        ' USZIP ! Invalid ZIP Code' ));
ok( $r->ok );

foreach ( map { "goodzip$_" } ( 1 .. 3 ) ) {
    ok( $r->ok($_) );
}
