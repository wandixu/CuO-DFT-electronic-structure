#!/bin/bash
#SBATCH -A <your_allocation>
#SBATCH --job-name=CuO_slab
#SBATCH --output=CuO_slab.%j.out
#SBATCH --error=CuO_slab.%j.err
#SBATCH --time=48:00:00
#SBATCH --partition=
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --export=ALL

module load anaconda3/2022.05
conda create -n bader_env -c conda-forge bader -y
conda activate bader_env
#module load gcc
#module load openmpi
module load qe/7.3.1-cpu

#pw.x -in CuO_slab_relax.in > relax.out
pw.x -in CuO_slab_scf.in > scf.out
pw.x -in CuO_slab_nscf.in > nscf.out
dos.x -in CuO_slab_dos.in > dos.out
projwfc.x -in CuO_slab_pdos.in > pdos.out

pp.x < pp_slab.in > pp_slab.out
bader CuO_slab_rho.cube
