function display(obj)

disp(['      FileName : Full Path to File......                              ']);
disp(['               = ''',obj.FileName,'''']);
disp(['          Text : struct containing lines of text; number of lines =   ', num2str(length(obj.Text))]);

end