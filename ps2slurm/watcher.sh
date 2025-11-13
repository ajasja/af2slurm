#!/bin/bash
#SBATCH -J ps2slurm-watch
#SBATCH -t 7-00:00:00
#SBATCH -p gpu
#SBATCH --gres=gpu:A40:1
#SBATCH --cpus-per-task=2
#SBATCH -x compute-0-10

python /home/d12/ps2slurm/ps2slurm_v1/ps2slurm-watcher.py \
  --config /home/d12/ps2slurm/ps2slurm_v1/ps2slurm.config 