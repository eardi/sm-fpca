function display(obj)

disp(['          Name : description of text lines                        = ''',obj.FileName,'''']);
disp(['          Text : struct containing lines of text; number of lines =  ', num2str(length(obj.Text))]);
disp(['          ENDL : end-of-line character ', '']);

end