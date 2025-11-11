#!/bin/bash

# Mark Duplicates Script
# Uses Picard to mark PCR and optical duplicate reads
# Required preprocessing step for GATK variant calling

# Set directories
INPUT_DIR="../../results/aligned_reads"
OUTPUT_DIR="../../results/marked_duplicates"
METRICS_DIR="../../reports/duplicate_metrics"

# Create output directories if they don't exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$METRICS_DIR"

# Array of sample names
SAMPLES=("SRR6728143" "SRR6728144" "SRR6728145" "SRR6728146" "SRR6728147" "SRR6728148")

echo "Starting duplicate marking with Picard..."
echo ""

# Loop through each sample
for SAMPLE in "${SAMPLES[@]}"; do
    echo "Processing sample: $SAMPLE"

    # Define input and output files
    INPUT_BAM="$INPUT_DIR/${SAMPLE}_sorted.bam"
    OUTPUT_BAM="$OUTPUT_DIR/${SAMPLE}_sorted_marked.bam"
    METRICS_FILE="$METRICS_DIR/${SAMPLE}_duplicate_metrics.txt"

    # Check if input file exists
    if [ ! -f "$INPUT_BAM" ]; then
        echo "  Warning: Aligned BAM not found for $SAMPLE, skipping..."
        continue
    fi

    # Mark duplicates using Picard
    echo "  Marking duplicates..."
    picard MarkDuplicates \
        INPUT="$INPUT_BAM" \
        OUTPUT="$OUTPUT_BAM" \
        METRICS_FILE="$METRICS_FILE" \
        CREATE_INDEX=true \
        VALIDATION_STRINGENCY=SILENT \
        REMOVE_DUPLICATES=false

    echo "  Completed: $SAMPLE"
    echo "  Output: $OUTPUT_BAM"
    echo "  Metrics: $METRICS_FILE"
    echo ""
done

echo "Duplicate marking complete!"
echo ""
echo "Summary of output files:"
ls -lh "$OUTPUT_DIR"
echo ""
echo "Duplicate metrics saved to: $METRICS_DIR"
