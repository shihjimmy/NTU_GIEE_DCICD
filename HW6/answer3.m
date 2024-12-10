load('HW6-1b.mat'); 

% Map x_hat_noisy to nearest 16-QAM constellation
qam_constellation = [-3-3j, -3-1j, -3+1j, -3+3j, ...
                     -1-3j, -1-1j, -1+1j, -1+3j, ...
                      1-3j,  1-1j,  1+1j,  1+3j, ...
                      3-3j,  3-1j,  3+1j,  3+3j];

[X1, X2, X3] = ndgrid(qam_constellation, qam_constellation, qam_constellation);
X_all = [X1(:), X2(:), X3(:)].';

num_candidates = size(X_all, 2);
Gamma = zeros(1, num_candidates);  

for i = 1:num_candidates
    x_candidate = X_all(:, i); 
    Gamma(i) = norm(yprime - Hmatrix * x_candidate)^2;
end

[Gamma_min, min_idx] = min(Gamma);
x_ML = X_all(:, min_idx);

figure;
plot(1:num_candidates, Gamma, '-o');
xlabel('Index of Candidate');
ylabel('Gamma(x)');
title('Cost Function vs Candidate Index');
grid on;

disp(['Minimum cost function value: ', num2str(Gamma_min)]);
disp('ML solution: ');
disp(x_ML);


% (b)
[Q, R] = qr(Hmatrix);
z = Q' * yprime;

disp('z vector:');
disp(z);

% (c)
function res = T_1(z,R,x)
    res1 = z(3) - R(3,3)*x(3);
    res2 = z(2) - ( R(2,2)*x(2) + R(2,3)*x(3) );
    res3 = z(1) - ( R(1,1)*x(1) + R(1,2)*x(2) + R(1,3)*x(3) );
    res = (abs(res1))^2 + (abs(res2))^2 + (abs(res3))^2;
end

function res = T_2(z,R,x)
    res1 = z(3) - R(3,3)*x(3);
    res2 = z(2) - ( R(2,2)*x(2) + R(2,3)*x(3) );
    res  = (abs(res1))^2 + (abs(res2))^2;
end

function res = T_3(z,R,x)
    res = (abs(z(3) - R(3,3)*x(3)))^2;
end

k = 8;

% layer3
layer3_qam = zeros(16,1);
layer3 = zeros(16,1);

for i = 1:16
    layer3_qam(i) = qam_constellation(i);
    layer3(i) = T_3(z,R, [0,0,layer3_qam(i)] );
end
[~, indices] = mink(layer3, 8);
layer3_result = layer3_qam(indices);

% layer2
layer2_qam = zeros(8,16);
layer2 = zeros(8,16);

for j = 1:8
    for i = 1:16
        layer2_qam(j,i) = qam_constellation(i);
        layer2(j,i) = T_2(z,R, [0, layer2_qam(j,i),layer3_result(j)] );
    end
end
layer2_vec = layer2(:);
[~, indices] = mink(layer2_vec, 8);
[row_indices, col_indices] = ind2sub(size(layer2), indices);

layer2_result = zeros(8,2);
for i=1:8
    layer2_result(i, :) = [layer2_qam(row_indices(i) ,col_indices(i)),  layer3_result(row_indices(i))];
end

% layer1
layer1_qam = zeros(8, 16);
layer1 = zeros(8, 16);

for j = 1:8
    for i = 1:16
        layer1_qam(j, i) = qam_constellation(i);
        layer1(j, i) = T_1(z, R, [layer1_qam(j, i), layer2_result(j, 1), layer2_result(j, 2)]);
    end
end

layer1_vec = layer1(:);
[~, indices] = mink(layer1_vec, 8);
[row_indices, col_indices] = ind2sub(size(layer1), indices);

layer1_result = zeros(8, 3);
for i = 1:8
    layer1_result(i, :) = [layer1_qam(row_indices(i), col_indices(i)), ...
                           layer2_result(row_indices(i), :)];
end

[~, min_index] = min(layer1_vec);
[row_indices, col_indices] = ind2sub(size(layer1), min_index);
x_8B = [layer1_qam(row_indices, col_indices), ...
                           layer2_result(row_indices, :)];

disp("detected result (x_8B) is :");
disp(x_8B);
disp("cost function of x_8B is :");
disp(T_1(z,R,x_8B));

% Euclidean distance of layer1
figure;
plot(1:128, layer1_vec, '-o');
xlabel('Index of Visited Vectors');
ylabel('Euclidean Distance');
title('Euclidean Distance of 128 Leaf Nodes');
grid on;


% (d)
if (x_8B(1)==x_ML(1) && x_8B(2)==x_ML(2) && x_8B(3)==x_ML(3))
    disp('x_8B is the same as x_ML. This indicates the 8-best algorithm found the optimal solution.');
else
    disp('x_8B is different from x_ML. This is due to the pruning of search space in the 8-best algorithm.');
end
