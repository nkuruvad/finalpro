#!/bin/bash
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G

awk '$11 < 1e-5 {print}' results/blast/blast_results.txt > results/blast/significant_hits.txt
