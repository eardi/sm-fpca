function obj = Set_Geometric_Functions(obj,DOM)
%Set_Geometric_Functions
%
%   This turns the Domains (input) into GeoFunc(s) and stores them in this object.
%   Note: this only stores GeoFunc(s) for Domains that are *NOT* equal to obj.Domain;
%         the geometric function for obj.Domain can be inferred later.
%
%   obj = obj.Set_Geometric_Functions(DOM);
%
%   DOM = cell array of Level 1 Domain(s).

% Copyright (c) 01-23-2014,  Shawn W. Walker

DoI_TD = obj.Domain.Top_Dim();

% init
obj.GeoF  = [];
for ind = 1:length(DOM)
    
    temp_dom = DOM{ind};
    if ~isa(temp_dom,'Domain')
        error('Must be a valid Level 1 Domain.');
    end
    % check that the domain is valid for accessing its geometry on the domain of
    % expression
    temp_TD = temp_dom.Top_Dim();
    if (temp_TD < DoI_TD)
        err = FELerror;
        err = err.Add_Comment(['The geometry of this domain:  ', temp_dom.Name , ',']);
        err = err.Add_Comment(['    cannot be accessed on this domain:  ', obj.Domain.Name, '.']);
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['For example, if ', temp_dom.Name, ' is the boundary of this domain ', obj.Domain.Name, ',']);
        err = err.Add_Comment('    then this will *not* work because an *interior* point of the domain cannot know');
        err = err.Add_Comment('    what happens on the boundary!');
        err = err.Add_Comment(' ');
        err = err.Add_Comment('Check your m-file!');
        err.Error;
        error('stop!');
    end
    
    % make sure the domain is not the Domain of Expression (DoE)
    IS_DoI = isequal(temp_dom,obj.Domain);
    if (~IS_DoI) % if it is not the DoI, then we can store it.
        % create the GeoFunc
        GF = GeoFunc(temp_dom);
        if isempty(obj.GeoF)
            obj.GeoF = GF;
        else
            Current_Num_Geo = length(obj.GeoF);
            obj.GeoF(Current_Num_Geo+1,1) = GF; % you can have several GeoFunc(s)...
            % make it a column vector!
        end
    end
end

end