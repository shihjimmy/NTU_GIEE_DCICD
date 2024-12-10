% (a)
load('HW6-1a.mat');

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

% G_ZF = (H^H * H)^(-1) * H^H for ZF detection
G_ZF = pinv(Hmatrix); 
x_hat = G_ZF * y; 
disp('Estimated x_hat without noise:');
disp(x_hat);


% (b)
load('HW6-1b.mat'); 
x_hat_noisy = G_ZF * yprime;

disp('Estimated x_hat with noise:');
disp(x_hat_noisy);
x_hat_2 = arrayfun(@(z) qam_constellation(find(abs(z - qam_constellation) == min(abs(z - qam_constellation)), 1)), x_hat_noisy);

disp('Detected x_hat with noise (mapped to 16-QAM):');
disp(x_hat_2);


% (c)
function res = calculation(rx_symbol, Hmatrix)
    G_ZF = pinv(Hmatrix); 
    res = G_ZF * rx_symbol;
end

function error_bits = calculateBER(tx_bits, rx_bits)
    if size(tx_bits) ~= size(rx_bits)
        error('tx_bits and rx_bits must have the same dimensions.');
    end               
    error_bits = sum(sum(tx_bits ~= rx_bits));  
end

function BER = BER2SNR(SNR_dB, Hmatrix, qam_constellation, mapping, calculation)
    BER = zeros(size(SNR_dB));
    num_symbols = 10000;

    for i = 1:length(SNR_dB)
        SNR_linear = 10^(SNR_dB(i) / 10);
        signal_power = mean(abs(qam_constellation).^2);
        noise_var = signal_power / SNR_linear;  

        for p = 1 : num_symbols
            tx_symbol = randsrc(3,1,qam_constellation);
            tx_bits = zeros(length(tx_symbol), 4);
        
            for t = 1:length(tx_symbol)
                tx_bits_str = mapping(mat2str(tx_symbol(t))); 
                tx_bits(t, :) = arrayfun(@(x) str2double(x), tx_bits_str); 
            end
        
            noise = sqrt(noise_var/2) * (randn(3, 1) + 1j * randn(3, 1));
       
            rx_symbol = Hmatrix* tx_symbol + noise;
            rx_symbol = calculation(rx_symbol, Hmatrix);
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
BER = BER2SNR(SNR_dB, Hmatrix, qam_constellation, mapping, @calculation);
semilogy(SNR_dB, BER, '-o');
xlabel('SNR (dB)');
ylabel('BER');
title('BER vs SNR for ZF Detection');
grid on;
