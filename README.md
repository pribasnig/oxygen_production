# Oxygen Production
This repository contains oxygen production and growth data of N. viennensis under different physiological conditions and corresponding scripts to visualize data.

## Table of Contents

## 1. Analysis in R
*  all_raw_data.csv
   *  contains all measured oxygen production raw data, used in script all_production_data_final.R

*  Recovery_growthcurve.csv
   *  contains growth data in the form of raw measured NO2 values, used in script all_production_data_final.R

*  total_prod_data_grouped.csv
   *  contains calculated total oxygen production, used in script all_production_data_final.R

*  all_production_data_final.R
   *  script to analyse oygen production and growth data used for Figures 1-5.

## 2.1 Processing Scripts for 24h transcriptome (raw → counts)

This folder contains all scripts used to convert raw NCBI FASTQ files into the final count tables.
Raw fastw files can be downloaded from NCBI: PRJNA1358245

*  trim_Oxi_trimmomatic_18.sh
   *   Adapter trimming and quality filtering using trimmomatic. Output: cleaned fastq files.

*  filter_Oxi.sh
   *   Filters reads based on quality. Output: Fastq files fitlered by quality.

*  sortmeRNA.sh
   *  Removal of ribosomal RNA reads using SortMeRNA. Output: rRNA-removed high quaity FASTQ files for downstream mapping.

*  hisat2_Oxi.sh
   *Alignment of  reads to the N. viennensis reference genome using HISAT2.

*  counts_Oxi.sh
  * Gene-level quantification using featureCounts. Output: raw counts

*  counts_24h_transcriptome.txt
  *  counts in txt format

