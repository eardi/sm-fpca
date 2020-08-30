% Class for Auto Generating DoF Numbering Code
classdef GenDoFNumberingCode
    properties %(SetAccess='private',GetAccess='private')
        Output_Dir            % where to put the generated code
        Main_Dir              % the main directory of this class's code!
        Skeleton_Dir          % location of code snippets
        Elem                  % various parameters
        String                % struct of generic strings
        DEBUG                 % indicates whether to put debugging code in
    end
    methods
        function obj = GenDoFNumberingCode(varargin)
            
            if nargin ~= 2
                disp('Requires 2 arguments!');
                disp('First  is a string containing the directory where the generated code is placed.');
                disp('Second is a struct of element parameters.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init GenDoFNumberingCode Object...';
            disp(OUT_str);
            
            obj.Output_Dir    = varargin{1};
            obj.Elem          = varargin{2};
            obj.DEBUG         = true;
            
            if ~ischar(obj.Output_Dir)
                error('Input should be a string!');
            end
            if ~isdir(obj.Output_Dir)
                error('Input is not a valid directory!');
            end
            
            fields_TF = isfield(obj.Elem(1),{'Name','Dim','Domain','Basis',...
                                             'Nodal_Var','Nodal_Top'});
            if (min(fields_TF)~=1)
                error('Invalid Elem struct...');
            end
            % make sure all the elements have the same intrinsic dimension
            % and domain type
            for ind=2:length(obj.Elem)
                if (obj.Elem(ind).Dim~=obj.Elem(1).Dim)
                    error('Elem dimensions do not match!');
                end
                if ~strcmp(obj.Elem(ind).Domain,obj.Elem(1).Domain)
                    error('Elem domains do not match!');
                end
            end
            
            % get the main directory that this class is in!
            MFN = mfilename('fullpath');
            [MD, FN, EXT] = fileparts(MFN);
            obj.Main_Dir = MD;
            obj.Skeleton_Dir = fullfile(obj.Main_Dir, 'private', 'Code_Skeleton');
            
            % useful text strings
            obj.String.BEGIN_Auto_Gen = '/*------------ BEGIN: Auto Generate ------------*/';
            obj.String.END_Auto_Gen   = '/*------------   END: Auto Generate ------------*/';
            obj.String.ENDL           = '\n';
            obj.String.Separator      = '/***************************************************************************************/';
            obj.String.EOF            = '/***/\n\n';
        end
    end
end

% END %