package PerlIO::via::UnComment;

# Set the version info
# Make sure we do things by the book from now on

$VERSION = '0.03';
use strict;

# Satisfy -require-

1;

#-----------------------------------------------------------------------

# Subroutines for standard Perl features

#-----------------------------------------------------------------------
#  IN: 1 class to bless with
#      2 mode string (ignored)
#      3 file handle of PerlIO layer below (ignored)
# OUT: 1 blessed object

sub PUSHED { 

# Die now if strange mode
# Create the object

#    die "Can only read or write with removing comments" unless $_[1] =~ m#^[rw]$#;
    bless \*PUSHED,$_[0];
} #PUSHED

#-----------------------------------------------------------------------
#  IN: 1 instantiated object
#      2 handle to read from
# OUT: 1 processed string (if any)

sub FILL {

# Create local copy of $_
# While there are lines to be read from the handle
#  Return the line if it doesn't start with a '#'
# Return indicating end reached

    local( $_ );
    while (defined( $_ = readline( $_[1] ) )) {
        return $_ unless /^#/;
    }
    undef;
} #FILL

#-----------------------------------------------------------------------
#  IN: 1 instantiated object
#      2 buffer to be written
#      3 handle to write to
# OUT: 1 number of bytes written

sub WRITE {

# For all of the lines in this bunch (includes delimiter at end)
#  Reloop if it is a comment line
#  Print the line, return now if failed
# Return total number of octets handled

    foreach (split( m#(?<=$/)#,$_[1] )) {
	next if /^#/;
        return -1 unless print {$_[2]} $_;
    }
    length( $_[1] );
} #WRITE

#-----------------------------------------------------------------------

__END__

=head1 NAME

PerlIO::via::UnComment - PerlIO layer for removing comments

=head1 SYNOPSIS

 use PerlIO::via::UnComment;

 open( my $in,'<:via(UnComment)','file.pm' )
  or die "Can't open file.pm for reading: $!\n";
 
 open( my $out,'>:via(UnComment)','file.pm' )
  or die "Can't open file.pm for writing: $!\n";

=head1 DESCRIPTION

This module implements a PerlIO layer that removes comments (any lines that
start with '#') on input B<and> on output.  It is intended as a development
tool only, but may have uses outside of development.

=head1 EXAMPLES

Here are some examples, some may even be useful.

=head2 Source only filter, but with pod

A script that only lets uncommented source code and pod pass.

 #!/usr/bin/perl
 use PerlIO::via::UnComment;
 binmode( STDIN,':via(UnComment)' ); # could also be STDOUT
 print while <STDIN>;

=head2 Source only filter, even without pod

A script that only lets uncommented source code.

 #!/usr/bin/perl
 use PerlIO::via::UnComment;
 use PerlIO::via::UnPod;
 binmode( STDIN,':via(UnComment):via(UnPod)' ); # could also be STDOUT
 print while <STDIN>;

=head1 REQUIRED MODULES

 (none)

=head1 SEE ALSO

L<PerlIO::via>, L<PerlIO::via::UnPod> and any other PerlIO::via modules on CPAN.

=head1 COPYRIGHT

Copyright (c) 2002-2003 Elizabeth Mattijsen.  All rights reserved.  This
library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
