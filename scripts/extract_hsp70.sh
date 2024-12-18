#!/bin/bash
#SBATCH --job-name=extract_hsp70
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G
#SBATCH --output=logs/extract_hsp70_%j.log
#SBATCH --error=logs/extract_hsp70_%j.err

echo "Starting HSP70 extraction..."

for file in data/raw/*.fa; do
    echo "Processing $file..."
    grep -A 1 "Hsp70" $file > data/processed/$(basename "$file" .pep.all.fa)_hsp70.fa
done

echo "Combining extracted HSP70 sequences into a single file..."
cat data/processed/*_hsp70.fa > data/processed/combined_hsp70.fa

echo "HSP70 extraction completed!"
