use warnings;
use strict;

use FindBin;
use lib $FindBin::Bin . '/lib';

use Test::More tests => 2;
use Test::Output qw(:functions);
use TestApp;

my $app = TestApp->new;

is_deeply(
    [sort($app->command_names)],
    [qw(--help -? -h bashcomplete commands help testcommand)],
    'Command names ok'
);

@ARGV = ('bashcomplete');

my $stdout = stdout_from(sub { TestApp->run });
$stdout =~ s/\s+/ /g;

my $expected = q{#!/bin/bash

# Built with MooseX::App::Cmd::Command::BashComplete;

COMMANDS='help commands complete bashcomplete testcommand'

_macc_help() {
    if [ $COMP_CWORD = 2 ]; then
        _compreply "$GLOBAL_COMMANDS $COMMANDS"
    else
        COMPREPLY=()
    fi
}

_macc_commands() {
    COMPREPLY=()
}


_macc_bashcomplete() {
    COMPREPLY=()
}


_macc_bashcomplete() {
    _compreply ""
}

_macc_testcommand() {
    _compreply "--foo"
}


_compreply() {
    COMPREPLY=($(compgen -W "$1" -- ${COMP_WORDS[COMP_CWORD]}))
}


_macc() {
    case $COMP_CWORD in
        0)
            ;;
        1)
            _compreply "$GLOBAL_COMMANDS $COMMANDS"
            ;;
        *)
            eval _tvgu_${COMP_WORDS[1]}

    esac
}


complete -o default -F _macc macc

};

$expected =~ s/\s+/ /g;

is($stdout, $expected, "Shell script ok");
