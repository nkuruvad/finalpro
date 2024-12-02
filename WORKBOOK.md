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
