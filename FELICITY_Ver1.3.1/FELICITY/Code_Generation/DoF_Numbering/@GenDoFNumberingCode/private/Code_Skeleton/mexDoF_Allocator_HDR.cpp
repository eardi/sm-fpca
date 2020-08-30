/*
============================================================================================
   This is the main "gateway" routine that interfaces MATLAB with a custom
   FEM Degree-of-Freedom (DoF) allocator for a particular finite element.

   NOTE: this code is part of the FELICITY package:
   Finite ELement Implementation and Computational Interface Tool for You

   OUTPUTS
   -------
   Matrix where each row is the local-to-global DoF map for an element in the mesh.
   (see code below for more info)

   NOTE: portions of this code are automatically generated!

   WARNING!: Make sure all inputs to this mex function are NOT sparse matrices!!!
             Only FULL matrices are allowed as inputs!!!

   Copyright (c) 10-16-2016,  Shawn W. Walker
============================================================================================
*/

// include any libraries you need here
#include <algorithm>
#include <mex.h> // <-- This one is required

