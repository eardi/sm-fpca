% FELICITY Class for 1-D Meshes.
%
%   obj  = MeshInterval(Edge,Vtx,Name);
%
%   Edge = Rx2 matrix representing the edge connectivity of the 1-D mesh; R =
%          number of elements.
%   Vtx  = MxD matrix representing the coordinates of the vertices; M = number
%          of vertices, and D = geometric dimension.
%   Name = (string) name for the domain that the mesh represents.
classdef MeshInterval < AbstractMesh
    properties %(Access = private)
        
    end
    methods
        function obj = MeshInterval(varargin)
            
            if (nargin ~= 3)
                disp('Requires 3 arguments!');
                disp('First  is cell connectivity.');
                disp('Second is vertex coordinates.');
                disp('Third  is an appropriate name for what the mesh represents (domain).');
                error('Check the arguments!');
            end
            
            obj    = obj@AbstractMesh(varargin{3});
            obj.TR = EdgeRep(varargin{1},varargin{2});
            
            TD = obj.Top_Dim;
            if (TD~=1)
                disp('Cell connectivity must have 2 columns for interval (edge) mesh!');
                error('Edge mesh must have topological dimension 1!');
            end
            
            GD = obj.Geo_Dim;
            if (GD==1)
                VOL = obj.Volume;
                if min(VOL) <= 0
                    error('Edge mesh has inverted (or degenerate) elements!');
                end
            end
        end
        function EI = vertexAttachments(obj,varargin)
            %vertexAttachments
            %
            %   See also EdgeRep.vertexAttachments.
            EI = obj.TR.vertexAttachments(varargin{1:end});
        end
        function [Center, Edge_Length] = circumcenter(obj,varargin)
            %circumcenter
            %
            %   See also EdgeRep.circumcenter.
            [Center, Edge_Length] = obj.TR.circumcenter(varargin{1:end});
        end
        function EDGE = edges(obj)
            %edges
            %
            %   See also EdgeRep.edges.
            EDGE = obj.TR.edges;
        end
        function [ET, Edge_Length] = edgeTangent(obj,varargin)
            %edgeTangent
            %
            %   See also EdgeRep.edgeTangent.
            [ET, Edge_Length] = obj.TR.edgeTangent(varargin{1:end});
        end
        function FP = featurePoints(obj,FILTERANGLE)
            %featurePoints
            %
            %   See also EdgeRep.featurePoints.
            FP = obj.TR.featurePoints(FILTERANGLE);
        end
        function [FV, FX] = freeBoundary(obj)
            %freeBoundary
            %
            %   See also EdgeRep.freeBoundary.
            if (nargout==1)
                FV = obj.TR.freeBoundary;
                FX = [];
            elseif (nargout==2)
                [FV, FX] = obj.TR.freeBoundary;
            else
                error('Invalid!');
            end
        end
        function [TF, LOC] = isConnected(obj,varargin)
            %isConnected
            %
            %   See also EdgeRep.isConnected.
            [TF, LOC] = obj.TR.isConnected(varargin{1:end});
        end
        function EN = neighbors(obj,varargin)
            %neighbors
            %
            %   See also EdgeRep.neighbors.
            EN = obj.TR.neighbors(varargin{1:end});
        end
        function VT = vertexTangent(obj,varargin)
            %vertexTangent
            %
            %   See also EdgeRep.vertexTangent.
            VT = obj.TR.vertexTangent(varargin{1:end});
        end
        function SIZE = size(obj)
            %size
            %
            %   See also EdgeRep.size.
            SIZE = obj.TR.size;
        end
        function XC = barycentricToCartesian(obj,EI,BC)
            %barycentricToCartesian
            %
            %   See also EdgeRep.barycentricToCartesian.
            XC = obj.TR.barycentricToCartesian(EI,BC);
        end
        function BC = cartesianToBarycentric(obj,EI,XC)
            %cartesianToBarycentric
            %
            %   See also EdgeRep.cartesianToBarycentric.
            BC = obj.TR.cartesianToBarycentric(EI,XC);
        end
        function [VI, D] = nearestNeighbor(obj,varargin)
            %nearestNeighbor
            %
            %   See also EdgeRep.nearestNeighbor.
            if (nargout==1)
                VI = obj.TR.nearestNeighbor(varargin{1:end});
                D  = [];
            elseif (nargout==2)
                [VI, D] = obj.TR.nearestNeighbor(varargin{1:end});
            else
                error('Invalid!');
            end
        end
        function [TI, BC] = pointLocation(obj,varargin)
            %pointLocation
            %
            %   See also EdgeRep.pointLocation.
            if (nargout==1)
                TI = obj.TR.pointLocation(varargin{1:end});
                BC = [];
            elseif (nargout==2)
                [TI, BC] = obj.TR.pointLocation(varargin{1:end});
            else
                error('Invalid!');
            end
        end
    end
end

% END %