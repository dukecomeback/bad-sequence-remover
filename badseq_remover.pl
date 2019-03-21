#!/usr/bin/perl -w

my $usage=<<EOF;
--------------------------------
I remove bad sequence from alignnment, so when with gap removed, you alignment won't end up with a null

The idea is basically from trimal(http://trimal.cgenomics.org/trimal), so its style is followed, except some changes to suit my master Kang's need. 

Usage: perl $0 -in <inputfile> -out <outputfile> (-resoverlap 0.75) (-seqoverlap 0.20) (-exp a,b,c)

	-in, FASTA needed
	-out, FASTA needed
	-resoverlap 0.75, for an alignment column, if more then 75% sites are not gap, then it's considered as a "good column". For a site of a sequence in the column, if it's a gap, then it's considered as a "bad site" for the sequence.
	-seqoverlap 0.20, for a sequence, if (bad sites / good columns) >=0.20, then it's considered as a "bad sequence" and removed.
	-exp a,b,c.., those sequences with a,b or c in its name would be free from this purge

										                                            Du Kang 2019-3-21
--------------------------------
EOF
# about how to use the script

@ARGV or die $usage;

$resoverlap=0.75;
$seqoverlap=0.20;
foreach $i (0..@ARGV-1) {
	$in=$ARGV[$i+1] if $ARGV[$i] eq "-in";
	$out=$ARGV[$i+1] if $ARGV[$i] eq "-out";
    	$resoverlap=$ARGV[$i+1] if $ARGV[$i] eq "-resoverlap";
    	$seqoverlap=$ARGV[$i+1] if $ARGV[$i] eq "-seqoverlap";
    	$exp=$ARGV[$i+1] if $ARGV[$i] eq "-exp";
} 

$in or die $usage;
$out or die $usage;
unlink $out and print "output file $out already exists, now removed\n" if -e $out;
# set parameters


open IN, $in or die $!;
while (<IN>) {
	chomp;
	if (/>/) {
		$name=$_;
	}else{
		$seq{$name}.=$_;
	}
}
close IN;

# count non-gaps for each column
$seqnum=0;
foreach $key (keys %seq){
	$seqnum++;
	$badsite{$key}=0;

	$l=length $seq{$key};
	foreach $i (0..$l-1){
		$res{$i}++ if substr($seq{$key}, $i, 1) ne "-";
	}
}

# count good column number for the alignment, and bad site number for each sequence
foreach $key (keys %seq){
	foreach $i (0..$l-1){
		$goodcol{$i} = 1 if $res{$i}/$seqnum >$resoverlap;
		$badsite{$key}++ if substr($seq{$key}, $i, 1) eq "-" and exists $goodcol{$i};
	}
}
$goodcolnum=keys %goodcol;

# remove bad sequence, output "good sequence"
$exp=~s/,/\|/g;
open OUT, ">>$out" or die $!;
foreach $key (keys %seq){
#	print "$key\t$l\t$goodcolnum\t$badsite{$key}\n";
	print OUT "$key\n$seq{$key}\n" if $badsite{$key}/$goodcolnum <$seqoverlap or $key=~/$exp/;
}
close OUT;
