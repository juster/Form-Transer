package Form::Transer::Subject::Group;

use warnings;
use strict;

use Carp qw(croak);

sub new
{
    my $class = shift;

    my $name_vals = shift or
        croak 'Constructor must be passed name/value pairs';

    my @subjects;
    while ( my ($name, $value) = each %$name_vals ) {
        push @subjects, Form::Transer::Subject->new( $name, $value );
    }

    bless { subjects => \@subjects, logic => 'all' }, $class;
}

sub check_test
{
    my ($self, $test) = @_;

    my $passed = 0;

    printf STDERR "DEBUG: Running test for group %s\n",
        ( $self->{alias} ? $self->{alias} : "(unknown)" );

    my %errors;
    for my $subject ( @{$self->{subjects}} ) {
        my %test_errors = $subject->check_test( $test );
        if ( !%test_errors ) { ++$passed; }
        %errors = ( %errors, %test_errors );
    }

    return () if ( $self->{logic} eq 'any' && $passed > 0 );

    # If we have an alias for the group, also provide the
    # alias as a key to the error message.
    if ( $self->{alias} ) {
        my $error = Form::Transer::Error->new( $test->get_error );
        $error->set_name( $self->{alias} );
        return ( $self->{alias} => $error );
    }

    return %errors;
}

sub set_logic
{
    my $self = shift;
    $self->{logic} = shift;
}

sub set_alias
{
    my $self = shift;
    $self->{alias} = shift;
}

1;
