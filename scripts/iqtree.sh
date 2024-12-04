#!/bin/bash
#SBATCH --job-name=build_tree
#SBATCH --output=logs/build_tree.out
#SBATCH --error=logs/build_tree.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G

iqtree -s data/results/alignment/combined_hsp70_aligned.fa -m LG -bb 1000 -pre data/results/tree/hsp70_tree
