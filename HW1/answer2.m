% read in the binary bits from answer1.m
fileID = fopen('binary_bits.txt', 'r');
binary_string = fgetl(fileID);
fclose(fileID);
binary_data = arrayfun(@(x) str2double(x), binary_string);

fc = 20e6; % 20MHz
T = 200e-9; % 200ns
fs = 32 * fc; % sampling frequency for sin/cos
ts = 1/fs;
total_time = length(binary_data)/2 * T;

t = 0 : ts : total_time-ts;
carrier = cos(2*pi*fc*t) + 1j*sin(2*pi*fc*t); % carrier signal

I_values = zeros(1, length(binary_data)/2);
Q_values = zeros(1, length(binary_data)/2);

% QPSK modulation
for i = 1 : 2 : length(binary_data)-1
    b1 = binary_data(i);
    b2 = binary_data(i+1);
    
    if b1==0 && b2==0
        I = 1;
        Q = 0;
    elseif b1==0 && b2==1
        I = 0;
        Q = 1;
    elseif b1==1 && b2==0
        I = 0;
        Q = -1;
    else
        I = -1;
        Q = 0;
    end

    index = (i+1)/2;
    I_values(index) = I;
    Q_values(index) = Q;
end  

expanded_I = repelem(I_values, T/ts);
expanded_Q = repelem(Q_values, T/ts);

% for OQPSK
delay_samples = round((T/(2*ts)));
expanded_Q_delayed = [zeros(1, delay_samples), expanded_Q(1:end-delay_samples)];

IQ_signal = expanded_I + 1j * expanded_Q_delayed;
modulated_signal = IQ_signal .* carrier;
passband_signal_1 = real(modulated_signal);

figure('Position', [300, 100, 800, 600]);
subplot(4,1,1);
plot(t, passband_signal_1);
ylim([-2 2]);
title('2-(a): passband signal of OQPSK');


% for pi/4-QPSK modulation
I_values = zeros(1, length(binary_data)/2);
Q_values = zeros(1, length(binary_data)/2);

for i = 1 : 2 : length(binary_data)-1
    b1 = binary_data(i);
    b2 = binary_data(i+1);
    
    if i%2==0
        if b1==0 && b2==0
            I = 1;
            Q = 0;
        elseif b1==0 && b2==1
            I = 0;
            Q = 1;
        elseif b1==1 && b2==0
            I = 0;
            Q = -1;
        else
            I = -1;
            Q = 0;
        end
    else
        if b1==0 && b2==0
            I = 1/sqrt(2);
            Q = -1/sqrt(2);
        elseif b1==0 && b2==1
            I = 1/sqrt(2);
            Q = 1/sqrt(2);
        elseif b1==1 && b2==0
            I = -1/sqrt(2);
            Q = -1/sqrt(2);
        else
            I = -1/sqrt(2);
            Q = 1/sqrt(2);
        end
    end

    index = (i+1)/2;
    I_values(index) = I;
    Q_values(index) = Q;
end  

expanded_I = repelem(I_values, T/ts);
expanded_Q = repelem(Q_values, T/ts);
IQ_signal = expanded_I + 1j * expanded_Q;
modulated_signal = IQ_signal .* carrier;
passband_signal_2 = real(modulated_signal);

subplot(4,1,2);
plot(t, passband_signal_2);
ylim([-2 2]);
title('2-(b): passband signal of pi/4-QPSK');


% spectrum of 2-(a) & 2-(b)
% N point fft
N = length(passband_signal_1);
f_resolution = fs/N;
f = (-N/2 : N/2-1) * f_resolution;

fft_1 = fft(passband_signal_1);
fft_2 = fft(passband_signal_2);
fft_db_1 = 20*log10(abs(fft_1));
fft_db_2 = 20*log10(abs(fft_2));
fft_db_1(fft_db_1 < -60) = -60;
fft_db_2(fft_db_2 < -60) = -60;
fft_db_1_shifted = fftshift(fft_db_1);
fft_db_2_shifted = fftshift(fft_db_2);

subplot(4,1,3);
plot(f, fft_db_1_shifted);
title('2-(c): spectrum of 2-(a)');
subplot(4,1,4);
plot(f, fft_db_2_shifted);
title('2-(c): spectrum of 2-(b)');
