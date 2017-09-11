## Smooth Manifold FPCA (SM-FPCA)

This is a MATLAB implementation of the Smooth Manifold FPCA algorithm introduced in [E Lila, JAD Aston, LM Sangalli (2016)](https://projecteuclid.org/euclid.aoas/1483606843). The algorithm computes the principal components, and associated scores vectors, of a collection of functions whose domain is a 2D surface represented by a triangulated surface.

## Installation

Set the working directory by moving, with the command `cd 'your_working_directory'`, to the root directory containg the SM-FPCA scripts. Run the script `Init.m` with the command `run('Init.m')`. This script compiles some parts of the library [Felicity](https://github.com/walkersw/felicity-finite-element-toolbox/wiki) here used to compute the Finite Element discretization matrices.

## Example

The file `fPCA_script.m` contains a complete running example on synthetic data generated on a triangular surface representing the brain stem. If this runs correctly, it should be possible to apply the algorithm to your dataset by changing the paths pointing to the data.

## Output

The resulting scores vectors are saved in a .csv file. The resulting principal components are saved in the .vtk file format, which can be vizualized in Paraview.
