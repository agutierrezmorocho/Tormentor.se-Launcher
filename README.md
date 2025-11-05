# Tormentor.se-Launcher
Bash script created for using the pipeline tormentor.se (https://github.com/omixlab/tormentor) with a group of RNA-seq .fastq files. This pipeline is based on the tormentor pipeline (Kremer, F (2024). Tormentor: An obelisk prediction and annotation pipeline.).

# Launc_Tor Description
This scripts uses the tormentor.se (https://github.com/omixlab/tormentor) pipeline on .fastq files from RNA-seq proyects in search of viroids-like contigs.These contigs could be from obelisks, which are a distinct group of microbiome-associated viroid-like RNAs.The pipeline have some changes to the management of files created during processing.

The INPUT directory will be a directory where all the samples directories are stored. Uses the output directory after using the tool prefetch from SRATools. The structure is a directory containing subdirectories for each sample, where the name of this subdirs is the samples ID's

A report containing the standar ourput of the tormentor pipeline is created automatically
