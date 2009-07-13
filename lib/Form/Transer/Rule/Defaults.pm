package Form::Transer::Rule::Defaults;

use warnings;
use strict;
use utf8;

use Form::Transer::Rule::Book qw(alias decree STATE ARGS BYPASS);
use Regexp::Common;

decree set => sub { defined && length };

decree optional => sub {
    $_[BYPASS] = 1 unless ( defined && length );
    return 1;
};

decree boolean => sub { $_ eq '0' || $_ eq '1' };
alias 'bool' => 'boolean';

decree number => sub { Scalar::Util::looks_like_number($_) },
    requires  => 'Scalar::Util';

decree int    => qr/\A[-+]?\p{Number}+\z/;
decree uint   => qr/\A\p{Number}+\z/;
decree ascii  => qr/\A\p{AsciiHexDigit}+\z/;

alias opt => 'optional';

decree length => sub { length() >= $_[ARGS][0] && length() <= $_[ARGS][1] };

decree same   => sub {
    return ( $_[STATE]{prev} eq $_ ) if exists $_[STATE]{prev};
    $_[STATE]{prev} = $_;
    return 1;
};

decree email  => sub { Email::Valid->address($_) },
    requires  => 'Email::Valid';

decree regex  => sub { /$_[ARGS][0]/ };

decree usphone =>
    qr{ \A (?: \s* 1 \s* -? )? \s*             # optional 1-prefix
        [(]? \d{3} [)]? \s* -? \s*             # area code
        [A-Za-z\d]{3} \s* -? \s*               # 3-digit prefix
        [A-Za-z\d]{4} \s*                      # 4-digits
        (?: [eExXtT]{0,3} \s* \d{0,5} \s* )?   # extension
        \z }xms;

decree uszipcode => sub { /$RE{zip}{US}/ };
alias uszip => 'uszipcode';

# stolen from FormValidator::Lite, author's comments:
# this regexp is taken from http://www.din.or.jp/~ohzaki/perl.htm#httpURL
# thanks to ohzaki++
decree http_url => qr/^s?https?:\/\/[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+$/;

1;

