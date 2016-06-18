%reading the data from the file
clc;
clear all
close all

%source encoding
File_ID_text = fopen('The_Hound_of_the_Baskervilles.txt');
A1 = fscanf(File_ID_text,'%c');
A1_uint8 = uint8(A1);
A2 = imread('Lena.bmp');
A2_vector = uint8(reshape(A2,[size(A2,1)*size(A2,2),1]));

%huffmann
[encoded_huff_text, inf1] = generate_huffmann_code(A1_uint8);
[encoded_huff_image, inf2] = generate_huffmann_code(A2_vector);

%convert to binary
dataIn_text1 = de2bi(encoded_huff_text);
dataIn_image1 = de2bi(encoded_huff_image);

[s,t] = size(dataIn_text1);
[u,t] = size(dataIn_image1);

%Modulation
M = 16;  % Size of signal constellation
k = log2(M); 

dataIn_text = dataIn_text1(:)';
dataIn_image = dataIn_image1(:)';
%converting into packets of size k
dataInMatrix_text = reshape(dataIn_text,length(dataIn_text)/k,k);
dataInMatrix_image = reshape(dataIn_image,length(dataIn_image)/k,k);

%binary to decimal conversion 
dataInMatrix_text = bi2de(dataInMatrix_text);
dataInMatrix_image= bi2de(dataInMatrix_image);

%QAM Modulation
dataMod_text = QAM_modulation(dataInMatrix_text,M);
dataMod_image = QAM_modulation(dataInMatrix_image,M);

%channel noise

%EbNo;numSamplesPerSymbol1;
%snr = EbNo + 10*log10(k) - 10*log10(numSamplesPerSymbol);
 
snr = 10; %%in dB
receivedSignal_text = awgn(dataMod_text,snr,'measured');
receivedSignal_image = awgn(dataMod_image,snr,'measured');

%Demodulation
dataSymbolsOut_text = QAM_demodulation(receivedSignal_text,M);
dataSymbolsOut_image = QAM_demodulation(receivedSignal_image,M);

dataSymbolsOut_text = uint8(dataSymbolsOut_text(:));
dataSymbolsOut_image = uint8(dataSymbolsOut_image(:));
%convert to decimal using grouping
dataOutMatrix_text = de2bi(dataSymbolsOut_text,k);
dataOutMatrix_image = de2bi(dataSymbolsOut_image,k);

%vectorise
dataOutMatrix_text1 = dataOutMatrix_text(:)';
dataOutMatrix_image1 = dataOutMatrix_image(:)';

%convert to binary
dataOut_text = bi2de(reshape(dataOutMatrix_text1,[s,8]))';
dataOut_image = bi2de(reshape(dataOutMatrix_image1,[u,8]))';

%Source decoder
decoded_huff_text = huffmann_decode(uint8(dataOut_text),inf1);
decoded_huff_image = huffmann_decode(uint8(dataOut_image),inf2);

decoded_huff_image1 = decoded_huff_image(1:size(A2,1)*size(A2,2));
reconstructred_image = resize(decoded_huff_image1,[size(A2,1),size(A2,2)]);
% figure;imshow(reconstructred_image);
fileID = fopen('exp.txt','w');
fprintf(fileID,'%c',char(decoded_huff_text));

%error calculation
[numErrors_text,ber_text] = biterr(dataIn_text,dataOutMatrix_text1);
fprintf('\n For the text file \nThe binary coding bit error rate = %5.2e, based on %d errors\n \n ,snr is %d for %d QAM\n', ...
    ber_text/100,numErrors_text,snr,M)

[numErrors_image,ber_image] = biterr(dataIn_image,dataOutMatrix_image1);
fprintf('\n For the image file \nThe binary coding bit error rate = %5.2e, based on %d errors\n \n ,snr is %d for %d QAM\n', ...
    ber_image/100,numErrors_image,snr,M)


