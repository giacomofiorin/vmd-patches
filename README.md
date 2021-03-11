# VMD patches

[Visual Molecular Dynamics (VMD)](http://www.ks.uiuc.edu/Research/vmd) is a molecular visualization program developed by the University of Illinois at Urbana-Champaign (UIUC).

This repository includes contributions that are not (yet) part of the VMD distribution.

To comply with the [UIUC license](http://www.ks.uiuc.edu/Research/vmd/current/LICENSE.html), only patches are distributed but not the original files.  For ease of distribution, the patches are available under the open-source LGPL license: however, the code that they provide is meant to be included in VMD.

If a certain diff file is empty, it means that the corresponding change has been already merged into the [current development version](https://www.ks.uiuc.edu/Research/vmd/doxygen/cvsget.html) of VMD.  Nonetheless, test or example files are retained after merging for comparison against older VMD versions.

The following patches are included in this repository:


- `c++11`: This patch enables building VMD with the C++11 standard, allowing to include in the resulting build newer code that requires it, like the `lepton` patch or [certain features](https://colvars.github.io/README-c++11.html) of the [Colvars](https://colvars.github.io) module.

  _Status:_ not included in the main VMD distribution yet; a patch is available for the VMD CVS snapshot of date 2021-02-24.


- `lepton`: This change adds a VMD build recipe for the [Lepton](https://simtk.org/projects/lepton) library, which is available from the [OpenMM](https://github.com/openmm/openmm) package.  The source code of the Lepton library should be copied into `lib/lepton` to allow using the new `LEPTON` flag in the `configure` script.  Feel free to use the `add_lepton.sh` script to automatically download it: Lepton is distributed unter the [MIT license](https://opensource.org/licenses/MIT).  Unless you copy a pre-compiled Lepton library into `lib/lepton/lib_$config_arch` before building VMD, you will also need to apply the `c++11` patch first to enable C++11 for the entire VMD build.

  _Status:_ not included in the main VMD distribution yet; a patch is available for the VMD CVS snapshot of date 2021-02-24.


- `volmap-fix`: This change fixes a bug in the `volmap` utility when dynamic selections are used (i.e. when the set of atoms changes between trajectory frames).  Files in [this folder](volmap-fix/test) allow to compare behavior with different VMD versions; because the bug is caused by an out-of-bounds memory access, it is advisable to repeat the test a few times.

  _Status:_ included in [VMD CVS](https://www.ks.uiuc.edu/Research/vmd/doxygen/cvsget.html) since 2019-01-23, patch available for VMD 1.9.3 in the `v1.9.3` branch.

The standard Unix method can be used to update a VMD source tree:
```
patch -p1 < patch-name.diff -d VMD-source-top-directory
```
`patch` is a standard utility in Linux and MacOS, also available on Windows via the [UnxUtils](https://sourceforge.net/projects/unxutils/) package.

**See also** the README of the [Colvars](https://github.com/Colvars/colvars) repository to update VMD with the latest version of the Colvars module.

Please see [here](http://www.ks.uiuc.edu/Research/vmd/doxygen/compiling.html#compiling) for instructions about how to compile VMD from source.
