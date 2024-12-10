% (a)
power_dB = [0, -3, -4, -8, -15];  
power_linear = 10.^(power_dB / 10);
disp('Linear Power Ratios:');
disp(power_linear);

% (b)
delays_ns = [0, 10, 40, 80, 100];
mean_excess_delay = sum(delays_ns .* power_linear) / sum(power_linear);
disp('Mean Excess Delay:');
disp(mean_excess_delay);

% (c)
delay_square = (delays_ns - mean_excess_delay).*(delays_ns - mean_excess_delay);
rms_delay = sqrt( sum(delay_square .* power_linear) / sum(power_linear) );
disp('RMS Delay:');
disp(rms_delay);