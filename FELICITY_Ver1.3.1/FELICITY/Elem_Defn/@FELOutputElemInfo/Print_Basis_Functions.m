function Out_Str = Print_Basis_Functions(obj,style)
%Print_Basis_Functions
%
%   This outputs the basis function definitions in either "pretty" or LaTeX
%   format.
%
%   obj.Print_Basis_Functions;
%
%   Pretty prints the basis function defn's to the MATLAB display.
%
%   Out_Str = obj.Print_Basis_Functions('latex');
%
%   Out_Str = a struct containing lines of text that writes the basis function
%             defn's in LaTeX code format.  It also prints it to the MATLAB
%             display.

% Copyright (c) 04-30-2012,  Shawn W. Walker

Num_Basis = length(obj.Elem.Basis);

if (nargin==1)
    style = 'pretty';
end

obj.Print_Basis_Function_Msg;

if strcmpi(style,'latex')
    
    Out_Str(Num_Basis+2).line = [];
    Out_Str(1).line = ['\begin{split}'];
    for bi = 1:Num_Basis
        LATEX_str = latex(obj.Elem.Basis(bi).phi);
        Basis_Func_Str = ['\phi_', num2str(bi), ' &= ', LATEX_str, ' \\'];
        Out_Str(bi+1).line = Basis_Func_Str;
    end
    Out_Str(Num_Basis+2).line = ['\end{split}'];
    
    % display to screen
    disp(['{ \phi_j } are the basis functions:']);
    disp('Begin LaTeX code:');
    disp(' ');
    for ind = 1:length(Out_Str)
        disp(Out_Str(ind).line);
    end
    disp(' ');
    disp('End LaTeX code:');
    
else % just pretty print it to the MATLAB prompt
    
    Out_Str = [];
    for bi = 1:Num_Basis
        disp(['Basis Function #', num2str(bi), ':']);
        pretty(obj.Elem.Basis(bi).phi);
        disp(' ');
    end
    
end

end