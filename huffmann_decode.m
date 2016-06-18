function output = huffmann_decode(coded,inf)
l = length(coded);

seq = repmat(uint8(0),1,l.*8);
b_ind = 1:8;

for ind = 1:l,
	seq(b_ind+8.*(ind-1)) = uint8(bitget(coded(ind),b_ind));
end

%vectorising
seq = logical(seq(:)');
l = length(seq);

% removing the  zero padding
seq((l-inf.pad+1):end) = []; 
l = length(seq);

% creating output
output = repmat(uint8(0),1,inf.length);
v_idx = 1;
c_ind = 1;
c = 0;
for ind = 1:l,
	c = bitset(c,c_ind,seq(ind));
	c_ind = c_ind+1;
	byte = decode(bitset(c,c_ind),inf);
	if byte>0, 
		output(v_idx) = byte-1;
		c_ind = 1;
		c = 0;
		v_idx = v_idx+1;
	end
end
