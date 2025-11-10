#!/bin/bash
#SBATCH --job-name=trim_Oxi_trimmomatic
#SBATCH --cpus-per-task=4
#SBATCH --mem=2000
#SBATCH --time=00-01:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=thomas.pribasnig@univie.ac.at
#SBATCH --output=log/trim_Oxi_trimmomatic-%j.out
#SBATCH --error=log/trim_Oxi_trimmomatic-%j.err

#This script does trim the adapters
module load trimmomatic

#Make the trimmed directory where our output will go
mkdir ./trimmed_trimmomatic_18

#Save the program version in a file. Its just neat to include that to later figure out potential differences
# Here we used fastp 0.23.4
trimmomatic --version > ./trimmed_trimmomatic_18/trim_version


#######USING THE TEMPORARY DIRECTORY

#Every job has a temporary directory.
#The automatic variable for the temporary directory is $TMPDIR.

#We need to move any files we want to use into the $TMPDIR.

cp ./raw_data/renamed/*fastq.gz $TMPDIR
#This command copies all files for trimming into the $TMPDIR.
#The same as any files used in a loop.

pushd $TMPDIR
#This will take or "push" you to the temporary directory.

#UNZIPPING IS NOT NECESSARY FOR FASTP - works with either zipped or unzipped fastq files

ls -1 ./*fastq.gz|while read filename;
#This starts the loop.

do

bin_name=`basename $filename|cut -f1 -d '.'`
#Extracting the sample name.

echo $bin_name

trimmomatic SE -phred33 -threads $SLURM_CPUS_PER_TASK -summary $bin_name'.summary' $filename $bin_name'_trimmed_trimmomatic_18.fastq.gz' ILLUMINACLIP:/apps/trimmomatic/0.39/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:4:15 LEADING:3 TRAILING:3 MINLEN:18 HEADCROP:12


#Runs the actual command.


done
#The loop is done.
#The temporary directory now contains all files that were copied in and all files that were ouput from the loop.
#In this script, output files include trimmed files and summary files.

popd
#Moves or "pops" you back into the folder you were before the pushd command.
#All created files are still in temporary directory.

cp $TMPDIR/*trimmed_trimmomatic_18.fastq.gz $TMPDIR/*.summary  ./trimmed_trimmomatic_18

#Copies any needed files from temporary directory to where you want them.

rm -rf $TMPDIR
#Completely removes temporary directory.
#If you don't do this, I think it lasts for 3 days and is then deleted.
#But I am not sure. 
