#!/bin/bash
#SBATCH -A <your_allocation>
#SBATCH --job-name=CuO_slabovac
#SBATCH --output=CuO_slabovac.%j.out
#SBATCH --error=CuO_slabovac.%j.err
#SBATCH --time=48:00:00
#SBATCH --partition=***
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --export=ALL

module load anaconda3/2022.05
conda create -n bader_env -c conda-forge bader -y
conda activate bader_env
#module load gcc
#module load openmpi
module load qe/7.3.1-cpu

#pw.x -in CuO_slabovac_relax.in > relax.out
pw.x -in CuO_slabovac_scf.in > scf.out
pw.x -in CuO_slabovac_nscf.in > nscf.out
dos.x -in CuO_slabovac_dos.in > dos.out
projwfc.x -in CuO_slabovac_pdos.in > pdos.out

pp.x < pp_ovac.in > pp_ovac.out
bader CuO_slab_Ovac_rho.cube
