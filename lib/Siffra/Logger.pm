package Siffra::Logger;

use 5.014;
use strict;
use warnings;
use utf8;

$| = 1;    #autoflush

BEGIN
{
    use Exporter ();
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    $VERSION = '0.01';
    @ISA     = qw(Exporter);

    #Give a hoot don't pollute, do not export more than needed by default
    @EXPORT      = qw();
    @EXPORT_OK   = qw();
    %EXPORT_TAGS = ();
} ## end BEGIN

BEGIN
{
    use Log::Any::Adapter;
    use Log::Dispatch;
    use File::Basename;
    use Data::Dumper;
    use POSIX qw/strftime/;

    binmode( STDOUT, ":encoding(UTF-8)" );
    binmode( STDERR, ":encoding(UTF-8)" );
    $ENV{ LC_ALL } = $ENV{ LANG } = 'pt_BR.UTF-8';

    my ( $filename, $baseDirectory, $suffix ) = fileparse( $0, qr/\.[^.]*/ );
    my $logDirectory = $baseDirectory . 'logs/';
    my $logFilename  = $filename . '.log';
    croak( "Unable to create $logDirectory" ) unless ( -e $logDirectory or mkdir $logDirectory );

    my $dispatcher = Log::Dispatch->new(
        outputs => [
            [
                'Screen',
                name      => 'screen',
                min_level => 'debug',
                max_level => 'warning',
                newline   => 1,
                utf8      => 0,
                stderr    => 0,
                use_color => 1,
            ],
            [
                'Screen',
                name      => 'screen-error',
                min_level => 'error',
                newline   => 1,
                utf8      => 0,
                stderr    => 1,
                use_color => 1,
            ],
            [
                'File',
                name      => 'file-01',
                filename  => $logDirectory . $logFilename,
                min_level => 'debug',
                newline   => 1,
                mode      => 'write',
                binmode   => ':encoding(UTF-8)',
            ]
        ],
        callbacks => [
            sub {
                my %msg = @_;
                my $i   = 0;
                my @array_caller;
                my ( $package, $filename, $line, $subroutine, $hasargs, $wantarray, $evaltext, $is_require, $hints, $bitmask, $hinthash );

                do
                {
                    ( $package, $filename, $line, $subroutine, $hasargs, $wantarray, $evaltext, $is_require, $hints, $bitmask, $hinthash ) = caller( $i++ );

                    my $auxiliar = {
                        package    => $package,
                        filename   => $filename,
                        line       => $line,
                        subroutine => $subroutine,
                    };

                    push( @array_caller, $auxiliar );
                } until ( !defined $line or $line == 0 or $subroutine =~ /(eval)/ );

                my $mensage = sprintf( "%s [ %9.9s ] [ pid: %d ] - %s - [ %s ]", strftime( "%F %H:%M:%S", localtime ), uc( $msg{ level } ), $$, $msg{ message }, $array_caller[ -2 ]->{ subroutine } );

                return $mensage;
            }
        ]
    );

    Log::Any::Adapter->set( 'Dispatch', dispatcher => $dispatcher );
} ## end BEGIN

#################### main pod documentation begin ###################
## Below is the stub of documentation for your module.
## You better edit it!

=encoding UTF-8


=head1 NAME

Siffra::Logger - Siffra config for Log::Any

=head1 SYNOPSIS

  use Siffra::Logger;
  blah blah blah


=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.


=head1 USAGE



=head1 BUGS



=head1 SUPPORT



=head1 AUTHOR

    Luiz Benevenuto
    CPAN ID: LUIZBENE
    Siffra TI
    luiz@siffra.com.br
    https://siffra.com.br

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

perl(1).
 
=cut

#################### main pod documentation end ###################

1;

# The preceding line will help the module return a true value

