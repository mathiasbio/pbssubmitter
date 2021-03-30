#!/bin/bash -l

echo "warning this script will add stuff to your .bashrc
aliases specifically, called:
*
submit_small $(pwd)/submit_wrapper.sh small (for submitting jobs with 4 cores)
*
submit_medium $(pwd)/submit_wrapper.sh medium (for submitting jobs with 8 cores)
*
submit_large $(pwd)/submit_wrapper.sh large (for submitting jobs with 12 cores)
*
asamtools echo singularity run --bind /hpcnfs /hpcnfs/techunits/bioinformatics/singularity/gatk_4.1.9.0.sif samtools (an example command for running samtools through a singularityimage)"

echo "do you want to do this?"
read -p 'Answer (y/n)' answer
if [ "$answer" == "y" ]; then
    here=$(pwd)
    echo "" >> ~/.bashrc
    while read aliasy; do
        aliasname=$(echo "$aliasy" | cut -d"=" -f1 | cut -d" " -f2)
        if [ -z "$(grep $aliasname ~/.bashrc)" ]; then
            echo "$aliasy" | sed 's|PWD|'$here'|g' >> ~/.bashrc
        fi
    done<aliases 
    source ~/.bashrc
else
    echo "exiting..."
fi
