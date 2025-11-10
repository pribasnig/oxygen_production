#!/bin/bash
#SBATCH --job-name=filter_Oxi-%j
#SBATCH --cpus-per-task=8
#SBATCH --mem=1000
#SBATCH --time=00-02:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=thomas.pribasnig@univie.ac.at
#SBATCH --output=log/filter_Oxi-%j.out
#SBATCH --error=log/filter_Oxi-%j.err


cp ./trimmed_trimmomatic_18/*fastq.gz $TMPDIR
#this script should be run one directory down from raw_data

pushd $TMPDIR
#pushes us to the temp dir

module load prinseqlite
module load fastqc
module load conda
conda activate multiqc
#loads and activates the modules we need


# Create directories in the temporary directory
mkdir ./prinseqlite_mqm30_good
mkdir ./prinseqlite_mqm30_bad


#i found this for loop to input multiple SE file in a loop online
#alternatively could be done with ls and cut again like before
#i tried out the for loop witch just echoing base and it gave me all the basenames
pigz -d -p 4 ./*.gz

ls -1 ./*.fastq|while read filename;
#This starts the loop.

do

bin_name=`basename $filename|cut -f1 -d '.'`
echo $bin_name
  prinseq-lite.pl -fastq ./$filename -log prinseq.log -min_qual_mean 30 -out_good ./prinseqlite_mqm30_good/$bin_name'_good.fastq' -out_bad ./prinseqlite_mqm30_bad/$bin_name'_bad.fastq'
done


#compress output again
pigz -p 4 ./prinseqlite_mqm30_good/*.fastq
pigz -p 4 ./prinseqlite_mqm30_bad/*.fastq


mkdir ./prinseqlite_mqm30_good/fastq_prinseq_mqm30_good
mkdir ./prinseqlite_mqm30_bad/fastq_prinseq_mqm30_bad
mkdir ./prinseqlite_mqm30_good/fastq_prinseq_mqm30_good/multiqc_output_good/
mkdir ./prinseqlite_mqm30_bad/fastq_prinseq_mqm30_bad/multiqc_output_bad/


fastqc ./prinseqlite_mqm30_good/*.fastq.gz -o ./prinseqlite_mqm30_good/fastq_prinseq_mqm30_good -t 4
fastqc ./prinseqlite_mqm30_bad/*.fastq.gz -o ./prinseqlite_mqm30_bad/fastq_prinseq_mqm30_bad -t 4

multiqc ./prinseqlite_mqm30_good/fastq_prinseq_mqm30_good -o ./prinseqlite_mqm30_good/fastq_prinseq_mqm30_good/multiqc_output_good/ -n prinseqlite_mqm30_good
multiqc ./prinseqlite_mqm30_bad/fastq_prinseq_mqm30_bad -o ./prinseqlite_mqm30_bad/fastq_prinseq_mqm30_bad/multiqc_output_bad/ -n prinseqlite_mqm30_bad

popd


cp -r $TMPDIR/prinseqlite_mqm30_good $TMPDIR/prinseqlite_mqm30_bad /scratch/ecogenomics/pribasnig/Oxygen_transcriptome
rm -r $TMPDIR