function STR = make_alpha_str(alpha)

LA = length(alpha);

STR = blanks(LA);
for ind = 1:LA
    STR(ind) = num2str(alpha(ind));
end

end