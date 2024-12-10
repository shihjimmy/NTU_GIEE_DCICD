% read in the binary bits from answer1.m
fileID = fopen('binary_bits.txt', 'r');
binary_string = fgetl(fileID);
fclose(fileID);
binary_data = arrayfun(@(x) str2double(x), binary_string);

data = zeros(1,32);
data(1:16) = binary_data;
data(17:32) = ~binary_data;
disp("data is:");
disp(data);

%BPSK
for i = 1:32
    if(data(i))
        data(i) = -1;
    else
        data(i) = 1;
    end
end

M = 8; %carrriers
N = 4; %time slot
dd_domain_data = reshape(data, M, N);
disp("delay-doppler domain data is:");
disp(dd_domain_data);


%ISFFT and IFFT
time_domain_data_1 = zeros(M,N);
for col = 1:N
    time_domain_data_1(:, col) = fft(dd_domain_data(:, col)); 
end

for row = 1:M
    time_domain_data_1(row, :) = ifft(time_domain_data_1(row, :)); 
end

for col = 1:N
    time_domain_data_1(:, col) = ifft(time_domain_data_1(:, col)); 
end
time_domain_data_1 = time_domain_data_1 * sqrt(N/M);
disp(time_domain_data_1);
time_domain_data_1 = reshape(time_domain_data_1, [], M*N ,1);


%IFFT on each row
time_domain_data_2 = zeros(M,N);
for row = 1:M
    time_domain_data_2(row, :) = ifft(dd_domain_data(row, :)); 
end
disp(time_domain_data_2);
time_domain_data_2 = reshape(time_domain_data_2, [], M*N ,1);

t = (0:M*N-1); 

figure('Position', [300, 100, 800, 600]);
subplot(4, 1, 1);
stem(t, real(time_domain_data_1),"r","filled");
title('Real Part of OTFS Baseband Signal-4(a)');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-0.6,0.6]);

subplot(4, 1, 2);
stem(t, imag(time_domain_data_1),"r","filled");
title('Imaginary Part of OTFS Baseband Signal-4(a)');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-0.6,0.6]);

subplot(4, 1, 3);
stem(t, real(time_domain_data_2),"r","filled");
title('Real Part of OTFS Baseband Signal-4(b)');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-0.6,0.6]);

subplot(4, 1, 4);
stem(t, imag(time_domain_data_2),"r","filled"); 
title('Imaginary Part of OTFS Baseband Signal-4(b)');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-0.6,0.6]);
