#!/bin/bash
#SBATCH --job-name=trim_oxi
#SBATCH --cpus-per-task=4
#SBATCH --mem=4000
#SBATCH --time=00-01:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=thomas.pribasnig@univie.ac.at
#SBATCH --output=log/trim_oxi-%j.out
#SBATCH --error=log/trim_oxi-%j.err

#This script does trim the adapters
module load fastp

#Make the trimmed directory where our output will go
mkdir ./trimmed

#Save the program version in a file. Its just neat to include that to later figure out potential differences
# Here we used fastp 0.23.4


#######USING THE TEMPORARY DIRECTORY

#Every job has a temporary directory.
#The automatic variable for the temporary directory is $TMPDIR.

#We need to move any files we want to use into the $TMPDIR.

cp ./renamed/*fastq.gz $TMPDIR
#This command copies all files for trimming into the $TMPDIR.
#The same as any files used in a loop.

pushd $TMPDIR
#This will take or "push" you to the temporary directory.
module load fastp

#UNZIPPING IS NOT NECESSARY FOR FASTP - works with either zipped or unzipped fastq files
for r1_file in ./*-R1.fastq.gz; do
    # Extract sample name from R1 file
    sample_name=$(basename "$r1_file" | cut -f1 -d '-')

    echo "Processing $sample_name"

    # Generate R2 file name
    r2_file="${sample_name}-R2.fastq.gz"

    # Check if the R2 file exists
    if [[ -f "$r2_file" ]]; then
        # Run fastp for paired-end reads
        fastp -i "$r1_file" -I "$r2_file" \
              --out1 "${sample_name}-R1_trimmed.fastq.gz" \
              --out2 "${sample_name}-R2_trimmed.fastq.gz" \
              --unpaired1 "${sample_name}_unpaired-R1.fastq.gz" \
              --unpaired2 "${sample_name}_unpaired-R2.fastq.gz" \
              --trim_front1 12 --trim_front2 12 --trim_poly_g --detect_adapter_for_pe \
              --average_qual 30 \
              --length_required 30 \
              -h "${sample_name}_report.html" \
              -j "${sample_name}_report.json"

        echo "Finished processing $sample_name"
    else
        echo "R2 file for $sample_name not found, skipping..."
    fi
done

#The loop is done.
#The temporary directory now contains all files that were copied in and all files that were ouput from the loop.
#In this script, output files include trimmed files and summary files.

popd
#Moves or "pops" you back into the folder you were before the pushd command.
#All created files are still in temporary directory.

cp $TMPDIR/*trimmed.fastq.gz $TMPDIR/*_report.html $TMPDIR/*_report.json $TMPDIR/*unpaired-R1.fastq.gz $TMPDIR/*unpaired-R2.fastq.gz ./trimmed

#Copies any needed files from temporary directory to where you want them.

rm -rf $TMPDIR
#Completely removes temporary directory.
#If you don't do this, I think it lasts for 3 days and is then deleted.
#But I am not sure.
