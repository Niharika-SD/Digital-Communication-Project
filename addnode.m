
function cdwd_new = addnode(codeword_old,item)

%adding nodes to the existing codeword
cdwd_new = cell(size(codeword_old));
for in = 1:length(codeword_old),
	cdwd_new{in} = [item codeword_old{in}];
end