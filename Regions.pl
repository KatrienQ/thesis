#!/usr/bin/perl
use warnings;
use strict;

my $DEBUG = 0;

@ARGV == 1 or die "usage: $0 < fimo.txt >\n";
my ( $fimo) = @ARGV;

my @fimoResults = readFileToArray( $fimo );

# fimo.txt format
# pattern name     sequence name                          start   stop strand      score  p-value         q-value   matched sequence
# MA0494.1        chrX:152991526-152993399_hg19_2720.49_. 1008    1026    +       22.0968 7.17e-10        0.00188 TGACCTGGAGTAACCTTTC
# MA0494.1        chr10:24496237-24498236_hg19_3100_.     1434    1452    +       21.6774 1.89e-09        0.00248 TGACCTCGAGTGACCTGTG

my $count = 1;
print "chrom", "\t", "start", "\t", "end", "\t", "name", "\t", "score", "\t", "strand", "\n"; 
foreach my $result ( @fimoResults ) {
	my @record = split( /\t+/, $result );

	my @sequence_name = split(/[\-:_]+/, $record[2]);
	
	my $chrom = $sequence_name[0];
	my $begin = $sequence_name[1];
	my $end = $sequence_name[2];
	
	my $name = $record[ 1 ];
	my $startPosition = $record[ 3 ] - 1;
	my $stopPosition = $record[ 4 ];
	my $strand  = $record[ 5 ];
	my $score = $record[ 6 ];
	
	my $len = $stopPosition - $startPosition;
	
	if ( $strand eq "+" ) {
             my $first = $end - $stopPosition - 49 + $len;
			 my $last = $first + 99;
           print $chrom,"\t",$first,"\t",$last,"\t",$name,"\t",$score,"\t",$strand, "\n";
		}
	 else {
             my $first = $end - $stopPosition -50 +1;
			 my $last = $first + 99;
			print $chrom,"\t",$first,"\t",$last,"\t",$name,"\t",$score,"\t",$strand, "\n";
		}
}

#######################################################################
#
# readFileToArray
#

sub readFileToArray {
        my ($file) = @_;
        my @fileData = ();
        open( INFILE, $file ) or die ("Unable to open $file!\n");
        while (<INFILE>) {
               chomp();
               next if /^#/;
               push ( @fileData, $_ );
              }
        close(INFILE);
        return( @fileData );
}
