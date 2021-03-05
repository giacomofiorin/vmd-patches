# VMD patches

[Visual Molecular Dynamics (VMD)](http://www.ks.uiuc.edu/Research/vmd) is a molecular visualization program developed by the University of Illinois at Urbana-Champaign (UIUC).

This repository includes contributions that are not (yet) part of the VMD distribution.  To comply with the [UIUC license](http://www.ks.uiuc.edu/Research/vmd/current/LICENSE.html), only patches are distributed but not the original files.  Feel free to copy, modify or add patches to suit your needs.

If a diff file is empty, it means that the corresponding change has been already been merged into the [CVS repository](https://www.ks.uiuc.edu/Research/vmd/doxygen/cvsget.html) of VMD.  Test or example files are retained after merging to compare against older VMD versions.

The following changes are included in this repository:


- `c++11`: This patch enables building VMD with the C++11 standard, allowing to include in the resulting build newer code that requires it, like the `lepton` patch or [certain features](https://colvars.github.io/README-c++11.html) of the Colvars module.

  _Status:_ not included in the main VMD distribution yet; a patch is available for the VMD CVS snapshot of date 2021-02-24.


- `lepton`: This change adds a build recipe for the [Lepton](https://simtk.org/projects/lepton) library, which is available from the [OpenMM](https://github.com/openmm/openmm) package.  The source code of the Lepton library should be copied into `lib/lepton` to allow using the new `LEPTON` flag in the `configure` script (feel free to use the `add_lepton.sh` script to automatically download it).  Unless you copy a pre-compiled Lepton library into `lib/lepton/lib_$config_arch` before building VMD, you will also need to apply the `c++11` patch first to enable C++11 across the board for VMD.

  _Status:_ not included in the main VMD distribution yet; a patch is available for the VMD CVS snapshot of date 2021-02-24.


- `volmap-fix`: This change fixes a bug in the `volmap` utility when dynamic selections are used (i.e. when the set of atoms changes between trajectory frames).  Files in [this folder](volmap-fix/test) allow to compare behavior with different VMD versions; because the bug is caused by an out-of-bounds memory access, it is advisable to repeat the test a few times.

  _Status:_ included in [VMD CVS](https://www.ks.uiuc.edu/Research/vmd/doxygen/cvsget.html) since 2019-01-23, patch available for VMD 1.9.3 in the `v1.9.3` branch.

The standard Unix method can be used to update a VMD source tree:
```
patch -p1 < patch-name.diff -d VMD-source-top-directory
```
`patch` is a standard utility in Linux and MacOS, also available on Windows via the [UnxUtils](https://sourceforge.net/projects/unxutils/) package.

Please see [here](http://www.ks.uiuc.edu/Research/vmd/doxygen/compiling.html#compiling) for instructions about how to compile VMD from source.
