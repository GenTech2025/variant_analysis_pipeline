#!/bin/bash

# Download Dataset from ENA
# Downloads paired-end FASTQ files from NCBI SRA project PRJNA434021

# Set directories
RAW_DATA_DIR="../../raw_data"

# Create output directory if it doesn't exist
mkdir -p "$RAW_DATA_DIR"

# Change to raw_data directory
cd "$RAW_DATA_DIR"

echo "Downloading FASTQ files from ENA..."

# Download all FASTQ files (paired-end reads)
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR672/003/SRR6728143/SRR6728143_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR672/003/SRR6728143/SRR6728143_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR672/004/SRR6728144/SRR6728144_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR672/004/SRR6728144/SRR6728144_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR672/005/SRR6728145/SRR6728145_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR672/005/SRR6728145/SRR6728145_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR672/006/SRR6728146/SRR6728146_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR672/006/SRR6728146/SRR6728146_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR672/007/SRR6728147/SRR6728147_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR672/007/SRR6728147/SRR6728147_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR672/008/SRR6728148/SRR6728148_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR672/008/SRR6728148/SRR6728148_2.fastq.gz

echo "Download complete. Files saved to $RAW_DATA_DIR"
