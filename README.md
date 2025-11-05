# Tormentor.se-Launcher
Bash script created for using the pipeline tormentor.se (https://github.com/omixlab/tormentor) with a group of RNA-seq .fastq files. This pipeline is based on the tormentor pipeline (Kremer, F (2024). Tormentor: An obelisk prediction and annotation pipeline.).

# launch_tor Description
This scripts uses the tormentor.se (https://github.com/omixlab/tormentor) pipeline on .fastq files from RNA-seq proyects in search of viroids-like contigs.These contigs could be from obelisks, which are a distinct group of microbiome-associated viroid-like RNAs.The pipeline have some changes to the management of files created during processing.

The INPUT directory will be a directory where all the samples directories are stored. Uses the output directory after using the tool prefetch from SRATools. The structure is a directory containing subdirectories for each sample, where the name of this subdirs are the samples ID's

A report containing the standar output of the tormentor pipeline is created automatically

# How to use launch_tor
This is the guide for using this script, the same information will be shown when using "launch_tor -h" in the terminal. 

Usage: $(basename $0) -i <input_dir> -t <threads> -o <output_directory> -d <data_dir>

Required arguments:
		-i <path_to_input_dir>	Directory where all the samples directories are stored
	    -t <threads>		Threads used by the process. Value [Integer]
	    -o <path_to_output_dir>	Output directory where all the proccessed files wil be placed
	    -d <path_to_data_dir>	Custom database containing oblin sequences and ribozymes sequences
Optional arguments:
		  -h	Show the help info


