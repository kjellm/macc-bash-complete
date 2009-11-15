package MooseX::App::Cmd::Command::BashComplete;

use warnings;
use strict;


our $VERSION = '0.01';


sub execute {
    my ($self, $opts, $args) = @_;

    print <<'EOT';
#!/bin/bash

# Built with MooseX::App::Cmd::Command::BashComplete;

GLOBAL_COMMANDS='help commands complete'

EOT

    my @commands = $self->app->command_names;

    my %command_map = ();

    for my $cmd (@commands) {
        next if any { $cmd eq $_ } qw(complete -h --help -? help commands);
        my $plugin = $self->app->plugin_for($cmd);

        $command_map{$cmd} = [$plugin->_attrs_to_options()];

    }

    my $cmd_list = join ' ', keys %command_map;

    print <<"EOT";

COMMANDS='$cmd_list'

_tvgu_help() {
    if [ \$COMP_CWORD = 2 ]; then
        _compreply "\$GLOBAL_COMMANDS \$COMMANDS"
    else
        COMPREPLY=()
    fi
}


_tvgu_commands() {
    COMPREPLY=()
}


_tvgu_complete() {
    COMPREPLY=()
}


EOT


    while (my ($c, $o) = each %command_map) {
        print "_tvgu_$c() {\n    _compreply \"",
            join(" ", map {"--" . $_->{name}} @$o),
                "\"\n}\n\n";
    }


print <<'EOT';
_compreply() {
    COMPREPLY=($(compgen -W "$1" -- ${COMP_WORDS[COMP_CWORD]}))
}


_startsiden_tvguide() {
    local current previous completions
    
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


complete -o default -F _startsiden_tvguide startsiden_tvguide

EOT

}


1;
__END__

=head1 NAME

MooseX::App::Cmd::Command::BashComplete - The great new MooseX::App::Cmd::Command::BashComplete!

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use MooseX::App::Cmd::Command::BashComplete;

    my $foo = MooseX::App::Cmd::Command::BashComplete->new();
    ...

=head1 AUTHOR

Kjell-Magne Øierud, C<< <kjellm at acm.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-app-cmd-command-bashcomplete at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-App-Cmd-Command-BashComplete>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::App::Cmd::Command::BashComplete


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-App-Cmd-Command-BashComplete>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-App-Cmd-Command-BashComplete>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-App-Cmd-Command-BashComplete>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-App-Cmd-Command-BashComplete/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Kjell-Magne Øierud.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
