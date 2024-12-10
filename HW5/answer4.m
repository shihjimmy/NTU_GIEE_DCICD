% (a)
load('HW5-4Rev.mat');
OFDMRx1 = OFDMRx1(33:end);
OFDMRx2 = OFDMRx2(33:end);

OFDMRx1_FFT = fft(OFDMRx1, 128); 
OFDMRx2_FFT = fft(OFDMRx2, 128);

figure;
subplot(2,1,1);
stem(real(OFDMRx1_FFT));
xlabel('Subcarrier Index');
ylabel('Real Part');
title('4-a Real Part of Frequency-Domain Signal (OFDMRx1)');

subplot(2,1,2);
stem(imag(OFDMRx1_FFT));
xlabel('Subcarrier Index');
ylabel('Imaginary Part');
title('4-a Imaginary Part of Frequency-Domain Signal (OFDMRx1)');

figure;
subplot(2,1,1);
stem(real(OFDMRx2_FFT));
xlabel('Subcarrier Index');
ylabel('Real Part');
title('4-a Real Part of Frequency-Domain Signal (OFDMRx2)');

subplot(2,1,2);
stem(imag(OFDMRx2_FFT));
xlabel('Subcarrier Index');
ylabel('Imaginary Part');
title('4-a Imaginary Part of Frequency-Domain Signal (OFDMRx2)');

% (b)
modulated_symbols = zeros(1, 128);
modulated_symbols(1:2:end) = 1 - 3j; 
modulated_symbols(2:2:end) = 3 - 1j; 

H_k1 = OFDMRx1_FFT ./ modulated_symbols;

figure;
stem(abs(H_k1));
xlabel('Subcarrier Index');
ylabel('|H_k|');
title('4-b Channel Frequency Response Magnitude (OFDMRx1)');

% (c)
H_k2 = zeros(1, 127);
H_k2(1:4:end) = OFDMRx2_FFT(1:4:end) ./ (1 - 3j); 
H_k2(3:4:end) = OFDMRx2_FFT(3:4:end) ./ (3 - 1j); 

known_indices = find(H_k2 ~= 0);  
known_values = H_k2(known_indices); 
H_k2_interp = H_k2;

for k = 1:length(H_k2)
    if H_k2(k) == 0
        left_idx = find(known_indices < k, 1, 'last'); 
        right_idx = find(known_indices > k, 1, 'first');
        
        if ~isempty(left_idx) && ~isempty(right_idx)
            x1 = known_indices(left_idx);
            x2 = known_indices(right_idx);
            y1 = known_values(left_idx);
            y2 = known_values(right_idx);
            H_k2_interp(k) = y1 + (y2 - y1) * (k - x1) / (x2 - x1);

        elseif ~isempty(left_idx)
            H_k2_interp(k) = known_values(left_idx);
            
        elseif ~isempty(right_idx) 
            H_k2_interp(k) = known_values(right_idx);
        end
    end
end

figure;
stem(abs(H_k2_interp));
xlabel('Subcarrier Index');
ylabel('|H_k|');
title('4-c Interpolated Channel Frequency Response Magnitude (OFDMRx2)');

%(d)
difference = abs(H_k1(1:127) - H_k2_interp);

figure;
stem(difference);
xlabel('Subcarrier Index');
ylabel('|H_k1 - H_k2|');
title('4-d Difference between H_k1 and H_k2');
