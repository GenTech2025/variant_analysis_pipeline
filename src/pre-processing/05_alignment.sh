#!/bin/bash

# BWA Alignment Script
# Aligns trimmed paired-end reads to reference genome using BWA MEM
# Converts SAM to BAM and sorts the output

# Set directories and files
REF_GENOME="../../raw_data/reference_genome/Saccharomyces_cerevisiae.R64-1-1.dna_sm.toplevel.fa"
TRIMMED_DIR="../../processed_data/trimmed_reads"
OUTPUT_DIR="../../results/aligned_reads"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Array of sample names
SAMPLES=("SRR6728143" "SRR6728144" "SRR6728145" "SRR6728146" "SRR6728147" "SRR6728148")

# Number of threads to use
THREADS=8

echo "Starting BWA alignment..."
echo "Reference genome: $REF_GENOME"
echo "Using $THREADS threads"
echo ""

# Loop through each sample and align reads
for SAMPLE in "${SAMPLES[@]}"; do
    echo "Processing sample: $SAMPLE"

    # Define input files (paired reads only)
    READ1="$TRIMMED_DIR/${SAMPLE}_1_paired.fastq.gz"
    READ2="$TRIMMED_DIR/${SAMPLE}_2_paired.fastq.gz"

    # Check if input files exist
    if [ ! -f "$READ1" ] || [ ! -f "$READ2" ]; then
        echo "  Warning: Trimmed reads not found for $SAMPLE, skipping..."
        continue
    fi

    # Define output files
    SAM_FILE="$OUTPUT_DIR/${SAMPLE}.sam"
    BAM_FILE="$OUTPUT_DIR/${SAMPLE}.bam"
    SORTED_BAM="$OUTPUT_DIR/${SAMPLE}_sorted.bam"

    # Run BWA MEM alignment
    echo "  Running BWA MEM alignment..."
    bwa mem -t $THREADS \
        -R "@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tPL:ILLUMINA\tLB:lib1\tPU:unit1" \
        "$REF_GENOME" \
        "$READ1" \
        "$READ2" \
        > "$SAM_FILE"

    # Convert SAM to BAM
    echo "  Converting SAM to BAM..."
    samtools view -@ $THREADS -bS "$SAM_FILE" > "$BAM_FILE"

    # Sort BAM file
    echo "  Sorting BAM file..."
    samtools sort -@ $THREADS "$BAM_FILE" -o "$SORTED_BAM"

    # Index sorted BAM file
    echo "  Indexing sorted BAM file..."
    samtools index "$SORTED_BAM"

    # Remove intermediate files to save space
    echo "  Cleaning up intermediate files..."
    rm "$SAM_FILE" "$BAM_FILE"

    echo "  Completed: $SAMPLE"
    echo "  Output: $SORTED_BAM"
    echo ""
done

echo "Alignment complete! Sorted BAM files saved to $OUTPUT_DIR"
echo ""
echo "Summary of output files:"
ls -lh "$OUTPUT_DIR"
