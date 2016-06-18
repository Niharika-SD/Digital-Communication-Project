function y = QAM_modulation(x,M)

if(log2(M) ==1)
    constellation = [-1 1];    
    return
end 

if( log2(M)/2 ~= floor(log2(M)/2) && log2(M) >3)
    nbits  = log2(M);
    constellation = zeros(1,M);	
    nIbits = (nbits + 1) / 2;
    nQbits = (nbits - 1) / 2;
    mI = 2^nIbits;
    mQ = 2^nQbits;
    for i = 0:M-1
        I_data  = fix(i/2^nQbits);
        Q_data = bitand( i, fix(((M-1)/(2^nIbits))));
        cplx_data = (2 * I_data + 1 - mI) + 1j*(-1 * (2 * Q_data + 1 - mQ));
       
            I_mag = abs(floor(real(cplx_data)));
            if(I_mag > 3 * (mI / 4))
                Q_mag = abs(floor(imag(cplx_data)));
                I_sgn = sign(real(cplx_data));
                Q_sgn = sign(imag(cplx_data));
                if(Q_mag > mQ/2)
                    cplx_data = I_sgn*(I_mag - mI/2) + 1j*( Q_sgn*(2*mQ - Q_mag));
                else
                    cplx_data = I_sgn*(mI - I_mag) + 1j*(Q_sgn*(mQ + Q_mag));
                end 
            end
           
        constellation(i+1) =  real(cplx_data) + 1j*imag(cplx_data);
    end
    
else % Regular square QAM   
    constellation = [];

if ((round(sqrt(M))^2) == (sqrt(M))^2)    % Square QAM
    for iIndex = 1 : 2 : sqrt(M) - 1
        for qIndex = 1 : 2 : sqrt(M) - 1
            constellation = [constellation; iIndex+j*qIndex];
        end
    end
elseif (M==8)
    constellation = [1+j; 3+j];
else  
    smallLen = 1;
    for bigLen = ceil(sqrt(M)) : floor(sqrt(2*M))
        while (bigLen > sqrt(M + 4*smallLen.^2))
            smallLen = smallLen + 1;
        end
        if (bigLen == sqrt(M + 4*smallLen.^2))
            break;
        else  
            bigLen = bigLen + 1;
            smallLen = 1;
        end
    end
    
    for iIndex = 1 : 2 : bigLen-1
        for qIndex = 1 : 2 : bigLen-1
            if (iIndex < bigLen-(2*smallLen-1) || qIndex < bigLen-(2*smallLen-1))
                constellation = [constellation; iIndex+j*qIndex];
            end
        end
    end
end
    Const =constellation;
    newConst = [Const; conj(Const); -Const; -conj(Const) ];
    
    % sorting 
    constellation = zeros(1,M);
    for k = 1:M
        % finding the elements with smallest real component
        ind1 = find(real(newConst) == min(real(newConst)));
        % finding the element with largest imaginary component
        tmpArray = -1j*inf * ones(size(newConst));
        tmpArray(ind1) = newConst(ind1);
        ind2 = find(imag(tmpArray) == max(imag(tmpArray)));       
        constellation(k)= newConst(ind2);
        %getting rid of the old point
        newConst(ind2) = [];
    end
end

wid = size(x,1);
if(wid ==1)
    x = x(:);
end

% --- constellation needs to have the same orientation as the input -- %
if(size(constellation,1) ~= size(x,1) )
    constellation = constellation(:);
end

% map
y = constellation(x+1);

% ensure output is a complex data type
y = complex(real(y), imag(y));

if(wid == 1)
    y = y.';
end
end
