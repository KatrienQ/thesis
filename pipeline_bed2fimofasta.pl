#!/usr/bin/perl
use warnings;
use strict;

@ARGV == 1 or die "usage: $0 < TF (capital letters) >\n";
my ( $TF) = @ARGV;

my %code = (
    "ARID3A" => "MA0151.1",
    "ATF3" => "MA0605.1",
    "ATF7" => "MA0834.1",
    "CEBPB" => "MA0466.2",
    "CREB1" => "MA0018.3",
    "CTCF" => "MA0139.1",
    "E2F1" => "MA0024.3",
    "E2F6" => "MA0471.1",
    "EGR1" => "MA0162.3",
    "FOXA1" => "MA0148.3",
    "FOXA2" => "MA0047.2",
    "GABPA" => "MA0062.2",
    "GATA3" => "MA0037.3",
    "HNF4A" => "MA0114.3",
    "JUND" => "MA1141.1",
    "MAFK" => "MA0591.1",
    "MAX" => "MA0058.3",
    "MYC" => "MA0147.3",
    "REST" => "MA0138.2",
    "RFX5" => "MA0510.2",
    "SPI1" => "MA0080.4",
    "SRF" => "MA0083.3",
    "STAT3" => "MA0144.2",
    "TCF12" => "MA0521.1",
    "TCF7L2" => "MA0523.1",
    "TEAD4" => "MA0809.1",
    "YY1" => "MA0095.2",
    "ZNF143" => "MA0088.2"
    );

my @TF_files =`ls *${TF}.conservative.train.narrowPeak*`;
for my$narrowPeak (@TF_files)
{
    chomp $narrowPeak;
    my@information = split(/\./,$narrowPeak);
    my$code = $code{$TF};
    my$tissue = $information[1];
    (system("perl adjustBedSpecies.pl $narrowPeak hg19 > ChIPseq.${tissue}.${TF}.conservative.train.bed")==0)
        or die "executing adjustBedSpecies.pl on $narrowPeak failed";
    (system("perl bed2Fa_withcontext.pl ChIPseq.${tissue}.${TF}.conservative.train.bed 0 0 startend > ChIPseq.${tissue}.${TF}.conservative.train.fasta")==0)
        or die "executing bed2Fa_withcontext.pl on ChIPseq.${tissue}.${TF}.conservative.train.bed failed";
    (system("fimo --text JASPAR_CORE_2018/${code}.meme ChIPseq.${tissue}.${TF}.conservative.train.fasta > ChIPseq.${tissue}.${TF}.conservative.train.${code}.fimo")==0)
        or die "executing fimo on ChIPseq.${tissue}.${TF}.conservative.train.fasta failed";
    (system("perl extractExtendedMotiffromFimo.pl ChIPseq.${tissue}.${TF}.conservative.train.fasta ChIPseq.${tissue}.${TF}.conservative.train.${code}.fimo 50 50 > ChIPseq.${tissue}.${TF}.conservative.train.${code}.fimoextended.fasta")==0)
        or die "executing extractExtendedMotiffromFimo.pl on ChIPseq.${tissue}.${TF}.conservative.train.${code}.fimo failed";
    (system("perl Regions.pl ChIPseq.${tissue}.${TF}.conservative.train.${code}.fimo > ChIPseq.${tissue}.${TF}.conservative.train.${code}.fimoextended.fimo.regions")==0)
        or die "executing Region.pl on ChIPseq.${tissue}.${TF}.conservative.train.${code}.fimo failed";
}

#system("mv *.fimo.regions* fimo_regions/");
#system("mv *.fimoextended.fasta* fimo_extended/");
#system("mv *.fimo* fimo/");
#system("mv *.fasta* fasta/");
#system("mv *.bed* bed/");
#system("mv *.narrowPeak* narrowPeak/");
