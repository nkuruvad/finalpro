#!/bin/bash
#SBATCH --job-name=makespdb
#SBATCH --output=logs/blast_hsp70_swissprot.out
#SBATCH --error=logs/blast_hsp70_swissprot.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G

makeblastdb -in swissprot/swissprot -dbtype prot -out swissprot/spdb
