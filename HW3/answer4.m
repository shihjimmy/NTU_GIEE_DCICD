X = sqrt(0.5) * randn(1, 5);  
Y = sqrt(0.5) * randn(1, 5);  
gamma = X + 1j * Y;  

power_dB = [0, -3, -4, -8, -15];
power_linear = 10.^(power_dB / 10); 
alpha = sqrt(power_linear); 
g_i = alpha .* gamma;

% Normalization constant
K = 1 / sqrt(sum(abs(g_i).^2)); 
h_i = K * g_i;
disp(h_i);

% (a)
N = 64;
Xk = randi([0 1], 1, N) * 2 - 1; 
disp(Xk);

% (b)
xn = ifft(Xk, N);
CP_length = 16;
xn_CP = [xn(end-CP_length+1:end), xn];
n = -CP_length:(N-1);

figure('Position', [300, 100, 800, 600]);
subplot(2, 1, 1);
stem(n, real(xn_CP));
title('Real Part of Baseband Transmitted Signal');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(2, 1, 2);
stem(n, imag(xn_CP));
title('Imaginary Part of Baseband Transmitted Signal');
xlabel('Sample Index');
ylabel('Amplitude');

% (c)
delays = [0, 10, 40, 80, 100] * 1e-9; 
fs = 100e6;
Ts = 1 / fs;  
n_delay = delays / Ts; 
max_delay = max(n_delay);
h = zeros(1, max_delay);
for i = 1:length(n_delay)
    h(n_delay(i)+1) = h_i(i);
end

yn = conv(xn_CP, h);
n = -CP_length:(length(yn)-CP_length-1);

figure('Position', [300, 100, 800, 600]);
subplot(2, 1, 1);
stem(n, real(yn));
title('Real Part of Baseband Received Signal');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(2, 1, 2);
stem(n, imag(yn));
title('Imaginary Part of Baseband Received Signal');
xlabel('Sample Index');
ylabel('Amplitude');

% (d)(e)
Yk = fft(yn(CP_length+1: CP_length+N));
Hk = Yk ./ Xk;

figure('Position', [300, 100, 800, 600]);
subplot(2, 1, 1);
stem(abs(Hk));
title('Magnitude of Hk');
xlabel('index');
ylabel('Magnitude');

subplot(2, 1, 2);
stem(angle(Hk));
title('Phase of Hk');
xlabel('index');
ylabel('Phase (radians)');

num = 200e6 / (fs/N);
f = linspace(-100e6, 100e6, num);
f_k = (-N/2:N/2-1) * (fs / N);
H_f = zeros(size(f)); 
for i = 1:length(h_i)
    H_f = H_f + h_i(i) * exp(-1j * 2 * pi * f * delays(i));
end

% comparison for Q4(d) and Q2(c)
Hk_shifted = fftshift(Hk);

figure('Position', [300, 100, 800, 600]);
subplot(2, 1, 1);
plot(f / 1e6, abs(H_f), 'b', 'LineWidth', 1.5);  
hold on;
stem(f_k / 1e6, abs(Hk_shifted), 'r--', 'LineWidth', 1);  
hold off;
title('Magnitude of Frequency Response');
xlabel('Frequency (MHz)');
ylabel('Magnitude');
legend('Q2(c) Response', 'Q4(d) Response');
grid on;

subplot(2, 1, 2);
plot(f / 1e6, angle(H_f), 'b', 'LineWidth', 1.5); 
hold on;
stem(f_k / 1e6, angle(Hk_shifted), 'r--', 'LineWidth', 1);  
hold off;
title('Phase of Frequency Response');
xlabel('Frequency (MHz)');
ylabel('Phase (radians)');
legend('Q2(c) Response', 'Q4(d) Response');
grid on;


% (f)(g)
zn = conv(xn, h);
Zk = fft(zn(1:N)); 
Hk_prime = Zk ./ Xk;

figure('Position', [300, 100, 800, 600]);
subplot(2, 1, 1);
stem(abs(Hk_prime));
title('Magnitude of Hk (Without CP)');
xlabel('index');
ylabel('Magnitude');

subplot(2, 1, 2);
stem(angle(Hk_prime));
title('Phase of Hk (Without CP)');
xlabel('index');
ylabel('Phase (radians)');


% comparison for Q4(f) and Q2(c)
Hk_prime_shifted = fftshift(Hk_prime);

figure('Position', [300, 100, 800, 600]);
subplot(2, 1, 1);
plot(f / 1e6, abs(H_f), 'b', 'LineWidth', 1.5);  
hold on;
stem(f_k / 1e6, abs(Hk_prime_shifted), 'r--', 'LineWidth', 1);  
hold off;
title('Magnitude of Frequency Response');
xlabel('Frequency (MHz)');
ylabel('Magnitude');
legend('Q2(c) Response', 'Q4(f) Response');
grid on;

subplot(2, 1, 2);
plot(f / 1e6, angle(H_f), 'b', 'LineWidth', 1.5); 
hold on;
stem(f_k / 1e6, angle(Hk_prime_shifted), 'r--', 'LineWidth', 1);  
hold off;
title('Phase of Frequency Response');
xlabel('Frequency (MHz)');
ylabel('Phase (radians)');
legend('Q2(c) Response', 'Q4(f) Response');
grid on;
