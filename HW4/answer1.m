alpha1 = 1;
theta_r = rand * pi - pi/2; 
theta_t = rand * pi - pi/2;
N = 32;

kd = pi;
aULA_r1 = exp(1j * kd * (0:N-1)' * sin(theta_r));
aULA_t1 = exp(1j * kd * (0:0) * sin(theta_t)).';
H1 = alpha1 * aULA_r1 * aULA_t1';

% (a)
id = 4;
m1 = id; 
c_m = exp(1j * 2 * pi * m1 / N * (0:N-1)');
theta_scan = linspace(-pi/2, pi/2, 1000);
aULA_r = exp(1j * kd * (0:N-1)' * sin(theta_scan));
aULA_t = 1;
H = alpha1 * aULA_r * aULA_t;
beam_pattern = abs(c_m' * H);

figure;
polarplot(theta_scan, beam_pattern);
title('1-(a) Beam Pattern');

% (b)
m_vals = -16:15;
mag_values = arrayfun(@(m) abs(exp(1j * 2 * pi * m / N * (0:N-1)')' * H1), m_vals);
[~, max_index] = max(mag_values);
best_m = m_vals(max_index);
phi = asin(2*best_m / N);

disp("theta_r is: ");
disp(theta_r);
disp("Our theta based on the best result of m")
disp(phi);

figure;
stem(m_vals, mag_values);
xlabel('m');
ylabel('|c(m)H2|');
title('1-(b) Magnitude of Combination Result vs m');

% (c)
alpha2 = 0.2 + 0.3j;
theta_r2 = theta_r + 0.4;
aULA_r2 = exp(1j * kd * (0:N-1)' * sin(theta_r2));
aULA_t2 = aULA_t1;
H2 = ((0.4 - 0.7j) * aULA_r1 * aULA_t1' + alpha2 * aULA_r2 * aULA_t2') / sqrt(2);

m_vals = -16:15;
mag_values = arrayfun(@(m) abs(exp(1j * 2 * pi * m / N * (0:N-1)')' * H2), m_vals);
[~, max_index] = max(mag_values);
best_m = m_vals(max_index);
phi = asin(2*best_m / N);

disp("theta_r2 is: ");
disp(theta_r2);
disp("Our theta based on the best result of m")
disp(phi);

figure;
stem(m_vals, mag_values);
xlabel('m');
ylabel('|c(m)H2|');
title('1-(c) Magnitude of Combination Result vs m');



