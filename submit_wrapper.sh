#!/bin/bash -l

jobsize=$(echo "$1")
argument=$(echo "$2")

date=$(date '+%y%m%d_%H%M%S')
user=$(whoami)

if [ "$jobsize" == "small" ]; then
    threads=4
elif [ "$jobsize" == "medium" ]; then
    threads=8
elif [ "$jobsize" == "large" ]; then
    threads=12
else
    echo "jobsize does not exist"
    exit
fi

argument_tool=$(echo "$argument" | sed 's/\(singularity.*\.sif \)//g' | cut -d" " -f1,2 | sed 's/ /_/g')
if [ ! -z "$(echo "$argument_tool" | grep "/")" ]; then
    argument_tool=$(basename $argument_tool)
fi
jobname=$(echo "${argument_tool}_${user}_${date}")

# setting log and scripts dir and creating if they do not already exist
logs=$(echo "/hpcnfs/home/$user/scripts/run_jobs/qsubouts")
scripts=$(echo "/hpcnfs/home/$user/scripts/run_jobs/qsubscripts")
if [ ! -d "$logs" ]; then
    mkdir -p $logs
fi
if [ ! -d "$scripts" ]; then
    mkdir -p $scripts
fi

# preparations for creating the qsub-script for your job
cp $scripts/template_qsub.sh $scripts/${jobname}_qsub.sh
qsubscript=$(echo "$scripts/${jobname}_qsub.sh")

# appending argument to template script to create the qsub-script
echo $argument >> $qsubscript

# logging some stuff
echo "creating qsubscript: $qsubscript with this argument:"
echo "$argument"
echo "qsubbing script $qsubscript with this command:"
echo "qsub -N $jobname -l select=1,ncpus=$threads -o $logs/${jobname}.STDOUT -e $logs/${jobname}.STDERR $qsubscript"
echo "qsub -N $jobname -l select=1,ncpus=$threads -o $logs/${jobname}.STDOUT -e $logs/${jobname}.STDERR $qsubscript" >> $logs/${jobname}.STDOUT

# submitting created qsub-script
qsub -N $jobname -l nodes=1,ncpus=$threads -o $logs/${jobname}.STDOUT -e $logs/${jobname}.STDERR $qsubscript

