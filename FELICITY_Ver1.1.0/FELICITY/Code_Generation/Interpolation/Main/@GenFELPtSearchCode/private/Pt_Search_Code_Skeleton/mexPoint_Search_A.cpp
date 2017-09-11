/*
============================================================================================
   This is the main "gateway" routine that interfaces MATLAB with a custom point searching
   code (useful for finding interpolation points).

   See other accompanying files for more details.

   NOTE: this code was generated from the FELICITY package:
         Finite ELement Implementation and Computational Interface Tool for You

   OUTPUTS
   -------
   plhs[0] = POINTS(1).DATA{Cell_Indices, Local_Ref_Coord}, POINTS(1).Name,
             POINTS(2).DATA{Cell_Indices, Local_Ref_Coord}, POINTS(2).Name, etc...

   NOTE: portions of this code are automatically generated!

   WARNING!: Make sure all inputs to this mex function are NOT sparse matrices!!!
             Only FULL matrices are allowed as inputs!!!

   Copyright (c) 06-16-2014,  Shawn W. Walker
============================================================================================
*/

// default libraries you need
#include <algorithm>
#include <cstring>
#include <math.h>
#include <mex.h> // <-- This one is required

