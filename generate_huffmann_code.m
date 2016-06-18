function [coded,inf] = generate_huffmann_code(vector)
%the function takes the input agrument as the vector to be encoded by the huffmann
%algorithm and returns two outputs the vector in the coded format (coded)
%and a structure inf
%inf.pad : zero padding provided 
%inf.huffcodes: the correspondences required for decoding huffcodes;
%inf.length = length(vector);
%inf.maxcodelen = maxcodelen;


% converting the  vector as a row
vector = vector(:)';

% frequency of each symbol
f = histc(vector(:), 0:255); f = f(:)'/sum(f);

% Sorting the symbols on the basis of ascending orders of probability
generated_symbols = find(f~=0);
f = f(generated_symbols);
[f,sortindex] = sort(f);
generated_symbols = generated_symbols(sortindex);

% generating the codewords
l = length(generated_symbols);
symbols_index = num2cell(1:l);

%create temporary cell
temp = cell(l,1);

%check for frequency of word for encoding
while length(f)>1,
	in1 = symbols_index{1};
	in2 = symbols_index{2};
	temp(in1) = addnode(temp(in1),uint8(0));
	temp(in2) = addnode(temp(in2),uint8(1));
	f = [sum(f(1:2)) f(3:end)];
	symbols_index = [{[in1 in2]} symbols_index(3:end)];
	[f,sortindex] = sort(f);
	symbols_index = symbols_index(sortindex);
end

% arranging the cell array based on symbols
cdwd = cell(256,1);
cdwd(generated_symbols) = temp;

% calculating the new length
l = 0;
for ind=1:length(vector),
	l = l+length(cdwd{double(vector(ind))+1});
end
	
% creating entire sequence
seq = repmat(uint8(0),1,l);

ptr = 1;
for ind=1:length(vector),
	code = cdwd{double(vector(ind))+1};
	l = length(code);
	seq(ptr+(0:l-1)) = code;
	ptr = ptr+l;
end

% checking for zero padding(if required)
l = length(seq);
pad = 8-mod(l,8);
if pad>0,
    a=zeros(1,pad);
	seq = [seq uint8(a)];
end

% Optimisation of stored codewords
cdwd = cdwd(generated_symbols);
%calc size and initialise
a = size(cdwd);
codelen = zeros(a);

weights = 2.^(0:51); %%double weigthed

maxcodelen = 0;
for ind = 1:length(cdwd),
	l = length(cdwd{ind});
	if l>maxcodelen,
		maxcodelen = l;
	end
	if l>0,
		code = sum(weights(cdwd{ind}==1));
		code = bitset(code,l+1);
		cdwd{ind} = code;
		codelen(ind) = l;
	end
end
cdwd = [cdwd{:}];

%generating the coded vector
cols = length(seq)/8;
seq = reshape(seq,8,cols);
weights = 2.^(0:7);
coded = uint8(weights*double(seq));

huffcodes = sparse(1,1);
for ind = 1:numel(cdwd),
	huffcodes(cdwd(ind),1) = generated_symbols(ind);
end

% information structure
inf.pad = pad; %padding
inf.huffcodes = huffcodes; %correspondences
inf.ratio = cols./length(vector); %compression ratio
inf.length = length(vector); %size
inf.maxcodelen = maxcodelen; %max length of a coded element


end
