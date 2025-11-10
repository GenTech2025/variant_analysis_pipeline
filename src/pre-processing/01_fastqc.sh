#!/bin/bash

# FastQC Quality Control Script
# Runs FastQC on all FASTQ files in the raw_data directory

# Set directories
RAW_DATA_DIR="../../raw_data"
OUTPUT_DIR="../../reports/fastqc"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run FastQC on all .fastq.gz files
echo "Running FastQC on all FASTQ files..."
fastqc "$RAW_DATA_DIR"/*.fastq.gz -o "$OUTPUT_DIR" -t 4

echo "FastQC analysis complete. Results saved to $OUTPUT_DIR"
