package Form::Transer;

use warnings;
use strict;

our $VERSION = '0.01';
use Form::Transer::Rule::Defaults;
use Form::Transer::Rule::Book qw(deploy);
use Form::Transer::Subject;
use Form::Transer::Subject::Group;
use Form::Transer::Report;
use Form::Transer::Error qw(caught_error);
use Form::Transer::Test;
use English qw(-no_match_vars);
use Carp qw(croak);

use Data::Dumper;

sub new
{
    my $class = shift;
    my ($input) = @_;
    bless { input => $input, subjects => [ ], values => {} }, $class;
}

# 'email' => q{ ascii email !err_email }
# [ qw/ email email2 / ] => q{ notdup }
sub check
{
    my $self = shift;

    if ( @_ == 0 && $self->profile ) {
        return $self->check( $self->profile );
    }

    croak q{Invalid test descriptions in %desc, does not seem to be a hash}
        unless @_ % 2 == 0;

    my $input  = $self->{input};
    my %errors;

    while ( my ($subject, $testdesc) = splice @_, 0, 2 ) {
        my $test    = $self->parse_test( $testdesc );
        my $subject = $self->parse_subject( $subject );

#        use Data::Dumper;
#        print Dumper($subject);
        %errors = ( %errors, $subject->check_test($test) );
    }

    return $self->{report} = Form::Transer::Report->new
        ( errors => \%errors, values => $self->{values} );
}

sub profile
{
    return ();
}

sub get_report
{
    my $self = shift;
    return $self->{report};
}

sub parse_subject
{
    my ($self, $subject) = @_;

    my $input = $self->{input};

    if ( ref $subject eq 'ARRAY' ) {
        my @subjects;
        my %options;

        TOKEN_SEARCH:
        while ( my $name = shift @$subject ) {
            if ( $name =~ /%+/ ) {
                $options{logic} = 'any';
                next TOKEN_SEARCH;
            }
            if ( $name =~ /\A"([^"]+)"\z/ ) {
                $options{alias} = $1;
                next TOKEN_SEARCH;
            }
            push @subjects, $name;
        }

        my $name_vals;
        for my $subject ( @subjects ) {
            $name_vals->{$subject} = $input->param($subject);
            $self->{values}{$subject} = $input->param($subject);
        }

        print STDERR "\$name_vals = ", Dumper($name_vals), "\n";

        my $group = Form::Transer::Subject::Group->new( $name_vals );
        $group->set_logic( $options{logic} ) if ( $options{logic} );
        $group->set_alias( $options{alias} ) if ( $options{alias} );

        return $group;
    }
    elsif ( ! ref $subject ) {
        $self->{values}{$subject} = $input->param( $subject );
        return Form::Transer::Subject->new( $subject, $input->param($subject) );
    }
    else {
        die "Unknown subject type provided";
    }

    return;
}

sub parse_test
{
    my ($self, $testdesc) = @_;

    my ($desc, @errors) = split /\s*#/, $testdesc;
    my ($error) = join '', @errors;
    $error =~ s/\n\s*//;
    $error =~ s/\A\s+//;

    my @rules = map { deploy($_) } grep { $_ ne 'set' } map { lc } grep { length }
        split /[\s;|]+/, $desc;
    unshift @rules, deploy('set');

    my $test = Form::Transer::Test->new( [ @rules ], $error );
    return $test;
}

1;

__END__

=head1 NAME

Form::Transer - Trans[lates/fers] form data between models and checks for errors

=cut
