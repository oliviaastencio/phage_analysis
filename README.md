# Prophage Identification Analysis with VirSorter2 🦠 and Syntenic block analysis 

[![Bash Script](https://img.shields.io/badge/bash-script-blue?logo=gnu-bash)](https://www.gnu.org/software/bash/)
[![VirSorter2](https://img.shields.io/badge/VirSorter2-ready-success)](https://github.com/jiarong/VirSorter2)

This repository provides **bash scripts** for prophage identification in bacterial genomes using **[VirSorter2](https://github.com/jiarong/VirSorter2)**. It automates the analysis of multiple genomes in **FASTA** format.

## 🚀 Features

- Automates prophage detection with VirSorter2.
- Supports batch processing of multiple genomes.
- Organizes results in a clear output folder structure.

## 📂 Repository Structure

├── start.sh # Main bash script to run analyses
├── data/ # Input data folder
│ ├── genome_name # Text file listing genomes to be analyzed
│ └── genomes/ # FASTA files of genomes
└── output/ # Folder where analysis results will be saved


## 🛠 Requirements

- Bash (Linux/macOS)
- VirSorter2 ≥ v2.2.4
- CheckV
- DRAM-v ≥ v1.4.6
- Sibelia
- Circos for visualization
- Python 3.7+ (required by VirSorter2 and DRAM-v)
- Diamond, Prodigal, HMMER modules available
- Genome files in FASTA format


## ⚡ Usage

#1️⃣ Run VirSorter2 (first pass)
./start.sh run_virsorter <data_path> <output_path>


Detects prophages in bacterial genomes.

Creates a separate folder for each genome: output/<genome>/Virsorter. Minimum contig length: 1500 bp. Parallelized with -j 4.

Example:

./start.sh run_virsorter data/ results/

#2️⃣ Quality control with CheckV
./start.sh run_check <data_path> <output_path>


Uses CheckV to evaluate the quality of identified viral sequences. Merges proviruses.fna and viruses.fna into combined.fna. Requires modules: Prodigal, Diamond, HMMER, CheckM.

Example:

./start.sh run_check data/ results/

3️⃣ Run VirSorter2 (second pass, prep for DRAM-v)
./start.sh run_virsorter_2 <data_path> <output_path>


Uses combined.fna from CheckV as input. Options: disables seqname-suffix, viral-gene-enrich, and provirus. Prepares sequences for DRAM-v annotation. Includes groups: dsDNAphage, ssDNA.

Minimum contig length: 5000 bp; minimum score: 0.5.

4️⃣ Annotate with DRAM-v
./start.sh run_dram <data_path> <output_path>


Step 1: Annotate sequences with DRAM-v.py annotate.Step 2: Summarize annotations with DRAM-v.py distill. Minimum contig size: 1000 bp. Threads: 28.

5️⃣ Syntenic block analysis with Sibelia & Circos
./start.sh syntenic <data_path> <output_path>


Generates syntenic blocks among viral sequences.Visualizes results with Circos. Requires Sibelia in PATH and Circos module loaded.

Example:

./start.sh syntenic data/ results/

### Note
Ensure that genome_name lists all genome filenames to be analyzed.
The genomes/ folder must contain the corresponding FASTA genome files.
Output will be organized in <output_path> with separate folders for each genome analysis.

### 🔗 Reference 
VirSorter2 GitHub (https://github.com/jiarong/VirSorter2) Official repository and documentation.
Roux et al., 2021. VirSorter2: a multi-classifier, expert-guided approach to detect diverse DNA and RNA viruses.
./start.sh run_virsorter <data_path> <output_path>

