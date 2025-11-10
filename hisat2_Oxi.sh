#!/bin/bash
#SBATCH --job-name=hisat2_Oxi-%j
#SBATCH --cpus-per-task=4
#SBATCH --mem=1000
#SBATCH --time=00-00:45:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=thomas.pribasnig@univie.ac.at
#SBATCH --output=log/hisat2_Oxi-%j.out
#SBATCH --error=log/hisat2_Oxi-%j.err

#copy all the files with mRNA and the NV genome to the TMPDIR, containing the genome of NV and also the sorted mRNA files
cp ./sorted/mRNA/*mRNA.fq.gz $TMPDIR
cp ./genome_for_Index/GCA_000698785.1_ASM69878v1_genomic.fna $TMPDIR

#go to TMPDIR and load modules
pushd $TMPDIR

module load conda

conda activate hisat2

module load samtools

#make directories


mkdir ./hisat2

#build genome to map to
hisat2-build -f -p $SLURM_CPUS_PER_TASK ./GCA_000698785.1_ASM69878v1_genomic.fna ./N_viennensis


ls -1 ./*mRNA.fq.gz|while read filename;


#this runs the actual script again, we use strandness reverse since we are working with cDNA from RNA - this is the reverse from what the RNA would be like, we use the 

do

bin_name=`basename $filename|cut -f1 -d '_'`


hisat2  -p $SLURM_CPUS_PER_TASK --rna-strandness R --no-spliced-alignment  -q -x N_viennensis -U ./$bin_name'_mRNA.fq.gz' -S ./hisat2/$bin_name'.sam' 


done

pigz -p 4 ./hisat2/*.sam 

popd

cp  -r $TMPDIR/hisat2 ./




