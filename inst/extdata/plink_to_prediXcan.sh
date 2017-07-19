#!/bin/bash -l

#SBATCH --array=1-22
#SBATCH --job-name=plink_predict
#SBATCH --output=plink_to_prediXcan_%A_%a.out
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=18G
#SBATCH --time=8:00:00

cd ~/bigdata/predixcan/scripts

python plink_to_prediXcan.py ~/bigdata/U24/GWAScohorts/MrOS/plink1KG/chr${SLURM_ARRAY_TASK_ID}.plink.dose ~/bigdata/predixcan/data/input/MrOS/map_files/${SLURM_ARRAY_TASK_ID}_map.txt ~/bigdata/predixcan/data/input/MrOS/dose_files/ chr${SLURM_ARRAY_TASK_ID}.dosage.txt

