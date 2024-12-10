load('hw4.mat'); 
OFDM = OFDMTx;

% (a)(b)
R = 32;
L = 64;
OFDM_data = [zeros(1,R+L-1), OFDM];
Phi_DC = zeros(1, length(OFDM_data) - R - L);

for m = R + L : length(OFDM_data)
    Phi_DC(m) = abs(sum(OFDM_data(m - R + 1: m) .* conj(OFDM_data(m - R - L + 1 : m - L))));
end
Phi_DC = Phi_DC(R+L : length(OFDM_data));

figure;
plot(Phi_DC);
xlabel('m');
ylabel('|Phi_{DC}(m)|');
title('Delay-and-Correlate Result for R=32, L=64');

[max_val, max_idx] = max(Phi_DC);
hold on;
plot(max_idx, max_val, 'ro'); 
text(max_idx, max_val, sprintf('Peak: (m=%d, |Phi_{DC}(m)|=%.2f)', max_idx, max_val));
hold off;
fprintf('The value of m that maximizes Phi_DC(m) is %d with a magnitude of %.2f.\n', max_idx, max_val);

% (c)(d)
R = 96;
L = 64;
OFDM_data = [zeros(1,R+L-1), OFDM];
Phi_DC2 = zeros(1, length(OFDM_data) - R - L);

for m = R + L  : length(OFDM_data)
    Phi_DC2(m) = abs(sum(OFDM_data(m - R + 1 : m) .* conj(OFDM_data(m - R - L + 1 : m - L))));
end
Phi_DC2 = Phi_DC2(R+L : length(OFDM_data));

figure;
plot(Phi_DC2);
xlabel('m');
ylabel('|Phi_{DC}(m)|');
title('Delay-and-Correlate Result for R=96, L=64');

[max_val2, max_idx2] = max(Phi_DC2);
hold on;
plot(max_idx2, max_val2, 'ro');
text(max_idx2, max_val2, sprintf('Peak: (m=%d, |Phi_{DC}(m)|=%.2f)', max_idx2, max_val2));
hold off;
fprintf('The value of m that maximizes Phi_DC(m) for R=96, L=64 is %d with a magnitude of %.2f.\n', max_idx2, max_val2);
