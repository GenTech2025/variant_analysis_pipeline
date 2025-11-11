#!/bin/bash

# Post-Trimming Quality Control Script
# Runs FastQC on trimmed reads and generates MultiQC report

# Set directories
TRIMMED_DIR="../../processed_data/trimmed_reads"
OUTPUT_DIR="../../reports/fastqc_trimmed"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "Running FastQC on trimmed reads..."
echo "Output directory: $OUTPUT_DIR"
echo ""

# Run FastQC on all trimmed FASTQ files
fastqc "$TRIMMED_DIR"/*.fastq.gz \
    --outdir "$OUTPUT_DIR" \
    --threads 8 \
    --quiet

echo "FastQC complete!"
echo ""

# Run MultiQC to aggregate results
echo "Generating MultiQC report..."
multiqc "$OUTPUT_DIR" \
    --outdir "$OUTPUT_DIR" \
    --title "Post-Trimming QC Report" \
    --filename "multiqc_trimmed_report" \
    --force

echo ""
echo "Quality control complete!"
echo "FastQC reports saved to: $OUTPUT_DIR"
echo "MultiQC report: $OUTPUT_DIR/multiqc_trimmed_report.html"
