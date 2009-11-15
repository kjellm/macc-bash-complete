use warnings;
use strict;

use FindBin;
use lib $FindBin::Bin . '/lib';

use Test::More tests => 2;
use TestApp;

my $app = TestApp->new;

is($app->default_command, 'help', 'Help is default');
is_deeply(
    [sort($app->command_names)],
    [qw(--help -? -h bashcomplete commands help)],
    'Command names ok'
);
