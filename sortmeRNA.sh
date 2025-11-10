#!/bin/bash
#SBATCH --job-name=sortmeRNA_Oxi-%j
#SBATCH --cpus-per-task=8
#SBATCH --mem=2000
#SBATCH --time=00-02:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=thomas.pribasnig@univie.ac.at
#SBATCH --output=log/sortmeRNA_Oxi-%j.out
#SBATCH --error=log/sortmeRNA_Oxi-%j.err

#copy everything into TMP
cp ./prinseqlite_mqm30_good/*.fastq.gz $TMPDIR
cp ./rRNA_for_Index/Nviennensis_rRNAs.fasta $TMPDIR

#switch to TMP
pushd $TMPDIR

#load whatever we need
module load sortmerna
module load fastqc
module load conda
conda activate multiqc
#we load the old module because the new one (v.) has a glitch that makes it so our script would take 8 days

#make all direcotries
mkdir sorted

mkdir sorted/Index

mkdir sorted/rRNA

mkdir sorted/mRNA
mkdir sorted/mRNA/fastqc_sorted_mRNA
mkdir sorted/mRNA/multiqc_sorted_mRNA

#here we build an Index, the sequences we use to compare (16s from )

#unzip the filtered files
pigz -d -p 8 ./*.fastq.gz

#to start the loop - we only extract the sample name here 
ls -1 ./*.fastq|while read filename;
do

bin_name=`basename $filename|cut -f1 -d '_'`

###THIS USED TO BE HOW SORTMERNA WORKED
#sortmerna --ref /scratch/ecogenomics/pribasnig/Oxygen_transcriptome/rRNA_for_Index/Nviennensis_rRNAs.fasta,\
#./sorted/Index/viennensisALL \
#--reads ./$bin_name'_trimmed_trimmomatic_18_good.fastq.fastq'\
#--aligned ./sorted/rRNA/$bin_name'_rRNA' --other ./sorted/mRNA/$bin_name'_mRNA' --fastx --log -a 8

### THIS IS THE NEW COMMAND:
sortmerna --ref ./Nviennensis_rRNAs.fasta --reads ./$bin_name'_trimmed_trimmomatic_18_good.fastq.fastq' --aligned  ./sorted/rRNA/$bin_name'_rRNA' --other ./sorted/mRNA/$bin_name'_mRNA' --fastx --threads 8 --workdir ./run/

rm -r ./run
done


pigz -p 8 ./sorted/rRNA/*.fq 
pigz -p 8 ./sorted/mRNA/*.fq 


fastqc ./sorted/mRNA/*.gz -o sorted/mRNA/fastqc_sorted_mRNA

multiqc ./sorted/mRNA/fastqc_sorted_mRNA -o ./sorted/mRNA/multiqc_sorted_mRNA -n sorted_multiqc_mRNA

popd


cp -r $TMPDIR/sorted /scratch/ecogenomics/pribasnig/Oxygen_transcriptome
rm -r $TMPDIR
