#!/bin/bash
#SBATCH --job-name=align_hsp70
#SBATCH --output=logs/align_hsp70.out
#SBATCH --error=logs/align_hsp70.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G


singularity exec --bind $(pwd)/temp_dir:/scratch /project/stuckert/nkuruvad/mafft.sif mafft --auto --thread 10 data/processed/combined_hsp70.fa > results/alignment/combined_hsp70_aligned.fa

echo "Alignment completed: results/alignment/combined_hsp70_aligned.fa"
