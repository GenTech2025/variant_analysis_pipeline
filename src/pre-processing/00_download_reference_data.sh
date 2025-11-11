#!/bin/bash

# Download Yeast (R64-1-1) Reference Genome and Annotation files from Ensembefungi

# Set directories
REF_DATA_DIR = "../../raw_data/reference_genome"

# Create output directory if it doesn't exist
mkdir -p "$REF_DATA_DIR"

# Change to raw_data directory
cd "$REF_DATA_DIR"

echo "Downloading Genome fasta file from Ensembelfungi..."
wget -nc http://ftp.ensemblgenomes.org/pub/fungi/release-62/fasta/saccharomyces_cerevisiae/dna/Saccharomyces_cerevisiae.R64-1-1.dna_sm.toplevel.fa.gz

# Download the reference GFF3 file
echo "Downloading reference file from Ensembelfungi..."
wget -nc https://ftp.ensemblgenomes.ebi.ac.uk/pub/fungi/release-62/gff3/saccharomyces_cerevisiae/Saccharomyces_cerevisiae.R64-1-1.62.gff3.gz

echo "Download complete. Files saved to $REF_DATA_DIR"