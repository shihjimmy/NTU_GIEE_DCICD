W64 = hadamard(64);
alpha = 4; % my id is r13943124

Gamma_w = zeros(1, 64);
for u = 1:64
    Gamma_w(u) = sum(W64(:, alpha + 1) .* W64(:, u)) / 64;
end

figure('Position', [300, 100, 800, 600]);
stem(1:64, Gamma_w);
title('2-(a) Cross-correlation \Gamma_w(u)');
xlabel('u');
ylabel('\Gamma_w(u)');

c1 = W64(:, alpha + 1); 
c2 = W64(:, 14);       
disp("code 1:");
disp(c1.');
disp("code 2:");
disp(c2.');
d = randi([0, 1], 1, 8) * 2 - 1; 

y = zeros(1,516);
for i = 1:8
    for j = 1:64
        y(64*(i-1)+j) = d(i) * c1(j);
    end
end
y(513:516) = [0,0,0,0];

figure('Position', [300, 100, 800, 600]);
subplot(2,1,1);
stem(1:8, d);
title('2-(b) Original symbols');
xlabel('Index');
ylabel('Symbols');

subplot(2,1,2);
stem(1:length(y), y);
title('2-(b) Spread signal');
xlabel('Sample index');
ylabel('Spread signal');

p_i = zeros(1, 8);
for i = 0:7
    p_i(i+1) = sum(y(64*i+1+2 : 64*i+64+2) .* c1.') / 64;
end

figure('Position', [300, 100, 800, 600]);
subplot(2,1,1);
stem(0:7, p_i);
title('2-(c) imperfect synchronization using code 1');
xlabel('Index i');
ylabel('p(i)');

p_i_sync = zeros(1, 8);
for i = 0:7
    p_i_sync(i+1) = sum(y(64*i+1 : 64*i+64) .* c2.') / 64;
end

subplot(2,1,2);
stem(0:7, p_i_sync);
title('2-(d) perfect synchronization using code 2');
xlabel('Index i');
ylabel('p(i)');
