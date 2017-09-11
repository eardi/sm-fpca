% (FELICITY) Class for Arrays of Finite Element Matrices
% This class collects all the FE matrices into a Map container, and it collects
% all info for the domains of integration (DoI).  Moreover, on each DoI, a
% collection of FELMatrix objects is stored.  Each FELMatrix generates code for
% computing the contribution to the overall FEM matrix due to integrating on the
% DoI.
classdef FELMatrices
    properties %(SetAccess='private',GetAccess='private')
        Matrix               % array of FEM Matrix definitions
        Integration          % (array) of structs containing info about evaluating FEM matrix contributions on different domains of integration
        Snippet_Dir          % directory to put minor code snippets
        DEBUG                % indicates whether to put debugging code in
    end
    methods
        function obj = FELMatrices(varargin)
            
            if nargin ~= 2
                disp('Requires 2 arguments!');
                disp('First  is a FELSpaces object.');
                disp('Second is a string representing a sub-directory to store code snippets.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init FELMatrices Object...';
            disp(OUT_str);
            
            FS = varargin{1};
            if ~isa(FS,'FELSpaces')
                error('FS must be a FELSpaces object!');
            end
            obj.Snippet_Dir = varargin{2};
            
            if ~ischar(obj.Snippet_Dir)
                error('Snippet sub-directory must be a string!');
            end
            
            % init
            obj.Matrix = containers.Map;
            
            obj.Integration = Get_Integration_Struct(); % init
            for ind = 1:length(FS.Integration)
                obj.Integration(ind).Domain    = FS.Integration(ind).DoI_Geom.Domain; % keep this for use later
                obj.Integration(ind).Matrix    = containers.Map; % init
            end
            
            % set
            obj.DEBUG  = true;
        end
    end
end

% END %