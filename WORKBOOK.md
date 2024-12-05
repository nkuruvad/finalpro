## Day 1: Project Setup
- created project folder and initialized git
- set up the following structure:
  - `data/raw`: for raw datasets
  - `data/processed`: for processed data files
  - `scripts`: for all analysis scripts
  - `results`: for outputs like alignments, trees, and annotations
- Linked the local repository to github and pushed the initial setup

## Data Acquisition

### Datasets Downloaded
downloaded protein FASTA files for the following species from Ensembl's FTP server:
- Beaver (Castor canadensis): `Castor_canadensis.C.can_genome_v1.0.pep.all.fa`
- Mouse (Mus musculus): `Mus_musculus.GRCm39.pep.all.fa`
- Rat (Rattus norvegicus): `Rattus_norvegicus.Rnor_6.0.pep.all.fa`
- Deer Mouse (Peromyscus maniculatus): `Peromyscus_maniculatus_bairdii.HU_Pman_2.1.pep.all.fa`
- Squirrel (Ictidomys tridecemlineatus): `Ictidomys_tridecemlineatus.SpeTri2.0.pep.all.fa`
- Guinea Pig (Cavia porcellus): `Cavia_porcellus.Cavpor3.0.pep.all.fa`
- Naked Mole Rat (Heterocephalus glaber): `Heterocephalus_glaber_female.HetGla_female_1.0.pep.all.fa`

### Notes
- files downloaded using `wget` commands from the Ensembl FTP server
- Files were stored in the `data/raw` directory and unzipped using the `gzip` command
- Verified that all files were present and correctly named

## Version Control

### Git Workflow
- Added `data/` and `scripts/` directories to version control
- Staged and committed the following:
  - Raw FASTA files in `data/raw/`
  - Processed files placeholder in `data/processed/`
  - Script for HSP70 extraction: `scripts/extract_hsp70.sh`

#### Commands Used:
```bash
git add data/ scripts/
git commit -m "Added data and scripts directories with HSP70 extraction script"
git push
```

#### Challenges/Errors:
- error: accidentally created `results` and `scripts` directories inside the `data` directory instead of the project root
- cause: mis-specified paths during directory creation
- fix:
  1. moved `results` and `scripts` directories to the project root using:
     ```bash
     mv data/results ./
     mv data/scripts ./
     ```
  2. fixed directory organization

## Day 2: Hsp70 Extraction and Pipeline Setup

### Extraction
- focused on Hsp70 after finding relevant sequences in several species.
- extracted Hsp70 sequences using `grep` for "Hsp70" in gene files.
- verified processed files and combined them into `data/processed/combined_hsp70.fa`.

## Header Cleanup with Common Names

### Steps Taken:
1. Mapped scientific names to common names:
   - Cavia_porcellus → GuineaPig
   - Castor_canadensis → Beaver
   - Mus_musculus → Mouse
   - (other mappings...)
2. Replaced scientific names with common names in FASTA headers using:
   `awk -v sp="$spp" '/^>/ {print ">" sp "_" ++i; next} {print}' "$file" > data/processed/cleaned/${spp}_hsp70.fa`
3. Combined cleaned files into a single file: `data/processed/combined_hsp70.fa`.

Mistakes and Fixes:
	Mistake: Skipped species due to mismatched names in the script.
Fix: Corrected mappings in cleancomb.sh and re-ran the pipeline.
	Mistake: Accidentally created scripts and results inside the data directory.
Fix: Removed incorrect directories and reorganized the project structure.
	Validation:
	Verified logs/process_hsp70.out to confirm successful processing and combination.

### Notes:
- Common names make downstream results easier to interpret.
- Example of updated header: `>GuineaPig_1`.

### Alignment
- aligned sequences using MAFFT with 20 CPUs and 64GB memory.
- output stored in `results/combined_hsp70_aligned.fa`
- Attempted to run MAFFT using Singularity but encountered several errors:
	Error 1: mktemp: No such file or directory and Cannot open infile.
  Cause: Singularity couldn’t create or access temporary files due to the /scratch directory being read-only.
  Fix:
1. Created a local writable directory temp_dir and used the --bind option to bind it to /scratch.
2.Corrected the align_hsp70.sh script to include the proper --bind option:
	```singularity exec --bind $(pwd)/temp_dir:/scratch /project/stuckert/nkuruvad/mafft.sif 		mafft --auto --thread 10 data/processed/combined_hsp70.fa > 					data/results/alignment/combined_hsp70_aligned.fa```
3.Re-ran the alignment script after fixing the issues:
	```sbatch scripts/align_hsp70.sh```
4.Verified the results:
	Alignment successfully completed.
	Output file generated: `data/results/alignment/combined_hsp70_aligned.fa.`

Error Log:
	Error Message: mktemp: No such file or directory.
	Solution: Created a local temp_dir and bound it using --bind in the Singularity command.

Commands Used:
	1.Created the temporary directory
		```mkdir temp_dir```
	2.Submitted the job:
		```sbatch scripts/align_hsp70.sh```

Outcome:
	Successfully aligned the sequences in combined_hsp70.fa using MAFFT.
	Results saved in: data/results/alignment/combined_hsp70_aligned.fa.

### Tree Construction
- built phylogenetic tree using IQ-TREE with the LG model and 1000 bootstrap replicates.
#### **Steps Taken:**
1. Prepared the aligned file `combined_hsp70_aligned.fa` for tree construction.
2. Used IQ-TREE to construct a maximum likelihood tree with 1000 bootstraps.
   - **Command:**
     ```bash
     iqtree -s data/results/alignment/combined_hsp70_aligned.fa -m LG -bb 1000 -pre data/results/tree/hsp70_tree
     ```
3. Submitted the job using `scripts/build_tree.sh`.
4. Verified that the tree files were successfully created:
   - `data/results/tree/hsp70_tree.treefile`
   - `data/results/tree/hsp70_tree.iqtree`
   - `data/results/tree/hsp70_tree.boot`

#### **Outcome:**
- Successfully created a phylogenetic tree.
- Output ready for visualization in R.

### Notes
- no Hsp70 results found in *Castor canadensis* or *Mus musculus* files.
- proceeding with the Hsp70 focus for phylogenetic analysis.

##Day 3 - Blast
### BLAST Analysis

#### **Step 1: Database Setup**
1. Downloaded the SwissProt database and created a BLAST database named `spdb` using the `makespdb.sh` script.
   - Database files are stored in the `swissprot/` directory.

#### **Step 2: Preparing Query Sequences**
1. Copied the aligned sequences file:
   ```bash
   cp results/alignment/combined_hsp70_aligned.fa results/alignment/combined_hsp70_blast.fa
   ```
2. Removed alignment gaps (`-`) to prepare for BLAST:
   ```bash
   sed 's/-//g' results/alignment/combined_hsp70_blast.fa > results/alignment/combined_hsp70_blastdb.fa
   ```
   - Output: `results/alignment/combined_hsp70_blastdb.fa`

#### **Step 3: Running BLAST**
1. Created a SLURM script `run_blast_swissprot.sh`:
   ```bash
   #!/bin/bash
   #SBATCH --job-name=blast_swissprot
   #SBATCH --output=logs/blast_swissprot.out
   #SBATCH --error=logs/blast_swissprot.err
   #SBATCH --time=02:00:00
   #SBATCH --cpus-per-task=10
   #SBATCH --mem=32G

   blastp -query results/alignment/combined_hsp70_blastdb.fa -db swissprot/spdb -out results/blast/blast_results.txt -evalue 1e-5 -outfmt 6 -num_threads 10

   echo "BLASTP against SwissProt database completed."
   ```
   - Output: `results/blast/blast_results.txt`

#### **Step 4: Filtering BLAST Results**
1. Filtered the BLAST results for significant hits:
   ```bash
   awk '$11 <= 1e-5' results/blast/blast_results.txt > results/blast/significant_hits.txt
   ```
   - Output: `results/blast/significant_hits.txt`

---

#### **Next Steps**
- Analyze `significant_hits.txt` for functional insights.
- Visualize BLAST results to identify trends and key homologs.
