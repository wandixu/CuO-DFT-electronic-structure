# CuO DFT+U Electronic Structure — Bulk, (111) Surface, and Oxygen Vacancy

DFT+U study, using Quantum ESPRESSO, of the electronic structure of **bulk CuO**, the **clean CuO(111) surface**, and the **CuO(111) surface with a surface oxygen vacancy**. Geometry optimization, self-consistent field (SCF), non-self-consistent field (NSCF), and density-of-states (DOS/PDOS) calculations are used to compare the Cu 3d electronic states across the three systems and to evaluate how surface formation and oxygen-vacancy creation modify the electronic properties.

> **Context (optional — edit or delete):** This repository contains the DFT computational component of a broader study on the effects of nano- versus bulk-CuO surfaces on plant growth.

## Systems studied

1. **Bulk CuO** — 4-atom cell (`Bulk/`)
2. **Clean CuO(111) slab** — 32-atom slab with vacuum (`Clean_Slab/`)
3. **CuO(111) slab + O vacancy** — 31-atom slab, one surface O atom removed (`O_Vacancy/`)

## Method

- **Code:** Quantum ESPRESSO 7.3.1 (`pw.x`, `dos.x`, `projwfc.x`, `pp.x`)
- **Functional:** PBE (GGA)
- **Hubbard correction:** DFT+U, ortho-atomic projectors, U(Cu-3d) = 5.0 eV
- **Pseudopotentials:** PAW (pslibrary / SSSP): `Cu.pbe-dn-kjpaw_psl.1.0.0.UPF`, `O.pbe-n-kjpaw_psl.0.1.UPF`
- **Spin:** spin-polarized (`nspin = 2`), initial magnetization placed on Cu
- **Smearing:** Marzari–Vanderbilt, `degauss = 0.02 Ry` (SCF/relax); optimized tetrahedron method for NSCF/DOS
- **Charge analysis:** Löwdin (PDOS) and Bader

### Computational parameters

| Parameter | Bulk | Clean slab | O-vacancy slab |
|---|---|---|---|
| Atoms | 4 | 32 | 31 |
| ecutwfc / ecutrho — relax | 90 / 720 Ry | 60 / 480 Ry | 60 / 480 Ry |
| ecutwfc / ecutrho — SCF & NSCF | 90 / 720 Ry | 90 / 720 Ry | 90 / 720 Ry |
| k-points — relax | 6×6×6 | 4×4×1 | 4×4×1 |
| k-points — SCF | 6×6×6 | 6×6×1 | 6×6×1 |
| k-points — NSCF | 12×12×12 | 12×12×1 | 12×12×1 |
| conv_thr — SCF | 1×10⁻⁸ | 1×10⁻⁸ | 1×10⁻⁸ |
| U(Cu-3d) | 5.0 eV | 5.0 eV | 5.0 eV |

> Note: geometry relaxations were performed at the GGA level (slabs at a reduced 60/480 Ry cutoff); DFT+U and spin polarization were applied in the SCF/NSCF electronic-structure steps at 90/720 Ry.

## Workflow

```
Bulk relax  →  Bulk SCF  →  Bulk NSCF  →  Bulk DOS / PDOS
                                                   │
                              Construct CuO(111) slab
                                                   │
Slab relax  →  Slab SCF  →  Slab NSCF  →  Slab DOS / PDOS
                                                   │
                                 Create O vacancy
                                                   │
Ovac relax  →  Ovac SCF  →  Ovac NSCF  →  Ovac DOS / PDOS
```

## Repository structure

```
.
├── Bulk/               # Bulk CuO: relax, scf, nscf, dos, pdos (inputs + outputs)
├── Clean_Slab/         # Clean CuO(111) surface calculations
├── O_Vacancy/          # CuO(111) slab with one surface oxygen vacancy
├── Pseudopotential/    # PAW pseudopotentials + reference CuO structure (.cif)
└── README.md
```

Each system folder follows the same naming pattern:

| File | Purpose |
|---|---|
| `*_relax.in` | Geometry optimization input |
| `*_scf.in` | Self-consistent field input |
| `*_nscf.in` | Non-self-consistent field input (dense k-grid) |
| `*_dos.in` / `*_pdos.in` | DOS / projected-DOS post-processing input |
| `*.out` | Corresponding Quantum ESPRESSO output logs |
| `*.dos`, `*.pdos.dat.pdos_tot` | Total / projected DOS data |
| `submitR.sh` | SLURM job script |

## Requirements

- Quantum ESPRESSO ≥ 7.1 (the `HUBBARD (ortho-atomic)` card requires v7.1+; developed here with 7.3.1)
- The PAW pseudopotentials in `Pseudopotential/`
- A DFT-capable machine; the provided `submitR.sh` scripts target a SLURM cluster

## How to run

Each folder's `submitR.sh` runs the full chain. The core commands (bulk example):

```bash
pw.x       -in CuO_bulk_relax.in > relax.out
pw.x       -in CuO_bulk_scf.in   > scf.out
pw.x       -in CuO_bulk_nscf.in  > nscf.out
dos.x      -in CuO_bulk_dos.in   > dos.out
projwfc.x  -in CuO_bulk_pdos.in  > pdos.out
```

Before submitting, update `pseudo_dir` / `outdir` in the input files and the SLURM header (`-A <your_allocation>`, `--mail-user=<your_email>`) for your own environment.

## Citation

If you use these inputs or data, please cite this repository. _(Add paper / DOI here once available.)_

## License

Released under the MIT License — see [LICENSE](LICENSE).
