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

sub get_values
{
    my $self = shift;
    my %values_copy = %{ $self->{values} };
    return %values_copy;
}

sub ok
{
    my ($self, $param) = @_;
    return $self->error_count == 0 unless defined $param;
    return ! exists $self->{errors}{$param};
}

sub bad
{
    my ($self, $param) = @_;

    return ! $self->ok($param);
}

sub err
{
    my ($self, $param) = @_;

    return $self->{errors}{$param};
}

sub errors
{
    my $self = shift;
    my $limit = shift;

    my %is_dup;
    my @errors = grep { ! $is_dup{$_}++ } values %{ $self->{errors} };

    return @errors[ 0 .. $limit-1 ] if ( $limit && scalar @errors > $limit );

    return @errors;
}

sub error_count
{
    my $self = shift;
    return scalar $self->errors();
}

1;
