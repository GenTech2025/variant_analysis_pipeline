#!/bin/bash

# Alignment Quality Control Script
# Generates alignment statistics and MultiQC report

# Set directories
ALIGNED_DIR="../../results/aligned_reads"
STATS_DIR="../../reports/alignment_stats"

# Create output directory if it doesn't exist
mkdir -p "$STATS_DIR"

# Array of sample names
SAMPLES=("SRR6728143" "SRR6728144" "SRR6728145" "SRR6728146" "SRR6728147" "SRR6728148")

echo "Generating alignment statistics..."
echo ""

# Loop through each sample and generate statistics
for SAMPLE in "${SAMPLES[@]}"; do
    echo "Processing sample: $SAMPLE"

    BAM_FILE="$ALIGNED_DIR/${SAMPLE}_sorted.bam"

    # Check if BAM file exists
    if [ ! -f "$BAM_FILE" ]; then
        echo "  Warning: BAM file not found for $SAMPLE, skipping..."
        continue
    fi

    # Generate samtools flagstat statistics
    echo "  Running samtools flagstat..."
    samtools flagstat "$BAM_FILE" > "$STATS_DIR/${SAMPLE}_flagstat.txt"

    # Generate samtools stats
    echo "  Running samtools stats..."
    samtools stats "$BAM_FILE" > "$STATS_DIR/${SAMPLE}_stats.txt"

    # Generate samtools idxstats (per-chromosome mapping statistics)
    echo "  Running samtools idxstats..."
    samtools idxstats "$BAM_FILE" > "$STATS_DIR/${SAMPLE}_idxstats.txt"

    echo "  Completed: $SAMPLE"
    echo ""
done

echo "Alignment statistics complete!"
echo ""

# Run MultiQC to aggregate all results
echo "Generating MultiQC report for alignment statistics..."
multiqc "$STATS_DIR" \
    --outdir "$STATS_DIR" \
    --title "Alignment QC Report" \
    --filename "multiqc_alignment_report" \
    --force

echo ""
echo "Quality control complete!"
echo "Statistics saved to: $STATS_DIR"
echo "MultiQC report: $STATS_DIR/multiqc_alignment_report.html"
echo ""
echo "Key metrics to check:"
echo "  - Overall alignment rate (should be >80% for good data)"
echo "  - Properly paired reads percentage"
echo "  - Duplicate rate"
echo "  - Insert size distribution"
