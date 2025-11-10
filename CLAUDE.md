# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository. Your are a helpful AI assistant that helps users understand and work with the codebase.

## Project Overview

This is a **somatic variant analysis pipeline** for genomic data, following the Harvard Chan Bioinformatics Training Core tutorial. The pipeline processes paired-end FASTQ files from NCBI SRA (project PRJNA434021) through standard bioinformatics workflows to identify and analyze genomic variants (SNPs, indels, structural variants, and CNVs).

Reference: https://hbctraining.github.io/Intro-to-variant-analysis/lessons/00_intro_to_variant_calling.html

## Environment Setup

The project uses a Conda environment with bioinformatics tools. The environment specification is in `env/conda_enviroment.yml`.

Create the environment:
```bash
conda env create -f env/conda_enviroment.yml
```

Activate the environment:
```bash
conda activate variant-analysispipeline
```

### Key Tools Included
- **FastQC** (0.11.9) - Quality control for sequencing data
- **BWA** (0.7.17) - Alignment of reads to reference genome
- **Picard** (2.27.5) - SAM/BAM file manipulation
- **GATK4** (4.1.9.0) - Variant calling
- **SnpEff** (4.3g) - Variant annotation (includes SnpSift)
- **BCFtools** (1.14) - VCF file manipulation
- **MultiQC** (1.12) - Aggregate quality control reports
- **SAMtools** (1.15.1) - SAM/BAM file utilities
- **BEDtools** (2.30.0) - Genomic interval operations

## Pipeline Architecture

The pipeline follows a standard variant calling workflow:

1. **Data Acquisition** (`raw_data/`): Paired-end FASTQ files downloaded from ENA/SRA
   - Dataset: 6 samples (SRR6728143-SRR6728148), each with _1 and _2 paired reads
   - Download script: `raw_data/ena-file-download-read_run-PRJNA434021-fastq_ftp-20251106-1941.sh`

2. **Pre-processing** (`src/pre-processing/`): Quality control and data preparation
   - `01_fastqc.sh` - Run FastQC on raw reads

3. **Analysis** (`src/`): Main variant calling workflow (to be implemented)
   - `analysis.rmd` - R Markdown notebook for analysis and visualization

4. **Outputs**:
   - `results/` - Processed data files (BAM, VCF, etc.)
   - `reports/` - Quality control reports (FastQC, MultiQC)
   - `figures/` - Plots and visualizations
   - `docs/` - Documentation and background theory

## Directory Structure

```
variant_analysis_pipeline/
├── raw_data/          # Raw FASTQ files and download scripts
├── src/               # Analysis scripts
│   ├── pre-processing/  # QC and data preparation scripts
│   └── analysis.rmd     # R Markdown analysis notebook
├── results/           # Output files from analysis
├── reports/           # QC reports
├── figures/           # Generated plots
├── docs/              # Documentation
└── env/               # Conda environment specification
```

## Running the Pipeline

### Step 1: Download Raw Data
```bash
cd raw_data
bash ena-file-download-read_run-PRJNA434021-fastq_ftp-20251106-1941.sh
```

### Step 2: Quality Control
```bash
cd src/pre-processing
bash 01_fastqc.sh
```

### Step 3: Subsequent Analysis Steps
Further pipeline steps (alignment, variant calling, annotation) are to be implemented in `src/` following the Harvard tutorial workflow.

## Development Notes

- This pipeline is based on an educational tutorial and is being actively developed
- Shell scripts in `src/pre-processing/` follow a numbered sequence (01_, 02_, etc.) indicating pipeline order
- All bioinformatics tools are managed through the Conda environment - do not install tools system-wide
- Input data is paired-end sequencing data, so scripts should handle both _1 and _2 FASTQ files
