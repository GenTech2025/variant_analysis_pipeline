# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **somatic variant analysis pipeline** for yeast genomic data (Saccharomyces cerevisiae), following the Harvard Chan Bioinformatics Training Core tutorial. The pipeline processes paired-end FASTQ files from NCBI SRA (project PRJNA434021, 6 samples: SRR6728143-SRR6728148) through standard bioinformatics workflows to identify and analyze genomic variants.

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
- **FastQC** (0.11.9) / **MultiQC** (1.12) - Quality control
- **Trimmomatic** (0.39) - Read trimming
- **BWA** (0.7.17) - Read alignment
- **SAMtools** (1.15.1) / **Picard** (2.27.5) - BAM manipulation
- **GATK4** (4.1.9.0) - Variant calling
- **SnpEff** (4.3g) / **BCFtools** (1.14) - Variant annotation/manipulation
- **BEDtools** (2.30.0) - Genomic interval operations

## Pipeline Architecture

The pipeline follows a standard variant calling workflow:

1. **Data Acquisition** (`raw_data/`):
   - Paired-end FASTQ files: 6 samples (SRR6728143-SRR6728148)
   - Reference genome: S. cerevisiae R64-1-1 (12MB)
   - Scripts: `00_download_dataset_ENA.sh`, `00_download_reference_data.sh`

2. **Pre-processing** (`src/pre-processing/`): Sequential numbered scripts
   - `01_fastqc.sh` - Initial QC on raw reads
   - `02_multiqc.sh` - Aggregate QC report
   - `03_trimming_reads.sh` - Trim reads to 200bp (Trimmomatic)
   - `02_post_trimming_qc.sh` - QC on trimmed reads
   - `04_build_genome_index.sh` - Build BWA/SAMtools/Picard indices
   - `05_alignment.sh` - Align with BWA MEM (adds read groups)
   - `05b_alignment_qc.sh` - Alignment statistics
   - `06_mark_duplicates.sh` - Mark PCR duplicates with Picard

3. **Variant Calling** (TODO): GATK HaplotypeCaller workflow
   - Scripts 07-09: Variant calling, filtering, annotation

4. **Analysis** (`src/analysis.rmd`): R Markdown for visualization and interpretation

5. **Outputs**:
   - `processed_data/trimmed_reads/` - Trimmed FASTQ files (_1/_2_paired, _1/_2_unpaired)
   - `results/aligned_reads/` - Sorted BAM files (*_sorted.bam + .bai)
   - `results/marked_duplicates/` - Duplicate-marked BAMs (*_sorted_marked.bam)
   - `reports/` - QC reports (fastqc/, alignment_stats/, duplicate_metrics/)
   - `figures/` - Analysis plots

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

All scripts should be run from within the `src/pre-processing/` directory. Scripts use relative paths (`../../`) to locate data and outputs.

**Current Progress:** Steps 1-6 are complete. Pipeline is at ~50% completion (see PROJECT_PROGRESS.md for detailed status).

### Execute Scripts Sequentially

```bash
cd src/pre-processing

# 1. Download data (one-time setup)
bash 00_download_dataset_ENA.sh
bash 00_download_reference_data.sh

# 2. Initial QC
bash 01_fastqc.sh
bash 02_multiqc.sh

# 3. Trimming and post-trim QC
bash 03_trimming_reads.sh
bash 02_post_trimming_qc.sh

# 4. Build reference indices (one-time setup)
bash 04_build_genome_index.sh

# 5. Alignment
bash 05_alignment.sh
bash 05b_alignment_qc.sh

# 6. Mark duplicates
bash 06_mark_duplicates.sh

# 7-9. Variant calling (TODO)
# bash 07_variant_calling.sh
# bash 08_filter_variants.sh
# bash 09_annotate_variants.sh
```

## Important Implementation Details

### Script Execution Context
- **Working Directory:** All scripts must be run from `src/pre-processing/`
- **Path Convention:** Scripts use relative paths (`../../raw_data`, `../../results`, etc.)
- **Numbering:** Scripts follow numbered sequence indicating pipeline order

### Sample Processing
- **Sample Array:** All scripts iterate over: `SAMPLES=("SRR6728143" "SRR6728144" "SRR6728145" "SRR6728146" "SRR6728147" "SRR6728148")`
- **Thread Count:** Scripts use 6-8 threads (optimized for 6-core/12-thread system)
- **Read Groups:** BWA adds read group tags (`@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tPL:ILLUMINA\tLB:lib1\tPU:unit1`)

### Data Processing Decisions
- **Trimming:** Fixed 200bp length (CROP:200, MINLEN:200 in Trimmomatic)
- **Alignment:** Only paired reads used (*_paired.fastq.gz); unpaired reads saved but not aligned
- **Duplicates:** Marked, not removed (REMOVE_DUPLICATES=false for GATK compatibility)
- **Intermediate Files:** SAM files deleted after BAM conversion to save space

### File Naming Conventions
- Raw FASTQ: `{SAMPLE}_1.fastq.gz`, `{SAMPLE}_2.fastq.gz`
- Trimmed: `{SAMPLE}_1_paired.fastq.gz`, `{SAMPLE}_2_paired.fastq.gz`, `{SAMPLE}_1_unpaired.fastq.gz`, `{SAMPLE}_2_unpaired.fastq.gz`
- Aligned: `{SAMPLE}_sorted.bam` (+ .bai index)
- Marked: `{SAMPLE}_sorted_marked.bam` (+ .bai index)

### Quality Control Expectations
- Alignment rate should be >80% for good quality
- Check QC reports before proceeding to next major step
- Review PROJECT_PROGRESS.md for current pipeline status and next steps
