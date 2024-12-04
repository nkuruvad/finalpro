#!/bin/bash
#SBATCH --job-name=process_hsp70
#SBATCH --output=logs/process_hsp70.out
#SBATCH --error=logs/process_hsp70.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G

for file in data/processed/*_hsp70.fa; do
    species=$(basename "$file" | cut -d. -f1)

    if [ "$species" == "Cavia_porcellus" ]; then
        spp="GuineaPig"
    elif [ "$species" == "Castor_canadensis" ]; then
        spp="Beaver"
    elif [ "$species" == "Mus_musculus" ]; then
        spp="Mouse"
    elif [ "$species" == "Peromyscus_maniculatus" ]; then
        spp="DeerMouse"
    elif [ "$species" == "Rattus_norvegicus" ]; then
        spp="Rat"
    elif [ "$species" == "Heterocephalus_glaber" ]; then
        spp="NakedMoleRat"
    elif [ "$species" == "Ictidomys_tridecemlineatus" ]; then
        spp="GroundSquirrel"
    elif [ "$species" == "Heterocephalus_glaber_female" ]; then
    	spp="NakedMoleRat"
    elif [ "$species" == "Peromyscus_maniculatus_bairdii" ]; then
    	spp="DeerMouse"
    else
        echo "Warning: $species not recognized. Skipping file."
        continue
    fi

    awk -v sp="$spp" '/^>/ {print ">" sp "_" ++i; next} {print}' "$file" > data/processed/cleaned/${spp}_hsp70.fa

    echo "Processed file for $spp: data/processed/cleaned/${spp}_hsp70.fa"
done

cat data/processed/cleaned/*_hsp70.fa > data/processed/combined_hsp70.fa
echo "Combined file created: data/processed/combined_hsp70.fa"

echo "Success!"
