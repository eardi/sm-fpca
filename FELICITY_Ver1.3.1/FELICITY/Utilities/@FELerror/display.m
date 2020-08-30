function display(obj)

disp(['      Error_Comment: Struct Containing All of the Error Comments: ']);
disp(obj.Error_Comment);
disp(['           STD_LINE: Line Break:                                  ']);
disp(obj.STD_LINE);
disp(['          STD_ERROR: Default Error Header:                        ']);
disp(obj.STD_ERROR);

if obj.DEBUG
    DEBUG = 'TRUE';
else
    DEBUG = 'FALSE';
end
disp(['              DEBUG: Perform Debugging Checks                    = ',DEBUG]);
disp(['               ENDL: Endline Character                          ',' = ',obj.ENDL]);

end