use inc::Module::Install;

name     'MooseX-App-Cmd-Command-BashComplete';
all_from 'lib/MooseX/App/Cmd/Command/BashComplete.pm';
author   q{Kjell-Magne Øierud <kjellm@acm.org>};
license  'perl';

requires 'Moose';
requires 'MooseX::App::Cmd' => '0.06';

test_requires 'Test::More';
test_requires 'Test::Output';
test_requires 'Test::Regression';

auto_install;

WriteAll;

