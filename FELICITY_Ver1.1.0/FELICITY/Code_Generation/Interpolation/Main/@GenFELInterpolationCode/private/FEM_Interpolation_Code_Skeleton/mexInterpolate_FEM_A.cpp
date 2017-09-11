/*
============================================================================================
   This is the main "gateway" routine that interfaces MATLAB with a custom generated
   FE interpolator.  See other accompanying files for more details.

   NOTE: this code was generated from the FELICITY package:
         Finite ELement Implementation and Computational Interface Tool for You

   OUTPUTS
   -------
   plhs[0] = INTERP(1).DATA{:}, INTERP(1).Name, INTERP(2).DATA{:}, INTERP(2).Name, etc...

   NOTE: portions of this code are automatically generated!

   WARNING!: Make sure all inputs to this mex function are NOT sparse matrices!!!
             Only FULL matrices are allowed as inputs!!!

   Copyright (c) 01-29-2013,  Shawn W. Walker
============================================================================================
*/

// default libraries you need
#include <algorithm>
#include <cstring>
#include <math.h>
#include <mex.h> // <-- This one is required

