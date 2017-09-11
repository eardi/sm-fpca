function [Points, Weights] = Quad_On_Interval(Num_Quad)
%Quad_On_Interval
%
%   This routine gives the quadrature rule for integrating on the unit
%   interval, i.e. the "reference" interval = [0, 1].
%   Note:  this is a Gauss quadrature rule.
%
%   [Points, Weights] = Quad_On_Interval(Num_Quad);
%
%   OUTPUTS
%   -------
%   Points:
%       An N x 1 array, where N is the number of quadrature points.
%       Each row gives the x-coordinates of the point.
%
%   Weights:
%       An N x 1 array, where N is the number of quadrature points.
%       Each row gives the weight assigned to the corresponding point.
%       WARNING: the quadrature weights are scaled so they sum to 1;
%                this is the length of the reference interval.
%
%   INPUTS
%   ------
%   Num_Quad:
%       A positive integer N = the number of quadrature points to use.
%       Note:  see the file "GaussQuad.m" for more details.

% Copyright (c) 09-21-2015,  Shawn W. Walker

% on the unit interval [0, 1]
[Points, Weights] = GaussQuad(Num_Quad,0,1);

end