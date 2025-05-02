%% Parameters
B = 100e3;                    % Channel bandwidth = 100 kHz
T = 2 / B;                    % Pulse duration = 20 us
Fs = 20 * B;                  % Sampling frequency = 2 MHz (oversampling)
dt = 1 / Fs;
t = -10*T:dt:10*T;              % Time vector, wide enough to contain full pulse
N = length(t);

%% message Square Pulse (duration T, centered at t = 0)  
width = 2*T ;
square_pulse = rectpuls(t, width); % from [40us to -40 us] in freq turn to sinc with nulls at 25 , 50 , 100 , .......
%% Frequency vector for plotting
f = linspace(-Fs/2, Fs/2, N);   % Frequency axis centered at 0 Hz

%% FFT of square pulse
X_f = fftshift(fft(square_pulse));         % Centered FFT
X_mag = abs(X_f) / max(abs(X_f));          % Normalize

%% Define Ideal Low-Pass Filter in Frequency Domain
thefilter = rectpuls(f,2*B);           % 1 in [-B, B], 0 elsewhere

%% Plot Both in Frequency Domain
figure;
plot(f/1e3, X_mag, 'b', 'LineWidth', 2); hold on;
plot(f/1e3, thefilter, 'r--', 'LineWidth', 2);
xlabel('Frequency (kHz)');
ylabel('Magnitude (normalized)');
title('Frequency Domain: Square Pulse Spectrum vs Ideal Filter');
legend('Square Pulse Spectrum', 'Ideal LPF (Band-limited Channel)');
xlim([-500 500]);  % Show ±500 kHz around 0
grid on;


Square_pulse_Freq = fftshift(fft(square_pulse));
Filtered_Freq = Square_pulse_Freq .* thefilter;
filtered_time = ifft(ifftshift(Filtered_Freq), 'symmetric');

figure;
plot(t*1e6, square_pulse, 'b', 'LineWidth', 1.5); hold on;
plot(t*1e6, filtered_time, 'r', 'LineWidth', 1.5);
xlabel('Time (\mus)'); ylabel('Amplitude');
legend('Original', 'Filtered');
title('Square Pulse Before and After Band-Limited Channel ');
grid on;


figure;
plot(f/1e3, abs(Square_Freq), 'b'); hold on;
plot(f/1e3, abs(Filtered_Freq), 'r');
xlabel('Frequency (kHz)'); ylabel('|Amplitude|');
legend('Original Spectrum', 'Filtered Spectrum');
title('Frequency Domain Before and After Filtering');
grid on;

pulse1 = rectpuls(abs(t - T) ,T/2);  % First pulse at t = T
pulse2 = rectpuls(abs(t - 3*T) , T/2); % Second pulse at t = 3T


% Frequency-domain filtering
P1_F = fftshift(fft(pulse1));
P1_Filt = P1_F .* thefilter;
pulse1_out = ifft(ifftshift(P1_Filt), 'symmetric');

P2_F = fftshift(fft(pulse2));
P2_Filt = P2_F .* thefilter;
pulse2_out = ifft(ifftshift(P2_Filt), 'symmetric');

figure;
plot(t*1e6, pulse1, 'b--', 'LineWidth', 1.2); hold on;
plot(t*1e6, pulse2, 'g--', 'LineWidth', 1.2);
xlabel('Time (\mus)'); ylabel('Amplitude');
legend('Pulse 1 (input)', 'Pulse 2 (input)');
title('Original Two Square Pulses Before Channel');
grid on;

figure;
plot(t*1e6, pulse1_out, 'b', 'LineWidth', 1.5); hold on;
plot(t*1e6, pulse2_out, 'g', 'LineWidth', 1.5);
xlabel('Time (\mus)'); ylabel('Amplitude');
legend('Pulse 1 (output)', 'Pulse 2 (output)');
title('3-Filtered Pulses After Band-Limited Channel');
grid on;
