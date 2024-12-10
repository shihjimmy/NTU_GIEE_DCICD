N = 63;
n = 0:N-1; 

u1 = 25; % my student id is r13943124
% Generate Zadoff-Chu sequence
S = exp(1j * pi * u1 * n .* (n + 1) / N);

% Autocorrelation
Phi_s = zeros(1, 2*N+1);
for l = -N:N
    Phi_s(l+N+1) = sum(S .* conj(circshift(S, l)))/N;
end

figure('Position', [300, 100, 800, 600]);
subplot(4,1,1);
stem(-N:N, abs(Phi_s));
title('1-(a) Autocorrelation of Zadoff-Chu sequence');
xlabel('l');
ylabel('|\Phi_s(l)|');
ylim([0,1]);

u2 = 34;
% Generate Zadoff-Chu sequence for u2
S2 = exp(1j * pi * u2 * n .* (n + 1) / N);

% Cross-correlation
Omega_s = zeros(1, 2*N+1);
for l = -N:N
    Omega_s(l+N+1) = sum(S .* conj(circshift(S2, l)))/N;
end

subplot(4,1,2);
stem(-N:N, abs(Omega_s));
title('1-(b) Cross-correlation between u1 and u2 sequences');
xlabel('l');
ylabel('|\Omega_s(l)|');
ylim([0,1]);

% Initialize the data subcarriers
X_k = zeros(1, N); 
X_k(1:31) = S(1:31);
X_k(32) = 0;
X_k(33:N) = S(33:N); 

% Autocorrelation of X_k
Phi_s_mapped = zeros(1, 2*N+1);
for l = -N:N
    Phi_s_mapped(l+N+1) = sum(X_k .* conj(circshift(X_k, l)))/N;
end

% Cross-correlation of X_k
Omega_s_mapped = zeros(1, 2*N+1);
for l = -N:N
    Omega_s_mapped(l+N+1) = sum(X_k .* conj(circshift(S2, l)))/N;
end

subplot(4,1,3);
stem(-N:N, abs(Phi_s_mapped));
title('1-(c) Autocorrelation of mapped Zadoff-Chu sequence');
xlabel('l');
ylabel('|\Phi_s(l)|');
ylim([0,1]);

subplot(4,1,4);
stem(-N:N, abs(Omega_s_mapped));
title('1-(c) Cross-correlation of mapped Zadoff-Chu sequence');
xlabel('l');
ylabel('|\Omega_s(l)|');
ylim([0,1]);
