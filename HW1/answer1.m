% use last two digits of my student id as seed: r13943124
% generate a 16bits random seqeunce
seed = 24;
rng(seed);
binary_bits = randi([0 1], 1, 16);
disp(binary_bits);

fileID = fopen('binary_bits.txt', 'w');
fprintf(fileID, '%d', binary_bits);
fclose(fileID);