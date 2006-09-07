#!/usr/bin/perl -w
# chnam - change the names of files
#
# The chnam tool is almost identical to Robin Barker's rename tool.
# It was renamed from rename to chnam because Linux has a less useful
# rename utility.
#
#  This script was developed by Robin Barker (Robin.Barker@npl.co.uk),
#  from Larry Wall's original script eg/rename from the perl source.
#
#  This script is free software; you can redistribute it and/or modify it
#  under the same terms as Perl itself.
#
# Larry(?)'s RCS header:
#  RCSfile: rename,v   Revision: 4.1   Date: 92/08/07 17:20:30 
#
# Robin Barker RCS hrader:
# RCSfile: rename,v Revision: 1.5 $$Date: 1998/12/18 16:16:31
#
# Log: rename,v 
# Revision 1.5  1998/12/18 16:16:31  rmb1
# moved to perl/source
# changed man documentation to POD
#
# Revision 1.4  1997/02/27  17:19:26  rmb1
# corrected usage string
#
# Revision 1.3  1997/02/27  16:39:07  rmb1
# added -v
#
# Revision 1.2  1997/02/27  16:15:40  rmb1
# *** empty log message ***
#
# Revision 1.1  1997/02/27  15:48:51  rmb1
# Initial revision
#

use strict;

use Getopt::Long;
Getopt::Long::Configure('bundling');

my ($verbose, $no_act, $force, $op);

die "Usage: chnam [-v] [-n] [-f] perlexpr [filenames]\n"
    unless GetOptions(
	'v|verbose' => \$verbose,
	'n|no-act'  => \$no_act,
	'f|force'   => \$force,
    ) and $op = shift;

$verbose++ if $no_act;

if (!@ARGV) {
    print "reading filenames from STDIN\n" if $verbose;
    @ARGV = <STDIN>;
    chop(@ARGV);
}

for (@ARGV) {
    my $was = $_;
    eval $op;
    die $@ if $@;
    next if $was eq $_; # ignore quietly
    if (-e $_ and !$force)
    {
	warn  "$0: $was not renamed: $_ already exists\n";
    }
    elsif ($no_act or rename $was, $_)
    {
	print "$0: $was renamed as $_\n" if $verbose;
    }
    else
    {
	warn  "$0: Can't rename $was $_: $!\n";
    }
}

__END__

=head1 NAME

chnam - change the filenames of multiple files

=head1 SYNOPSIS

B<chnam> S<[ B<-v> ]> S<[ B<-n> ]> S<[ B<-f> ]> I<perlexpr> S<[ I<files> ]>

=head1 DESCRIPTION

C<chnam>
Changes the filenames supplied according to the rule specified as the
first argument.
The I<perlexpr> 
argument is a Perl expression which is expected to modify the C<$_>
string in Perl for at least some of the filenames specified.
If a given filename is not modified by the expression, it will not be
renamed.
If no filenames are given on the command line, filenames will be read
via standard input.

For example, to change all files matching C<*.bak> to strip the extension,
you might say

	chnam 's/\.bak$//' *.bak

To translate uppercase names to lower, you'd use

	chnam 'y/A-Z/a-z/' *

=head1 OPTIONS

=over 8

=item B<-v>, B<--verbose>

Verbose: print names of files successfully renamed.

=item B<-n>, B<--no-act>

No Action: show what files would have been renamed.

=item B<-f>, B<--force>

Force: overwrite existing files.

=back

=head1 ENVIRONMENT

No environment variables are used.

=head1 AUTHOR

Larry Wall

=head1 SEE ALSO

mv(1), perl(1)

=head1 DIAGNOSTICS

If you give an invalid Perl expression you'll get a syntax error.

=head1 BUGS

The original Larry Wall C<rename> did not check for the existence of 
target filenames, so had to be used with care.  Robin Barker fixed that.
Linux already had a rename utility so this tool was renamed to C<chnam>.

=cut
