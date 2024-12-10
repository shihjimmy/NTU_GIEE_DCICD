load('HW5-3.mat'); 
s = [1 1 -1 1 1 -1 1 -1 -1 -1 1 1 1 1 -1 1]; 

% (a)
m_start = 65;
m_end = 86;

% (b)
h_est = zeros(5,1); 
s_used = circshift(s, 12);
disp("sequence used for autocorrelation is: ");
disp(s_used);

for r = 1:5
    h_est(r) =  sum( GSMRx( m_start+r : m_start+r+15 ) .* s_used ) / 16 ;
end

disp(" (h0 to h4) estimated channel response is: ");
disp(h_est);
