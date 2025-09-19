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
		
		module load virsorter/2.2.4
		virsorter run -w  $output/$genome/Virsorter/ -i $data/genomes/$genome  --min-length 1500 -j 4 all
	done < $data/genome_name
fi

if [ "$1" == "run_check" ]; then

	while read -r genome
	do
		export PATH=$PATH:/mnt/home/users/pab_001_uma/oliastencio/software/Prodigal-gv
		module load diamond/2.1.8
		module load prodigal/2.6.3_gcc11
		module load hmmer/3.3.2
		module load checkm/1.1.3

		mkdir -p $output/$genome/checkV
		checkv end_to_end $output/$genome/Virsorter/final-viral-combined.fa $output/$genome/checkV -t 28 -d checkv-db-v1.5
		cat $output/$genome/checkV/proviruses.fna $output/$genome/checkV/viruses.fna > $output/$genome/checkV/combined.fna
		
	done < $data/genome_name
fi

if [ "$1" == "run_virsorter_2" ]; then

	while read -r genome
	do
		module load virsorter/2.2.4

		virsorter run --seqname-suffix-off --viral-gene-enrich-off --provirus-off --prep-for-dramv -i $output/$genome/checkV/combined.fna -w $output/$genome/vs2-pass2 --include-groups dsDNAphage,ssDNA --min-length 5000 --min-score 0.5 -j 28 all
		
	done < $data/genome_name
fi

if [ "$1" == "run_dram" ]; then

	while read -r genome
	do
		
		module load dram/1.4.6
		#step 1 annotate
		DRAM-v.py annotate -i $output/$genome/vs2-pass2/for-dramv/final-viral-combined-for-dramv.fa -v $output/$genome/vs2-pass2/for-dramv/viral-affi-contigs-for-dramv.tab -o $output/$genome/dramv-annotate --skip_trnascan --threads 28 --min_contig_size 1000
		#step 2 summarize anntotations
		DRAM-v.py distill -i $output/$genome/dramv-annotate/annotations.tsv -o $output/$genome/dramv-annotate/dramv-distill
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
	Sibelia -m 2000 -s fine $output/Shewanella_Pdp11.fasta/vs2-pass2/final-viral-combined.fa  $output/$genome/vs2-pass2/final-viral-combined.fa -o $output/Sibelia/$genome
	cd $output/Sibelia/$genome/circos
	circos -conf circos.conf -debug_group summary,timer -param image/radius=1500p > run.out 
	cd ../../../..
done < $data/genome_name

fi