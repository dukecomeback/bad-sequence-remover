# bad-sequence-remover
Removes spurious sequences from the input alignment.

I remove bad sequence from alignnment, so when with gap removed, you alignment won't end up with a null

The idea is basically from trimal(http://trimal.cgenomics.org/trimal), so its style is followed, except some changes to suit my master Kang's need. 

Usage: perl $0 -in <inputfile> -out <outputfile> (-resoverlap 0.75) (-seqoverlap 0.20) (-exp a,b,c)
  
	-in, FASTA needed
	-out, FASTA needed
	-resoverlap 0.75, for an alignment column, if more then 75% sites are not gap, then it's considered as a "good column". For a site of a sequence in the column, if it's a gap, then it's considered as a "bad site" for the sequence.
	-seqoverlap 0.20, for a sequence, if (bad sites / good columns) >=0.20, then it's considered as a "bad sequence" and removed.
	-exp a,b,c.., those sequences with a,b or c in its name would be free from this purge
  
Du Kang @ 2019-3-21
