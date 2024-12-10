% my student id is r13943124
% 1021(octave)
N = 2^9 - 1;
ml_sequence = zeros(1, N+1);
feedback_poly = flip([1 0 0 0 0 1 0 0 0 1]);
s = 4;
initial_state = de2bi(s + 1, 9, 'left-msb');
state = initial_state;
disp(initial_state);

for i = 1:N+1
    ml_sequence(i) = state(end);
    new_bit = mod(sum(state .* feedback_poly(2:10)), 2);
    state = [new_bit, state(1:end-1)]; 
end
disp('b_0 to b_19');
disp(ml_sequence(1:20));

d_n = -2*ml_sequence + 1;
Phi_s = zeros(1, 2*N+1);
for l = -N:N
    sum_val = 0;
    for n = 1:N
        shifted_index = mod(n + l -1, N) + 1;
        sum_val = sum_val + d_n(n) * d_n(shifted_index);
    end
    Phi_s(l + N + 1) = sum_val / N; 
end

figure('Position', [300, 100, 800, 600]);
stem(-N:N, Phi_s);
title('Autocorrelation of ML sequence');
xlabel('l');
ylabel('\Phi_s(l)');
