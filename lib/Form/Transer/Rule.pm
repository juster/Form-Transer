package Form::Transer::Rule;

use warnings;
use strict;
use UNIVERSAL::require;
use Carp qw(croak);

sub new
{
    my $class = shift;
    my ($code_ref, %options) = @_;

    my $reqs = $options{requires};
    if ( defined $reqs ) {
        if ( ! ref $reqs ) { $reqs = [ $reqs ]; }
        elsif ( ref $reqs ne 'ARRAY' ) {
            croak q{"requires" option must be a scalar or arrayref};
        }
    }
    else {
        $reqs = [];
    }

    return bless { 'code'   => $code_ref, 'reqs' => $reqs,
                   'config' => [] }, $class;
}

sub clone
{
    my $self = shift;
    return bless { %$self }, __PACKAGE__;
}

sub init
{
    my $self = shift;
    unless ( $self->{loaded}++ ) {
        for my $module ( @{ $self->{reqs} } ) {
            $module->require
                or die qq{Failed to load required module "$module"};
        }
    }
    return;
}

sub get_code
{
    my $self = shift;
    return $self->{code};
}

sub set_config
{
    my $self    = shift;
    my $new_cfg = shift;
    croak q{config must be an arrayref} unless ( ref $new_cfg eq 'ARRAY' );
    return $self->{config} = $new_cfg;
}

sub get_config
{
    my $self = shift;
    return $self->{config};
}

1;

