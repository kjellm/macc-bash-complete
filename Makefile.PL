use inc::Module::Install;

name     'MooseX-App-Cmd-Command-BashComplete';
all_from 'lib/MooseX/App/Cmd/Command/BashComplete.pm';
author   q{Kjell-Magne Øierud <kjellm@acm.org>};
license  'perl';

build_requires 'Test::More';

requires 'MooseX::App::Cmd';

auto_install;

WriteAll;

