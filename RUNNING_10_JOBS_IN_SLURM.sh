#!/bin/bash
#SBATCH --time=1-00:00
#SBATCH --account="YOUR ACCOUNT NAME"
#SBATCH --job-name=demo
#SBATCH --array=0-10
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=24GB
#SBATCH -o PATH_TO_LOG/output-%j.out
#SBATCH -e PATH_TO_LOG/error-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user="INSERT EMAIL HERE"
