#!/bin/bash

# MultiQC Aggregation Script
# Aggregates FastQC reports into a single comprehensive report

# Set directories
FASTQC_DIR="../../reports/fastqc"
OUTPUT_DIR="../../reports"

# Check if FastQC reports exist
if [ ! -d "$FASTQC_DIR" ] || [ -z "$(ls -A $FASTQC_DIR)" ]; then
    echo "Error: No FastQC reports found in $FASTQC_DIR"
    echo "Please run 01_fastqc.sh first"
    exit 1
fi

# Run MultiQC to aggregate FastQC reports
echo "Running MultiQC to aggregate FastQC reports..."
multiqc "$FASTQC_DIR" -o "$OUTPUT_DIR" -n multiqc_report.html --force

echo "MultiQC analysis complete. Report saved to $OUTPUT_DIR/multiqc_report.html"
