% (a)
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
disp('Normalized channel gains (h_i):');
disp(h_i);

% (b)
delays = [0, 10, 40, 80, 100] * 1e-9;  
f = linspace(-100e6, 100e6, 1000);
H_f = zeros(size(f)); 
for i = 1:length(h_i)
    H_f = H_f + h_i(i) * exp(-1j * 2 * pi * f * delays(i));
end

%(c)
figure('Position', [300, 100, 800, 600]);
subplot(2, 1, 1);
plot(f / 1e6, abs(H_f));
xlabel('Frequency (MHz)');
ylabel('Magnitude');
title('Magnitude of Frequency Response');

subplot(2, 1, 2);
plot(f / 1e6, angle(H_f));
xlabel('Frequency (MHz)');
ylabel('Phase (radians)');
title('Phase of Frequency Response');

% (d)
mean_excess_delay = sum(delays .* power_linear) / sum(power_linear);
delay_square = (delays - mean_excess_delay).*(delays - mean_excess_delay);
rms_delay = sqrt( sum(delay_square .* power_linear) / sum(power_linear) );
B_c = 1 / (5 * rms_delay);
disp('Coherence Bandwidth:');
disp(B_c);

subcarriers = floor(100e6 / B_c);
disp('Number of subcarriers for flat-fading:');
disp(subcarriers);


