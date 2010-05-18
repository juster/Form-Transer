package Form::Transer::Subject;

use warnings;
use strict;

use Form::Transer::Error qw(caught_error);

use English qw(-no_match_vars);
use Carp qw(croak);

sub new
{
    my $class = shift;
    my ($name, $value) = @_;
    return bless { name => $name, value => $value }, $class;
}

sub check_test
{
    my ($self, $test) = @_;

    my %errors;

#     printf STDERR "DEBUG: Running test for $self->{name}=%s\n",
#         ( defined $self->{value} ? $self->{value} : 'UNDEF' );

    eval {
        $test->conduct( $self->{value} );
    };
    if ( $EVAL_ERROR ) {
        # don't append file and line number
        die "Error while checking test subjects:\n$EVAL_ERROR\n"
            unless caught_error();

        my $err = $EVAL_ERROR;
        $err->set_name( $self->{name} );
        $err->set_value( $self->{value} );
        $errors{ $self->{name} } = $err;
    }

    return %errors;
}

1;
