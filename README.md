# pbssubmitter

Just a set of small bashscripts and aliases to more easily submit jobs through the PBS cluster at IEO.

No need to write qsub scripts, you can simply run ./install.sh which will add some aliases to your .bashrc

Then you can use these aliases in the following way

**Example:**

submit_small "singularity run --bind /hpcnfs /hpcnfs/techunits/bioinformatics/singularity/gatk_4.1.9.0.sif samtools index /full/path/to/SRR5665260.Aligned.sortedByCoord.out.bam"

An example alias was also created to illustrate how the above samtools through singularity command could be run more easily with another alias:

alias asamtools='echo singularity run --bind /hpcnfs /hpcnfs/techunits/bioinformatics/singularity/gatk_4.1.9.0.sif samtools'

Where the same command would be instead:

submit_small "$(asamtools) index /full/path/to/SRR5665260.Aligned.sortedByCoord.out.bam"

### logging and generated qsub-scripts

The scripts works by generating qsub-scripts from the argument given to the alias. This is nice to keep track on what jobs you have done.
In the submit_wrapper.sh you can set your own qsub_scripts dir of choice as well as the place where the qsub standard outs and errs are placed.

You can customize this however you want...it's just a simple example
