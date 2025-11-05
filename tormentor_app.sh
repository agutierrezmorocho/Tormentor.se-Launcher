#!/bin/bash
# -----------------------------------------------------------------
# Script for processing various samples with tormentor
# REMEMBER THE TORMENTOR CONDA ENVIRONMENT MUST BE ACTIVATED FOR THIS SCRIPT TO WORK
# conda activate /scratch/$USER/fis_env/tormentor
# -----------------------------------------------------------------


## --- HELP ---

help_info(){
	echo "			
			╻  ┏━┓╻ ╻┏┓╻┏━╸╻ ╻┏━╸┏━┓   ╺┳╸┏━┓┏━┓┏┳┓┏━╸┏┓╻╺┳╸┏━┓┏━┓ ┏━┓┏━╸
			┃  ┣━┫┃ ┃┃┗┫┃  ┣━┫┣╸ ┣┳┛    ┃ ┃ ┃┣┳┛┃┃┃┣╸ ┃┗┫ ┃ ┃ ┃┣┳┛ ┗━┓┣╸ 
			┗━╸╹ ╹┗━┛╹ ╹┗━╸╹ ╹┗━╸╹┗╸    ╹ ┗━┛╹┗╸╹ ╹┗━╸╹ ╹ ╹ ┗━┛╹┗╸╹┗━┛┗━╸
"
	echo ""
	echo "Script description
----------------------------------------------------------------------------------------
This scripts uses the tormentor.se (https://github.com/omixlab/tormentor) pipeline on .fastq files from RNA-seq proyects in search of viroids-like contigs.These contigs could be from obelisks, which are a distinct group of microbiome-associated viroid-like RNAs.The pipeline have some changes to the management of files created during processing.

The INPUT directory will be a directory where all the samples directories are stored. Uses the output directory after using the tool prefetch from SRATools. The structure is a directory containing subdirectories for each sample, where the name of this subdirs is the samples ID's

A report containing the standar ourput of the tormentor pipeline is created automatically
-----------------------------------------------------------------------------------------
"
	echo ""
	echo "Usage: $(basename $0) -i <input_dir> -t <threads> -o <output_directory> -d <data_dir> "
	echo ""
	echo "Required arguments:"
	echo "	-i <path_to_input_dir>	Directory where all the samples directories are stored"
	echo "	-t <threads>		Threads used by the process. Value [Integer]"
	echo "	-o <path_to_output_dir>	Output directory where all the proccessed files wil be placed"
	echo "	-d <path_to_data_dir>	Custom database containing oblin sequences and ribozymes sequences"
	echo""
	echo "Optional arguments:"	
	echo "	-h	Show the help info"
	echo ""
}

## --- OPTION CONFIGURATION --- 
while getopts "i:t:o:d:h" opt; do
	case ${opt} in
	i)
		SAMPLE_DIR="${OPTARG}";;
	f)
		READ_1="${OPTARG}";;
	F)
		READ_2="${OPTARG}";;
	t)
		THREADS="${OPTARG}";;
	o)
		OUTPUT_DIR="${OPTARG}";;
	d)
		DATA_DIR="${OPTARG}";;
	h)
		help_info
		exit 0;;
	\?)
		echo "ERROR: Option not possible ${OPTARG}" >&2
		help_info
		exit 1;;
	:)
		echo "ERROR: The option -${OPTARG} requires an argument" >&2
		help_info
		exit 1;;
	esac
done

# Exception with no arguments
if [[ "$#" -eq 0 || "$#" -eq 1 ]]; then
	echo ""
	echo "ERROR: Need at least 4 arguments, -i  -t  -o  -d. SEE USAGE" >&2
	echo ""
   	# Print help_info in case of error
    	help_info
	exit 1
fi

# OUTPUT_DIR is created if it isn't present in the directory
if [ ! -d $OUTPUT_DIR ]; then
        mkdir -p "${OUTPUT_DIR}"
fi

# Forward and Reverse files pattern after the sample ID:
R1="_1.fastq"
R2="_2.fastq"

## --- STEP 1: Store the samples ID into an array ---

# Empty array is created to store the samples ID's
declare -a sample_ids=()

echo "Identifying samples..."

        # If all the samples begin with S or E, this expression prevents the script interruption
shopt -s nullglob

# Loop to store the samples ID's
for dir_path in "$SAMPLE_DIR"/{S,E,D}*; do
	# Obtain the ID of the sample
	ID=$(basename "$dir_path")
        
	# The ID is added to the array
	sample_ids+=("$ID")
	echo "  -> Sample found: $ID"
done

# Array is not empty
if [ ${#sample_ids[@]} -eq 0 ]; then
    echo "FATAL ERROR! No sample ID in $SAMPLE_DIR."
    exit 1
fi

echo "Found ${#sample_ids[@]} samples."
echo "---"

## --- STEP2. USING TORMENTOR.SE ---

for sample in "${sample_ids[@]}"; do
	
	# Obtaining the ID of each sample
	sample_id=$(basename "${sample}")
	echo "Processing sample: ${sample_id}"
	
	# Defining the forward and reverse reads
	READ_1="${SAMPLE_DIR}/${sample}/${sample}${R1}"
	READ_2="${SAMPLE_DIR}/${sample}/${sample}${R2}"
	echo "Forward read: ${READ_1}"
	echo "Reverse read: ${READ_2}"
	
	# If the samples don't have any reads skip it
	if [ ! -f "$READ_1" ] || [ ! -f "$READ_2" ]; then
		echo "WARNING! No reads were found for the sample:  ${sample_id}"
       		echo "Skiping this sample: ${sample_id}."
       		echo "---"
       		continue
	fi
	
	# Making a directory for each sample
	sample_output_dir="${OUTPUT_DIR}/${sample_id}"

	mkdir -p "$sample_output_dir"
	echo "Output directory: ${sample_output_dir}"
	# Tormentor 
	nohup tormentor --reads $READ_1 $READ_2 --threads $THREADS --output $sample_output_dir --data-directory $DATA_DIR >${OUTPUT_DIR}/${sample}_report.txt 
done
