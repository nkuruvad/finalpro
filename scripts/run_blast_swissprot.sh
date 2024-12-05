#!/bin/bash
#SBATCH --job-name=blast_swissprot
#SBATCH --output=logs/blast_swissprot.out
#SBATCH --error=logs/blast_swissprot.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G

blastp -query results/alignment/combined_hsp70_blastdb.fa -db swissprot/spdb -out results/blast/blast_results.txt -evalue 1e-5 -outfmt 6 -num_threads 10

echo "BLASTP against SwissProt database completed."

