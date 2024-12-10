load('HW4.mat'); 
N = 128;
Ng = 32;
epsilon = 5.7;
Ts = 1;
fs = 1/Ts;
fsub = 1/(N*Ts);
R = 96;
L = 64;
y_n = OFDMTx .* exp(1j * 2 * pi * epsilon / N * (1:length(OFDMTx))); 
y_n = [zeros(1,R+L-1), y_n];

Phi_DC = zeros(1, length(y_n) - R - L);
for m = R + L :length(y_n)
    Phi_DC(m) = abs(sum(y_n(m - R + 1: m) .* conj(y_n(m - R - L + 1: m - L))));
end
Phi_DC = Phi_DC(R+L : length(y_n));

figure;
plot(Phi_DC);
xlabel('Sample Index m');
ylabel('|Phi_{DC}(m)|');
title('Delay-and-Correlate Result for Carrier Frequency Offset Estimation');
[max_val, max_idx] = max(Phi_DC);
hold on;
plot(max_idx, max_val, 'ro'); 
text(max_idx, max_val, sprintf('Peak: (m=%d, Phi_{DC}=%.2f)', max_idx, max_val));
hold off;
fprintf('The maximum correlation occurs at m = %d\n', max_idx);

y_n = OFDMTx .* exp(1j * 2 * pi * epsilon / N * (1:length(OFDMTx))); 
epsilon_est = N / (2 * pi * L) * angle(sum(y_n(max_idx - (R-1) : max_idx) .* conj(y_n(max_idx - (R-1) - L : max_idx - L))));
fprintf('Estimated epsilon: %.4f\n', epsilon_est);
