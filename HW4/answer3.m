N = 200; 
T = 1;
Ts = T; 
delta_f = 1 / (500*Ts); 
n = 0:N-1; 

QPSK_symbols = [exp(1j * pi / 4), exp(1j * 3 * pi / 4), exp(-1j * 3 * pi / 4), exp(-1j * pi / 4)];
p_n = QPSK_symbols(randi([1, 4], 1, N));
s_n = p_n .* exp(1j * 2 * pi * delta_f * n * Ts);
true_phase_rotation = angle(s_n ./ p_n);

theta_estimate = zeros(1,N);

for i = 1:N
    s_n_img = imag(s_n(i));
    s_n_real = real(s_n(i));
    
    if(s_n_real<0)
        d_real = -1;
    else
        d_real = 1;
    end
    
    if(s_n_img<0)
        d_img = -1;
    else
        d_img = 1;
    end

    theta_estimate(i) = s_n_real*d_img - s_n_img*d_real;
end

figure;
subplot(2,1,1);
stem(n, true_phase_rotation);
xlabel('Symbol Index (n)');
ylabel('True Phase Rotation (radians)');
title('True Phase Rotation due to Carrier Frequency Offset');

subplot(2,1,2);
stem(n, theta_estimate);
xlabel('Symbol Index (n)');
ylabel('theta estimate (radians)');
title('theta estimate due to Carrier Frequency Offset');

