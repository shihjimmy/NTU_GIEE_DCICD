% GSM Midamble
s = [1 1 -1 1 1 -1 1 -1 -1 -1 1 1 1 1 -1 1];

N = length(s);
k_vals = -N:N;
Phi = zeros(1, length(k_vals));
for k = k_vals
    for n = 1:N
        Phi(k + N + 1) = Phi(k + N + 1) + s(n) * s(mod(n + k - 1, N) + 1);
    end
end
Phi = Phi / N;

figure;
stem(k_vals, Phi);
xlabel('Lag k');
ylabel('Phi(k)');
title('Autocorrelation of GSM Midamble');
