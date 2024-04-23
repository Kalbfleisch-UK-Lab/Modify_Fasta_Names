# Modify_Fasta_Names

Usage: ./modify_fasta_names.sh2 -f \<original fasta file> -m \<sequences name replacement file> [-o \<output file name>] [-t] 

OR submit it to the MCC using: sbatch modify_fasta_names.sh2 -f \<original fasta file> -m \<sequences name replacement file> [-o \<output file name>] [-t] 

Options:

  -f \<original fasta file>: Required original file
  
  -m \<sequences name replacement file>: Required equences replacement file (old name in 1st column and new name in 2nd column)
 
  -o: Optional output file name (Default= modified.fa)
 
  -t: Optional print time consumption (Default= No)
