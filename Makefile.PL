require 5.008;
use Config;
use ExtUtils::MakeMaker;

warn <<EOD unless $Config{useperlio};
    *** WHOA THERE!!! ***
    This is not a perlio-enabled perl !

    This module will not function with this perl !
EOD

WriteMakefile (
 NAME		=> "PerlIO::via::UnComment",
 ($[ >= 5.005) ?
 (AUTHOR	=> 'Elizabeth Mattijsen (liz@dijkmat.nl)',
  ABSTRACT	=> 'PerlIO Layer for removing comments') : (),
 VERSION_FROM	=> 'lib/PerlIO/via/UnComment.pm',
 PREREQ_PM	=> {
                   },
);
