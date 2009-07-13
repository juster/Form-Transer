package Form::Transer::Test;

use warnings;
use strict;

use base qw(Exporter);
use Carp qw(croak);

use Form::Transer::Error qw(throw);

our @EXPORT      = qw();
our @EXPORT_OK   = qw(STATE ARGS BYPASS);
our %EXPORT_TAGS = ( 'constants' => [ qw/ STATE ARGS BYPASS / ] );

sub STATE  { 0 }
sub ARGS   { 1 }
sub BYPASS { 2 }

sub new
{
    croak 'Invalid arguments to Test constructor'
        unless ( @_ >= 3 );

    my ($class, $rules, $error) = @_;

    croak 'You must at least supply one rule' unless ( $rules );

    $rules = ( ! ref $rules          ? [ $rules ] :
               ref $rules eq 'ARRAY' ? $rules     :
               croak q{First argument must be a scalar or arrayref} );

#    use Data::Dumper;
#    $Data::Dumper::Deparse = 1;
#    printf STDERR "DEBUG: new test for rule[s]:\n%s\n", Dumper($rules);

    bless { rules       => $rules,
            error       => $error,
            state       => {},
            group_logic => 'all', }, $class;
}

sub conduct
{
    my ($self, $value) = @_;

    # Prepare the rule code's stuffs.
    RULE_LOOP:
    for my $rule ( @{$self->{rules}} ) {
        $rule->init;
        my $code_ref = $rule->get_code;
        my $STATE    = {};

        my @args;
        $args[ STATE  ] = {};
        $args[ ARGS   ] = $rule->get_config;
        $args[ BYPASS ] = 0;

        local $_ = $value;
        my $success = $code_ref->(@args);
        if ( ! $success ) {
            throw( $self->get_error );
        }

        last RULE_LOOP if $args[BYPASS];
    }

    return 1;
}

sub get_error
{
    my $self = shift;
    return $self->{error};
}

1;
