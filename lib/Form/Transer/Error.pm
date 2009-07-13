package Form::Transer::Error;

use warnings;
use strict;

use base         qw(Exporter);
use English      qw(-no_match_vars);
use Carp         qw(croak);
use overload      q{""} => \&stringify;
use Scalar::Util qw(blessed);

our @EXPORT    = qw();
our @EXPORT_OK = qw(throw caught_error);

our %_TAG_OF_CLASS = ( 'Form::Transer::Test'    => 'test',
                       'Form::Transer::Subject' => 'subject' );

sub throw
{
    croak q{Invalid arguments to Form::Transer::Error::throw() function}
        unless @_ == 1;

    my ($errormsg) = @_;
    my $self = bless { error => $errormsg }, __PACKAGE__;
    die $self;
}

sub caught_error
{
    return blessed($@) && $@->isa(__PACKAGE__);
}

#----------------------------------------------------------------------
# PUBLIC METHODS
#----------------------------------------------------------------------

sub new
{
    my $class = shift;
    return bless { error => shift() }, $class;
}

sub rethrow
{
    my $self = shift;
    die $self;
}

sub set_error
{
    my ($self, $errormsg) = @_;

    return $self unless ( $errormsg );

#     my $i = 0;
#     my ($class) = caller until ( $class != __PACKAGE__ );

#     croak qq{Attempted to add an error from unknown class "$class"}
#         unless exists $_TAG_OF_CLASS{$class};

#     $tag = $_TAG_OF_CLASS{$class};
#     push @$self, $tag, $errormsg;

    push @$self, $errormsg;
    return $self;
}

sub set_name
{
    my $self = shift;
    return $self->{name} = shift;
}

sub get_name
{
    my $self = shift;
    return $self->{name};
}

sub set_value
{
    my $self = shift;
    return $self->{value} = shift;
}

sub get_value
{
    my $self = shift;
    return $self->{value};
}

sub stringify
{
    my $self = shift;
    return $self->{error};
}

1;
