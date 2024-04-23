#!/bin/bash
#SBATCH --ntasks-per-node=8
#SBATCH -t 14-00:00:00
#SBATCH --partition=normal
#SBATCH -A coa_tska223_uksr


version=1.0
threads=8
author=kai
outdir=$(pwd)

# Function to display script usage
usage() {
    echo "Usage: $0 -f <original fasta file> -m <sequences name replacement file> [-o <output file name>] [-t] "
    echo "OR submit it to the MCC using: sbatch $0 -f <original fasta file> -m <sequences name replacement file> [-o <output file name>] [-t] "
    echo "Options:"
    echo "  -f <original fasta file>: Required original file"
    echo "  -m <sequences name replacement file>: Required equences replacement file (old name in 1st column and new name in 2nd column)"
    echo "  -o: Optional output file name (Default= modified.fa)"
    echo "  -t: Optional print time consumption (Default= No)"
    exit 1
}

# Check if no arguments are passed
if [ $# -eq 0 ]; then
    usage
fi

# Parsing the arguments using a while loop
while getopts ":f:m:o:t" opt; do
    case $opt in
	f)
            input_file=$OPTARG
            ;;
        m)
            sequence_name=$OPTARG
            ;;
        o)
            output_name=$OPTARG
            ;;
	t)
            time_option=true
            ;;
	\?)
            echo "Invalid option: -$OPTARG"
            usage
            ;;
	:)
            echo "Option -$OPTARG requires an argument."
            usage
            ;;
    esac
done


# Check if the required original fasta file and sequences name file are provided
if [ -z "$input_file" ] || [ -z "$sequence_name" ]; then
    echo "***********"
    echo "two files must be provided using -f and -m option."
    echo "***********"
    usage
fi

#remove whole line after the first blank in sequence line. 
sed -E 's/^([^ ]+).*/\1/' $input_file > input_tem

#cerate an array
declare -A name_mapping
#read old and new name to store in the array
modify_fasta_process() {
while IFS=$'\t' read -r current_name new_name; do
  name_mapping["$current_name"]="$new_name"
done < "$sequence_name"

#read input file and modify the sequence name
while IFS= read -r line; do
  if [[ $line == ">"* ]]; then
    current_name="${line:1}" 
    if [[ -n "${name_mapping[$current_name]}" ]]; then
      new_name="${name_mapping[$current_name]}"
      echo ">$new_name" 
    else
      echo "$line"  #if no match the name then print old name
    fi
  else
    #print sequences line
    echo "$line"
  fi
done
}

# Run the script with or without time measurement
if [ "$time_option" = true ]; then
    time modify_fasta_process < input_tem > "${output_name:-modified.fa}" && rm input_tem
else
    modify_fasta_process < input_tem > "${output_name:-modified.fa}" && rm input_tem
fi


