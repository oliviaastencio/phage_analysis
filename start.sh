#! /usr/bin/env bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=1-00:00:00
#SBATCH --constraint=cal
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out


data=$2
output=$3

mkdir -p $output 


##########################################
############Virsorter#############

if [ "$1" == "run_virsorter" ]; then

	while read -r genome
	do
		mkdir -p $output/$genome/Virsorter
		mkdir -p $output/$genome/Virsorter/test1 
		mkdir -p $output/$genome/Virsorter/test2
		
		module load virsorter/2.2.4
		virsorter run -w  $output/$genome/Virsorter/ -i $data/genomes/$genome  --min-length 1500 -j 4 all
	done < $data/genome_name
fi

if [ "$1" == "run_check" ]; then

	while read -r genome
	do
		
		module load checkm/1.1.3
		module load dram/1.4.6
		mkdir -p $output/$genome/checkV
		checkv end_to_end vs2-pass1/final-viral-combined.fa checkv -t 28 -d /fs/project/PAS1117/jiarong/db/checkv-db-v1.0
		cat checkv/proviruses.fna checkv/viruses.fna > checkv/combined.fna
		virsorter run --seqname-suffix-off --viral-gene-enrich-off --provirus-off --prep-for-dramv -i checkv/combined.fna -w vs2-pass2 --include-groups dsDNAphage,ssDNA --min-length 5000 --min-score 0.5 -j 28 all
		# step 1 annotate
		DRAM-v.py annotate -i vs2-pass2/for-dramv/final-viral-combined-for-dramv.fa -v vs2-pass2/for-dramv/viral-affi-contigs-for-dramv.tab -o dramv-annotate --skip_trnascan --threads 28 --min_contig_size 1000
		#step 2 summarize anntotations
		DRAM-v.py distill -i dramv-annotate/annotations.tsv -o dramv-distill

	done < $data/genome_name
fi


if [ "$1" == "syntenic" ]; then

mkdir $output/Sibelia
export PATH=/mnt/home/users/pab_001_uma/oliastencio/software/Sibelia/bin/ 
module load circos
PATH=~soft_bio_267/programs/x86_64/scripts/:$PATH

while read -r genome
do 
	mkdir -p $output/Sibelia/$genome
	Sibelia -m 2000 -s fine other_phage_shewanella/Shewanella_Pdp11.fasta/final-viral-combined.fa  other_phage_shewanella/$genome/final-viral-combined.fa -o $output/Sibelia/$genome
	cd $output/Sibelia/$genome/circos
	circos -conf circos.conf -debug_group summary,timer -param image/radius=1500p > run.out 
	cd ../../../..
done < $data/genome_name

fi