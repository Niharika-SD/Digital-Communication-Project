function z =  QAM_demodulation(y,M)

if mod(log2(M), 2) % Cross constellation, including M=2
    const = squareqamconst(M,ini_phase);
    z = genqamdemod(y,const);
else
    % Square constellation, starting with M=4
    % Checking for correct orientation
    wid = size(y,1);
    if(wid ==1)
        y = y(:);
    end
    % Precomputing for later use
    sqrtM = sqrt(M);

    % Inphase/real rail
    % Move the real part of input signal; scale appropriately and round the
    % values to get index ideal constellation points
    rIdx = round( ((real(y) + (sqrtM-1)) ./ 2) );
    % clip values that are outside the valid range 
    rIdx(rIdx <= -1) = 0;
    rIdx(rIdx > (sqrtM-1)) = sqrtM-1;

    % Moving the imaginary part of input signal; scaling appropriately and rounding the values to get index of ideal constellation points
    iIdx = round(((imag(y) + (sqrtM-1)) ./ 2));
    % clipoing values that are outside the valid range 
    iIdx(iIdx <= -1) = 0;
    iIdx(iIdx > (sqrtM-1)) = sqrtM-1;
    
    % computing output 
    z = sqrtM-iIdx-1 +  sqrtM*rIdx;

    % Output signal
    if(wid == 1)
        z = z';
    end

end
end