% FELICITY Class for 3-D Tetrahedron Meshes.
%
%   obj  = MeshTetrahedron(Tet,Vtx,Name);
%
%   Tet  = Rx4 matrix representing the tetrahedron connectivity of the 3-D mesh;
%          R = number of elements.
%   Vtx  = MxD matrix representing the coordinates of the vertices; M = number
%          of vertices, and D = geometric dimension (must be 3).
%   Name = (string) name for the domain that the mesh represents.
classdef MeshTetrahedron < AbstractMesh
    properties %(Access = private)
        
    end
    methods
        function obj = MeshTetrahedron(varargin)
            
            if (nargin ~= 3)
                disp('Requires 3 arguments!');
                disp('First  is cell connectivity.');
                disp('Second is vertex coordinates.');
                disp('Third  is an appropriate name for what the mesh represents (domain).');
                error('Check the arguments!');
            end
            
            obj    = obj@AbstractMesh(varargin{3});
            obj.TR = triangulation(varargin{1},varargin{2});
            
            TD = obj.Top_Dim;
            if (TD~=3)
                disp('Cell connectivity must have 4 columns for tetrahedron mesh!');
                error('Tetrahedron mesh must have topological dimension 3!');
            end
            
            VOL = obj.Volume;
            if min(VOL) <= 0
                error('Tetrahedron mesh has inverted (or degenerate) elements!');
            end
        end
        function PC = barycentricToCartesian(obj,TI,PB)
            %barycentricToCartesian
            %
            %   See also triangulation.barycentricToCartesian.
            PC = obj.TR.barycentricToCartesian(TI, PB);
        end
        function PB = cartesianToBarycentric(obj,TI,PC)
            %cartesianToBarycentric
            %
            %   See also triangulation.cartesianToBarycentric.
            PB = obj.TR.cartesianToBarycentric(TI, PC);
        end
        function [CC, RCC] = circumcenter(obj,varargin)
            %circumcenter
            %
            %   See also triangulation.circumcenter.
            if (nargout==1)
                CC  = obj.TR.circumcenter(varargin{1:end});
                RCC = [];
            elseif (nargout==2)
                [CC, RCC] = obj.TR.circumcenter(varargin{1:end});
            else
                error('Invalid!');
            end
        end
        function TI = edgeAttachments(obj,varargin)
            %edgeAttachments
            %
            %   See also triangulation.edgeAttachments.
            TI = obj.TR.edgeAttachments(varargin{1:end});
        end
        function EE = edges(obj)
            %edges
            %
            %   See also triangulation.edges.
            EE = obj.TR.edges();
        end
        function FN = faceNormal(obj,varargin)
            %faceNormal
            %
            %   See also triangulation.faceNormal.
            FN = obj.TR.faceNormal(varargin{1:end});
        end
        function FE = featureEdges(obj,FILTERANGLE)
            %featureEdges
            %
            %   See also triangulation.featureEdges.
            FE = obj.TR.featureEdges(FILTERANGLE);
        end
        function [FF, XF] = freeBoundary(obj)
            %freeBoundary
            %
            %   See also triangulation.freeBoundary.
            if (nargout==1)
                FF = obj.TR.freeBoundary;
                XF = [];
            elseif (nargout==2)
                [FF, XF] = obj.TR.freeBoundary;
            else
                error('Invalid!');
            end
        end
        function [IC, RIC] = incenter(obj,varargin)
            %incenter
            %
            %   See also triangulation.incenter.
            if (nargout==1)
                IC  = obj.TR.incenter(varargin{1:end});
                RIC = [];
            elseif (nargout==2)
                [IC, RIC] = obj.TR.incenter(varargin{1:end});
            else
                error('Invalid!');
            end
        end
        function TF = isConnected(obj,varargin)
            %isConnected
            %
            %   See also triangulation.isConnected.
            TF = obj.TR.isConnected(varargin{1:end});
        end
        function TN = neighbors(obj,varargin)
            %neighbors
            %
            %   See also triangulation.neighbors.
            TN = obj.TR.neighbors(varargin{1:end});
        end
        function TI = vertexAttachments(obj,varargin)
            %vertexAttachments
            %
            %   See also triangulation.vertexAttachments.
            TI = obj.TR.vertexAttachments(varargin{1:end});
        end
        function VN = vertexNormal(obj,varargin)
            %vertexNormal
            %
            %   See also triangulation.vertexNormal.
            VN = obj.TR.vertexNormal(varargin{1:end});
        end
        function SZ = size(obj)
            %size
            %
            %   See also triangulation.size.
            SZ = obj.TR.size;
        end
        function [VI, D] = nearestNeighbor(obj,varargin)
            %nearestNeighbor
            %
            %   See also triangulation.nearestNeighbor.
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
            %   See also triangulation.pointLocation.
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