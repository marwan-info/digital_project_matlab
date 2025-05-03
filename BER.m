% Channel Coding Comparison Project - Final Working Version
clc; clear; close all;

% ======================== PARAMETERS ========================
B = 100;                  % Number of information bits
r_rep = 1/3;              % Repetition code rate (1/3 gives better performance)
r_conv = 1/2;             % Convolutional code rate
r_polar = 1/2;            % Polar code rate
p_values = 0:0.05:0.5;    % Bit-flip probabilities
num_trials = 1000;        % Monte Carlo iterations

% ======================== SIMULATION ========================
ber_repetition = zeros(size(p_values));
ber_conv = zeros(size(p_values));
ber_polar = zeros(size(p_values));

for i = 1:length(p_values)
    p = p_values(i);
    errors_rep = 0; errors_conv = 0; errors_polar = 0;
    total_bits = 0;
    
    fprintf('Running p = %.2f...', p);
    
    for t = 1:num_trials
        % Generate random data
        data = randi([0 1], 1, B);
        
        % === Repetition Code ===
        code_rep = repetition_encoder(data, r_rep);
        received_rep = bsc_channel(code_rep, p);
        decoded_rep = repetition_decoder(received_rep, r_rep);
        errors_rep = errors_rep + sum(data ~= decoded_rep(1:B));
        
        % === Convolutional Code ===
        code_conv = convolutional_encoder(data);
        received_conv = bsc_channel(code_conv, p);
        decoded_conv = improved_conv_decoder(received_conv, B);
        errors_conv = errors_conv + sum(data ~= decoded_conv(1:B));
        
        % === Polar Code ===
        [code_polar, info_bits] = polar_encoder(data, r_polar, B);
        received_polar = bsc_channel(code_polar, p);
        decoded_polar = improved_polar_decoder(received_polar, B, info_bits);
        errors_polar = errors_polar + sum(data(1:length(decoded_polar)) ~= decoded_polar);
        
        total_bits = total_bits + B;
    end
    
    % Calculate BERs
    ber_repetition(i) = errors_rep / total_bits;
    ber_conv(i) = errors_conv / total_bits;
    ber_polar(i) = errors_polar / total_bits;
    
    fprintf(' Rep=%.4f, Conv=%.4f, Polar=%.4f\n', ...
            ber_repetition(i), ber_conv(i), ber_polar(i));
end

% ======================== PLOTTING ========================
figure;
semilogy(p_values, ber_repetition, '-o', 'LineWidth', 1.5, 'DisplayName', sprintf('Repetition (r=1/%d)', 1/r_rep)); 
hold on;
semilogy(p_values, ber_conv, '-x', 'LineWidth', 1.5, 'DisplayName', sprintf('Convolutional (r=1/%d)', 1/r_conv));
semilogy(p_values, ber_polar, '-s', 'LineWidth', 1.5, 'DisplayName', sprintf('Polar (r=1/%d)', 1/r_polar));
semilogy(p_values, p_values, '--k', 'LineWidth', 1, 'DisplayName', 'Uncoded');

xlabel('Bit Flip Probability (p)'); 
ylabel('Bit Error Rate (BER)');
title('BER Comparison of Channel Codes on BSC');
grid on; 
legend('Location', 'southwest');
ylim([1e-4 1]);
set(gca, 'FontSize', 12);

% ======================== HELPER FUNCTIONS ========================

% Repetition Code Functions
function encoded = repetition_encoder(data, r)
    L = ceil(1/r); % Number of repetitions
    encoded = repelem(data, L);
end

function decoded = repetition_decoder(received, r)
    L = ceil(1/r);
    N = floor(length(received)/L); % Only complete blocks
    decoded = zeros(1, N);
    
    for i = 1:N
        chunk = received((i-1)*L+1:i*L);
        % Weighted decision (count 1s vs 0s)
        decoded(i) = sum(chunk) > L/2;
    end
end

% Channel Model
function y = bsc_channel(x, p)
    noise = rand(size(x)) < p;
    y = mod(x + noise, 2);
end

% Convolutional Code Functions
function encoded = convolutional_encoder(data)
    % Rate 1/2 convolutional encoder
    g1 = [1 1 1];  % Generator polynomial 7 (111)
    g2 = [1 0 1];  % Generator polynomial 5 (101)
    K = length(g1);
    data_padded = [zeros(1,K-1), data]; % Zero padding
    n = length(data);
    encoded = zeros(1, 2*n);

    for i = 1:n
        window = data_padded(i:i+K-1);
        encoded(2*i-1) = mod(sum(window .* g1), 2);
        encoded(2*i)   = mod(sum(window .* g2), 2);
    end
end

function decoded = improved_conv_decoder(received, B)
    n = length(received)/2;
    decoded = zeros(1,B);
    prev_bit = 0;
    
    for i = 1:min(B,n)
        pair = received(2*i-1:2*i);
        
        % Enhanced decoding logic:
        if all(pair == [0 0])
            decoded(i) = 0;
        elseif all(pair == [1 1])
            decoded(i) = 1;
        else
            % Use previous bit when current bits disagree
            decoded(i) = prev_bit;
        end
        prev_bit = decoded(i);
    end
end

% Polar Code Functions
function [encoded, info_bits] = polar_encoder(data, r, B)
    N = 128; % Block length (power of 2)
    K = round(N*r);
    
    % Ensure proper sizing
    K = min([K, N, B]);
    
    % Select information bits (first K bits for simplicity)
    info_bits = 1:K;
    
    % Pad data if needed
    if length(data) < K
        data_padded = [data zeros(1,K-length(data))];
    else
        data_padded = data(1:K);
    end
    
    encoded = zeros(1,N);
    encoded(info_bits) = data_padded;
    % Frozen bits set to 0
    encoded(setdiff(1:N, info_bits)) = 0;
end

function decoded = improved_polar_decoder(received, B, info_bits)
    decoded = zeros(1, min(B, length(info_bits)));
    
    for i = 1:length(decoded)
        idx = info_bits(i);
        
        % Use 3-bit majority voting around the info bit
        start = max(1, idx-1);
        stop = min(length(received), idx+1);
        window = received(start:stop);
        decoded(i) = mode(window);
    end
end