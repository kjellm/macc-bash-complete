use warnings;
use strict;

use FindBin;
use lib $FindBin::Bin . '/lib';

use Test::More tests => 2;
use Test::Output qw(:functions);
use Test::Regression;
use TestApp;

my $app = TestApp->new;

#    use Data::Dumper qw(Dumper);
#     print STDERR Dumper sort $app->command_names;

is_deeply(
    [sort($app->command_names)],
    [qw(--help --version -? -h bashcomplete commands help testcommand version)],
    'Command names ok'
);

@ARGV = ('bashcomplete');

ok_regression(sub { stdout_from(sub { TestApp->run }) },
              "$FindBin::Bin/output.txt");
