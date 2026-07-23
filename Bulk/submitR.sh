#!/bin/bash
#SBATCH -A <your_allocation>
#SBATCH --job-name=CuO_relax
#SBATCH --output=CuO_relax.%j.out
#SBATCH --error=CuO_relax.%j.err
#SBATCH --time=48:00:00
#SBATCH --partition=parallel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --export=ALL
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=<your_email>


module load anaconda3/2022.05
conda create -n bader_env -c conda-forge bader -y
conda activate bader_env
#module load gcc
#module load openmpi
module load qe/7.3.1-cpu

#pw.x -in CuO_bulk_relax.in > relax.out
pw.x -in CuO_bulk_scf.in > scf.out
pw.x -in CuO_bulk_nscf.in > nscf.out
dos.x -in CuO_bulk_dos.in > dos.out
projwfc.x -in CuO_bulk_pdos.in > pdos.out

pp.x < pp_bulk.in > pp_bulk.out
bader CuO_bulk_rho.cube
