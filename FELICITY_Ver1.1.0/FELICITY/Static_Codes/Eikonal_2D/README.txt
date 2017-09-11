
       Hamilton-Jacobi solver on unstructured triangular grids
                 (C) 07/20/2009, Shawn W. Walker


DESCRIPTION
========================================================================

This code implements a variational solver for static Hamilton-Jacobi-Bellman type equations on unstructured triangular grids.

The implementation is based on the paper:

"Finite-Element Discretization Of Static Hamilton-Jacobi Equations Based On A Local Variational Principle" by F. Bornemann and C. Rasch

Comments:

1. There is no restriction on the type of triangulation, i.e. it does not need to be acute.  But the method will require more than one sweep of the mesh (because of lack of causality).  However, only a few iterations should be necessary to achieve convergence.


2. Two versions of the code are implemented.  One is pure MATLAB and the other uses a MEX function.  The MEX version is faster by about a factor of 100 for the example that I include.


3. The MEX version allows for a variable distance metric.  See the test code for a demonstration.


4. The MEX version uses a FIFO buffer to implement a non-linear adaptive Gauss-Seidel iteration (see the paper).  FIFO buffers cannot be easily implemented in pure MATLAB.


5. The MEX version C++ code uses Object-Oriented methods.


6. I put in a lot of error checking to make the code robust to user-error.  However, I make no claim that this software is completely correct!!!  Use it at your own risk!


USAGE
========================================================================

1. Make sure to run the `test_FELICITY.m' which will compile the Eikonal solver code.  Alternatively, you can use the file `compile_eikonal2D_solver.m'.


2. To run a demo, run this m-file: `test_eikonal2D.m'.


3. Warning!  Make sure the triangle meshes you use are positively oriented! This code *might* not work if the triangles are not positively oriented.


4. If you want a slightly more efficient initialization, modify the following files:

/@SolveEikonal2D/private/Get_Triangle_Neighbors.m
/@SolveEikonal2Dmex/private/Get_Triangle_Neighbors.m

to use `sparse2' instead of `sparse'.  <-- this can be found in the SuiteSparse package by Tim Davis.

