% (a)~(e)
load('HW6-1b.mat'); 

% Map x_hat_noisy to nearest 16-QAM constellation
qam_constellation = [-3-3j, -3-1j, -3+1j, -3+3j, ...
                     -1-3j, -1-1j, -1+1j, -1+3j, ...
                      1-3j,  1-1j,  1+1j,  1+3j, ...
                      3-3j,  3-1j,  3+1j,  3+3j];

mapping = containers.Map({'-3-3i', '-3-1i', '-3+1i', '-3+3i', ...
                          '-1-3i', '-1-1i', '-1+1i', '-1+3i', ...
                          '1-3i', '1-1i', '1+1i', '1+3i', ...
                          '3-3i', '3-1i', '3+1i', '3+3i'}, ...
                         {'1111', '1110', '1100', '1101', ...
                          '1011', '1010', '1000', '1001', ...
                          '0011', '0010', '0000', '0001', ...
                          '0111', '0110', '0100', '0101'});



function [res, idx] = OSIC(Hmatrix, yprime, qam_constellation)
    cols_removed = false(1, size(Hmatrix, 2)); 
    res = zeros(length(yprime),1);
    idx = zeros(length(yprime),1);

    % i=0
    H0 = Hmatrix;
    y0 = yprime;
    G0 = pinv(H0);
    row_sums = sum(abs(G0).^2, 2);
    [~, min_index] = min(row_sums);
    
    cols_removed(min_index) = true;
    
    row_i = G0(min_index, :);
    x = row_i * y0;
    x = arrayfun(@(z) qam_constellation(find(abs(z - qam_constellation) == min(abs(z - qam_constellation)), 1)), x);
    res(min_index) = x;
    idx(1) = min_index;
    
    y1 = y0 - x * H0(:, min_index);
    H1 = H0;
    H1(:, min_index) = [];
    
    % i=1
    G1 = pinv(H1);
    row_sums = sum(abs(G1).^2, 2);
    [~, min_index] = min(row_sums);
    
    temp = min_index;
    
    while cols_removed(min_index)
        min_index = min_index + 1; 
    end
    cols_removed(min_index) = true;
    
    row_i = G1(temp, :);
    x = row_i * y1;
    x = arrayfun(@(z) qam_constellation(find(abs(z - qam_constellation) == min(abs(z - qam_constellation)), 1)), x);
    res(min_index) = x;
    idx(2) = min_index;
    
    y2 = y1 - x * H1(:, temp);
    H2 = H1;
    H2(:, temp) = [];
    
    % i=2
    G2 = pinv(H2);
    row_sums = sum(abs(G2).^2, 2);
    [~, min_index] = min(row_sums);
    
    temp = min_index;
    
    while cols_removed(min_index)
        min_index = min_index + 1; 
    end
    
    row_i = G2(temp, :);
    x = row_i * y2;
    x = arrayfun(@(z) qam_constellation(find(abs(z - qam_constellation) == min(abs(z - qam_constellation)), 1)), x);
    res(min_index) = x;
    idx(3) = min_index;
end


[res, idx] = OSIC(Hmatrix, yprime, qam_constellation);
disp("signal detected first is: ");
disp(idx(1));
disp("the value of the signal detected first is:")
disp(res(idx(1)));

disp("signal detected second is: ");
disp(idx(2));
disp("the value of the signal detected secondt is:")
disp(res(idx(2)));

disp("signal detected third is: ");
disp(idx(3));
disp("the value of the signal detected third is:")
disp(res(idx(3)));

% (f)
load("HW6-1a.mat");

function error_bits = calculateBER(tx_bits, rx_bits)
    if size(tx_bits) ~= size(rx_bits)
        error('tx_bits and rx_bits must have the same dimensions.');
    end               
    error_bits = sum(sum(tx_bits ~= rx_bits));  
end

function BER = BER2SNR(SNR_dB, Hmatrix, qam_constellation, mapping, OSIC)
    BER = zeros(size(SNR_dB));
    num_symbols = 10000;

    for i = 1:length(SNR_dB)
        SNR_linear = 10^(SNR_dB(i) / 10);
        signal_power = mean(abs(qam_constellation).^2);
        noise_var = signal_power / SNR_linear;  

        for j = 1 : num_symbols
            tx_symbol = randsrc(3,1,qam_constellation);
            tx_bits = zeros(length(tx_symbol), 4);
        
            for t = 1:length(tx_symbol)
                tx_bits_str = mapping(mat2str(tx_symbol(t))); 
                tx_bits(t, :) = arrayfun(@(x) str2double(x), tx_bits_str); 
            end
        
            noise = sqrt(noise_var/2) * (randn(3, 1) + 1j * randn(3, 1));
       
            rx_symbol = Hmatrix* tx_symbol + noise;
            [rx_symbol, ~] = OSIC(Hmatrix, rx_symbol, qam_constellation);
            rx_symbol = arrayfun(@(z) qam_constellation(find(abs(z - qam_constellation) == min(abs(z - qam_constellation)), 1)), rx_symbol);
            rx_bits = zeros(length(rx_symbol), 4);
        
            for t = 1:length(rx_symbol)
                rx_bits_str = mapping(mat2str(rx_symbol(t))); 
                rx_bits(t, :) = arrayfun(@(x) str2double(x), rx_bits_str); 
            end
        
            BER(i) = BER(i) + calculateBER(tx_bits, rx_bits);
        end

        BER(i) = BER(i) / (num_symbols*3*4);
    end
end

SNR_dB = 0:2:30;
BER = BER2SNR(SNR_dB, Hmatrix, qam_constellation, mapping, @OSIC);
semilogy(SNR_dB, BER, '-o');
xlabel('SNR (dB)');
ylabel('BER ');
title('BER vs SNR for OSIC Detection');
grid on;
