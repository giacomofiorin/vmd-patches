# VMD patches

Visual Molecular Dynamics (VMD) is a molecular visualization program developed by the University of Illinois at Urbana-Champaign (UIUC):
[http://www.ks.uiuc.edu/Research/vmd](http://www.ks.uiuc.edu/Research/vmd)

This repository includes contributions that are not (yet) part of the VMD distribution.  To comply with the UIUC license, only patches are distributed but not the original files.  Feel free to copy, modify or add patches to suit your needs.

The only change currently included enables using the legacy `volmap` command with dynamic selections (`volmap-fix` folder).

The standard Unix method can be used to update a VMD source tree:
```
patch -p1 < patch-name.diff -d VMD-source-top-directory
```
`patch` is a standard utility in Linux and MacOS, also available on Windows via the [UnxUtils](https://sourceforge.net/projects/unxutils/) package.

Please see [here](http://www.ks.uiuc.edu/Research/vmd/doxygen/compiling.html#compiling) for instructions about how to compile VMD from source.
