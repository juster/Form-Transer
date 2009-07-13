package Form::Transer::Report;

use warnings;
use strict;

sub new
{
    my $class   = shift;
    my %options = @_;

    bless { errors => $options{errors},
            values => $options{values} }, $class;
}

sub value
{
    my $self = shift;
    return $self->{values}{shift()};
}

*val = \&value;

sub ok
{
    my ($self, $param) = @_;
    return %$self eq '0' unless defined $param;
    return ! exists $self->{$param};
}

sub bad
{
    my ($self, $param) = @_;

    return %$self ne '0' unless defined $param;
    return exists $self->{$param};
}

sub err
{
    my ($self, $param) = @_;

    return $self->{$param};
}

sub errors
{
    my $self = shift;

    my %is_dup;
    return grep { ! $is_dup{$_} } values %$self;
}

1;
