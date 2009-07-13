package Form::Transer::Rule::Book;

use warnings;
use strict;

use base qw(Exporter);
use Carp qw(croak);

use Form::Transer::Rule;
use Form::Transer::Test qw(:constants);

our @EXPORT;
our @EXPORT_OK = qw(alias decree deploy STATE ARGS BYPASS);
our %EXPORT_TAGS = ( all       => [ @EXPORT_OK ],
                     constants => [ qw/ STATE ARGS BYPASS / ] );
our %_RULE_BOOK;

sub decree
{
    my ($name, $test, %rule_opts) = @_;

    $name = lc $name;

    croak qq{A rule named "$name" already exists}
        if ( exists $_RULE_BOOK{$name} );

    croak q{Invalid test specification}
        unless defined $test;

    croak q{$test can only be a compiled regex (with qr//) or a code ref}
        if ( ref $test ne 'CODE' && ref $test ne 'Regexp' );

    if ( ref $test eq 'Regexp' ) {
        $test = _make_regexp_code($test);
    }

    return $_RULE_BOOK{$name} = Form::Transer::Rule->new($test, %rule_opts);
}

sub alias
{
    my ($from, $to) = @_;

    croak qq{A rule named "$to" does not exist}
        unless exists $_RULE_BOOK{$to};

    croak qq{A rule named "$from" does not exist}
        if exists $_RULE_BOOK{$from};

    $_RULE_BOOK{$from} = $_RULE_BOOK{$to};
}

sub _make_regexp_code
{
    my $regexp = shift;
    return sub { /$regexp/ };
}

sub deploy
{
    my $rule_name = shift;
    my $rule = $_RULE_BOOK{$rule_name}
        or croak qq{A rule named "$rule_name" does not exist};

    my $new_rule = $rule->clone;
    $new_rule->set_config( [ @_ ] );
    return $new_rule;
}

1;

__END__

=head1 NAME

Form::Transer::Optimus - Optimus Prime, a just autobot, keeps the rules.

=cut
