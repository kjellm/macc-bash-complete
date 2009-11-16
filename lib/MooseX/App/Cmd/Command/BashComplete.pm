package MooseX::App::Cmd::Command::BashComplete;
use Moose;
extends 'MooseX::App::Cmd::Command';

our $VERSION = '0.01';

use List::MoreUtils qw(any none);
use MooseX::Getopt;

sub execute {
    my ($self, $opts, $args) = @_;

    my @commands = $self->app->command_names;

    my %command_map = ();

    for my $cmd (@commands) {
        next if any { $cmd eq $_ } qw(complete -h --help -? help commands);
        my $plugin = $self->app->plugin_for($cmd);

        $command_map{$cmd} = [$plugin->_attrs_to_options()];

    }

    my $cmd_list = join ' ', keys %command_map;

    my $package = __PACKAGE__;

    print <<"EOT";
#!/bin/bash

# Built with $package;

COMMANDS='help commands complete $cmd_list'

_macc_help() {
    if [ \$COMP_CWORD = 2 ]; then
        _compreply "\$COMMANDS"
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


EOT

    while (my ($c, $o) = each %command_map) {
        print "_macc_$c() {\n    _compreply \"",
            join(" ", map {"--" . $_->{name}} @$o),
                "\"\n}\n\n";
    }


print <<'EOT';

_compreply() {
    COMPREPLY=($(compgen -W "$1" -- ${COMP_WORDS[COMP_CWORD]}))
}


_macc() {
    case $COMP_CWORD in
        0)
            ;;
        1)
            _compreply "$COMMANDS"
            ;;
        *)
            eval _tvgu_${COMP_WORDS[1]}
            
    esac
}


complete -o default -F _macc macc

EOT

}


1;
__END__

=head1 NAME

MooseX::App::Cmd::Command::BashComplete - Bash completion for your MooseX::App::Cmd programs.


=head1 VERSION

Version 0.01


=head1 SYNOPSIS

 package MyApp::Command::BashComplete;
 use Moose;
 extends 'MooseX::App::Cmd::Command::BashComplete';

 ...

 bash> myapp bashcomplete > myapp-complete.sh
 bash> source myapp-complete.sh

=head1 AUTHOR

Kjell-Magne Øierud, C<< <kjellm at acm.org> >>


=head1 BUGS

Please report any bugs or feature requests to
C<bug-moosex-app-cmd-command-bashcomplete at rt.cpan.org>, or through
the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-App-Cmd-Command-BashComplete>.
I will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.


=head1 COPYRIGHT & LICENSE

Copyright 2009 Kjell-Magne Øierud.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
