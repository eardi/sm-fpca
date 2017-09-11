function obj = Verify_Domain_Restriction(obj)
%Verify_Domain_Restriction
%
%   This verifies that the specified domain restriction (of the function which
%   this object represents) is consistent with the Element's domain of
%   definition.
%
%   obj = obj.Verify_Domain_Restriction;
%
%   Note: this obj might get updated.

% Copyright (c) 05-28-2012,  Shawn W. Walker

if ~isempty(obj.Domain)
    
    Restriction_Domain_Top_Dim = obj.Domain.Top_Dim;
    Elem_Domain_Top_Dim = obj.Element.Domain.Top_Dim;
    % if the domain of *restriction* has a larger topological dimension than
    %    the Element's domain top. dim., then this is NOT valid!
    if (Restriction_Domain_Top_Dim > Elem_Domain_Top_Dim)
        err = FELerror;
        err = err.Add_Comment('Topological dimensions are not valid!');
        err = err.Add_Comment('The domain of restriction:');
        err = err.Add_Comment([obj.Domain.Name, ', Topological Dimension = ', num2str(Restriction_Domain_Top_Dim)]);
        err = err.Add_Comment(['   cannot be contained in the domain of the function''s element ', obj.Element.Name, ':']);
        err = err.Add_Comment(['   ', obj.Element.Domain.Name, ', Topological Dimension = ', num2str(Elem_Domain_Top_Dim)]);
        err = err.Add_Comment('Check your Domain definitions!');
        err.Error;
        error('stop!');
    end
    
    % if the domain of restriction is the SAME as the element's domain of
    % definition, then remove the domain of restriction (not needed here)
    if isequal(obj.Element.Domain,obj.Domain)
        obj.Domain = [];
    end
end

end