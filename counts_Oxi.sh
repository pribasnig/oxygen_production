#!/bin/bash
#SBATCH --job-name=counts_Oxi
#SBATCH --cpus-per-task=4
#SBATCH --mem=2000
#SBATCH --time=00-00:45:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=thomas.pribasnig@univie.ac.at
#SBATCH --output=log/count_Oxis-%j.out
#SBATCH --error=log/counts_Oxi-%j.err

#copy the sam files and the genomefile in gff format into TMPDIR
mkdir featureCounts_hisat

cp ./hisat2/*.sam.gz /$TMPDIR
cp ./genome_for_featurecounts/*.gff /$TMPDIR

pushd $TMPDIR

pigz -d -p $SLURM_CPUS_PER_TASK ./*.gz

module load subread

featureCounts -a ./GCA_000698785.1_ASM69878v1_genomic.gff -t gene -g ID -o ./counts_hisat_Oxi.txt ./*.sam

popd

cp $TMPDIR/*.txt $TMPDIR/*.summary ./featureCounts_hisat
