# Prophage Identification Analysis with VirSorter2 🦠

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
- [VirSorter2](https://github.com/jiarong/VirSorter2) installed and available in PATH
- Python 3.7+ (if required by VirSorter2 dependencies)
- Genome files in FASTA format


## ⚡ Usage
Run the main script as follows:

./start.sh run_virsorter <data_path> <output_path>

### Example 
./start.sh run_virsorter ./data ./output

### Note
Ensure that genome_name lists all genome filenames to be analyzed.
The genomes/ folder must contain the corresponding FASTA genome files.
Output will be organized in <output_path> with separate folders for each genome analysis.

### 🔗 Reference 
VirSorter2 GitHub (https://github.com/jiarong/VirSorter2) Official repository and documentation.
Roux et al., 2021. VirSorter2: a multi-classifier, expert-guided approach to detect diverse DNA and RNA viruses.
./start.sh run_virsorter <data_path> <output_path>

