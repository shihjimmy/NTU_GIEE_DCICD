% read in the binary bits from answer1.m
fileID = fopen('binary_bits.txt', 'r');
binary_string = fgetl(fileID);
fclose(fileID);
binary_data = arrayfun(@(x) str2double(x), binary_string);

N = 8;
T = 500e-9;
Ts = T/8;
f_sub = 1/T;
disp("subcarrier spacing is: ");
disp(f_sub);
disp("sampling interval is: ");
disp(Ts);

f_sample = 7*f_sub*16;
t_sample = 1/f_sample;
total_time = 500e-9;

t = 0 : t_sample : total_time-t_sample;

% for QPSK modulation
I_values = zeros(1, length(binary_data)/2);
Q_values = zeros(1, length(binary_data)/2);

for i = 1 : 2 : length(binary_data)-1
    b1 = binary_data(i);
    b2 = binary_data(i+1);
    
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

    index = (i+1)/2;
    I_values(index) = I;
    Q_values(index) = Q;
end  

% X_k & carriers
X = I_values + 1j * Q_values;

f = zeros(1,8);
for i = 0 : 7
   f(i+1) = i*f_sub;
end

x1 = X(2) * exp(1j * 2 * pi * f(2) * t);
x3 = X(4) * exp(1j * 2 * pi * f(4) * t);
x5 = X(6) * exp(1j * 2 * pi * f(6) * t);
x7 = X(8) * exp(1j * 2 * pi * f(8) * t);

figure('Position', [300, 100, 800, 600]);

subplot(4, 2, 1);
plot(t, real(x1));
title('Real part of k=1 (subcarrier 2)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4, 2, 2);
plot(t, imag(x1));
title('Imaginary part of k=1 (subcarrier 2)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4, 2, 3);
plot(t, real(x3));
title('Real part of k=3 (subcarrier 4)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4, 2, 4);
plot(t, imag(x3));
title('Imaginary part of k=3 (subcarrier 4)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4, 2, 5);
plot(t, real(x5));
title('Real part of k=5 (subcarrier 6)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4, 2, 6);
plot(t, imag(x5));
title('Imaginary part of k=5 (subcarrier 6)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4, 2, 7);
plot(t, real(x7));
title('Real part of k=7 (subcarrier 8)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4, 2, 8);
plot(t, imag(x7));
title('Imaginary part of k=7 (subcarrier 8)');
xlabel('Time (s)');
ylabel('Amplitude');

% sum of all the subcarriers
y = zeros(1, length(t));
for k = 1:length(X)
    y = y + X(k) * exp(1j * 2 * pi * f(k) * t);
end

figure('Position', [300, 100, 800, 600]);

subplot(2, 1, 1);
plot(t, real(y));
title('Real part of y');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t, imag(y));
title('Imaginary part of y');
xlabel('Time (s)');
ylabel('Amplitude');

time_x = ifft(X);
t_fft = (0 : length(X)-1) * Ts;

figure('Position', [300, 100, 800, 600]);

subplot(2, 1, 1);
plot(t_fft, real(time_x));
title('Real part of ifft');
stem(t_fft, real(time_x), 'r', 'filled');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-1,1]);

subplot(2, 1, 2);
plot(t_fft, imag(time_x));
title('Imaginary part of ifft');
stem(t_fft, imag(time_x), 'r', 'filled');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-1,1]);

y_scaled = y / length(X);
figure('Position', [300, 100, 800, 600]);

subplot(2, 1, 1);
plot(t, real(y_scaled));
ylim([-1,1]);
hold on;
stem(t_fft, real(time_x), 'r', 'filled');
title('Real part of y scaled');
xlabel('Time (s)');
ylabel('Amplitude');
hold off;

subplot(2, 1, 2);
plot(t, imag(y_scaled));
ylim([-1,1]);
hold on
stem(t_fft, imag(time_x), 'r', 'filled');
title('Imaginary part of y scaled');
xlabel('Time (s)');
ylabel('Amplitude');
hold off;

