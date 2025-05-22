% BER Simulation for Different Pulse Shapes in AWGN using BPSK

clc; clear; close all;

% Parameters
SNR_dB = 0:1:10;
numBits = 1e4;
samples_per_symbol = 8;
span = 6; % in symbols (for pulse shaping filters)

% Pulse shape definitions
pulse_shapes = {
    ones(1, samples_per_symbol);                               % Rectangular
    rcosdesign(1.0, span, samples_per_symbol, 'normal');       % Raised Cosine, roll-off = 1.0
    rcosdesign(0.35, span, samples_per_symbol, 'sqrt');        % Root Raised Cosine, roll-off = 0.35
    gaussdesign(0.3, span, samples_per_symbol)                 % Gaussian pulse, BT = 0.3
};

pulse_labels = {'Rectangular', 'Raised Cosine', 'Root Raised Cosine', 'Gaussian'};
numShapes = length(pulse_shapes);

% Initialize BER results
BER = zeros(length(SNR_dB), numShapes);

% Loop over each pulse shape
for p = 1:numShapes
    pulse = pulse_shapes{p};
    pulse_length = length(pulse);
    
    for k = 1:length(SNR_dB)
        % Generate bits and BPSK symbols
        bits = randi([0 1], 1, numBits); % 10^5
        symbols = 2 * bits - 1;  % BPSK: 0 -> -1, 1 -> +1

        % Upsample symbols
        tx_upsampled = upsample(symbols, samples_per_symbol); % just add zero between each symbol 

        % Transmit signal through pulse shaping filter
        tx_signal = conv(tx_upsampled, pulse, 'full'); % make full convolution, so the output is longer than the input

        % Add AWGN
        SNR_linear = 10^(SNR_dB(k)/10); %Converts SNR from dB to linear scale
        noise_power = var(tx_signal) / SNR_linear; %variance signal -> power of message 
        noise = sqrt(noise_power) * randn(1, length(tx_signal)); % randn : genrate random numbers from guassian distribution it is noise 
        rx_signal = tx_signal + noise; 

        % Matched filter (same pulse shape)
        rx_filtered = conv(rx_signal, pulse, 'full');

        % Compute total delay from both filters
        total_delay = 2 * (span * samples_per_symbol / 2);
        sample_start = total_delay + 1;
        sample_points = sample_start:samples_per_symbol:sample_start + samples_per_symbol * (numBits - 1);

        % Handle edge condition
        if max(sample_points) > length(rx_filtered)
            warning('Sample points exceed received signal. Adjusting.');
            sample_points = sample_points(sample_points <= length(rx_filtered));
        end

        rx_samples = rx_filtered(sample_points);

        % Demodulation
        bits_rx = rx_samples > 0;

        % Trim reference bits if needed
        bits_trimmed = bits(1:length(bits_rx));

        % Calculate BER
        BER(k, p) = sum(bits_rx ~= bits_trimmed) / length(bits_trimmed);
    end
end
% Plotting the results
figure;
semilogy(SNR_dB, BER, 'LineWidth', 2);
legend(pulse_labels, 'Location', 'northwest');
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs SNR for Different Pulse Shapes in AWGN (BPSK)');
grid on;
