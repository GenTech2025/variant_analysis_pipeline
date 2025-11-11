#!/bin/bash

# BWA Index Building Script
# Creates BWA index for the reference genome
# Required for read alignment in downstream analysis

# Set directories
REF_GENOME_DIR="../../raw_data/reference_genome"
REF_GENOME="$REF_GENOME_DIR/Saccharomyces_cerevisiae.R64-1-1.dna_sm.toplevel.fa"

echo "Building BWA index for reference genome..."
echo "Reference genome: $REF_GENOME"

# Check if reference genome exists
if [ ! -f "$REF_GENOME" ]; then
    echo "Error: Reference genome file not found at $REF_GENOME"
    exit 1
fi

# Build BWA index
# This creates index files (.amb, .ann, .bwt, .pac, .sa) in the same directory as the reference
bwa index "$REF_GENOME"

echo "BWA index building complete!"
echo "Index files created in $REF_GENOME_DIR"

# Create samtools faidx index (required for GATK and other tools)
echo "Creating samtools faidx index..."
samtools faidx "$REF_GENOME"

echo "Samtools faidx index complete!"

# Create sequence dictionary for Picard/GATK
DICT_FILE="${REF_GENOME%.fa}.dict"
echo "Creating sequence dictionary for Picard/GATK..."
picard CreateSequenceDictionary \
    R="$REF_GENOME" \
    O="$DICT_FILE"

echo "Sequence dictionary created: $DICT_FILE"
echo ""
echo "All reference genome indices created successfully!"
echo "Files created:"
echo "  - BWA index files (.amb, .ann, .bwt, .pac, .sa)"
echo "  - Samtools faidx index (.fai)"
echo "  - Picard sequence dictionary (.dict)"
