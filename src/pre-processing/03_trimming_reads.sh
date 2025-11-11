#!/bin/bash

# Trimmomatic Read Trimming Script
# Trims paired-end FASTQ reads to 200bp
# Outputs both paired and unpaired reads

# Set directories
RAW_DATA_DIR="../../raw_data"
OUTPUT_DIR="../../processed_data/trimmed_reads"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Array of sample names
SAMPLES=("SRR6728143" "SRR6728144" "SRR6728145" "SRR6728146" "SRR6728147" "SRR6728148")

echo "Starting read trimming with Trimmomatic..."

# Loop through each sample and trim paired-end reads
for SAMPLE in "${SAMPLES[@]}"; do
    echo "Processing sample: $SAMPLE"

    trimmomatic PE \
        -threads 6 \
        "$RAW_DATA_DIR/${SAMPLE}_1.fastq.gz" \
        "$RAW_DATA_DIR/${SAMPLE}_2.fastq.gz" \
        "$OUTPUT_DIR/${SAMPLE}_1_paired.fastq.gz" \
        "$OUTPUT_DIR/${SAMPLE}_1_unpaired.fastq.gz" \
        "$OUTPUT_DIR/${SAMPLE}_2_paired.fastq.gz" \
        "$OUTPUT_DIR/${SAMPLE}_2_unpaired.fastq.gz" \
        CROP:200 \
        MINLEN:200

    echo "Completed: $SAMPLE"
done

echo "Read trimming complete. Trimmed files saved to $OUTPUT_DIR"
echo "Output includes both paired and unpaired reads for each sample"

# 