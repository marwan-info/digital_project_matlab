# digital_project_matlab

## part 1 :  Inter-Symbol Interference due to band-limited channels
### steps : 

---

# 📘 **MATLAB Guide: Investigating Band-Limited Channels and ISI**

---

## ✅ **Part 1: Effect of a Band-Limited Channel on a Single Square Pulse**

---

### **Step 1: Define Parameters**

```matlab
B = 100e3;          % Channel bandwidth = 100 kHz
T = 2/B;            % Pulse duration = 2/B
Fs = 10*B;          % Sampling rate (10x B for better resolution)
dt = 1/Fs;
t = -5*T:dt:5*T;    % Time axis centered around 0
```

---

### **Step 2: Generate a Square Pulse of Duration T = 2/B**

```matlab
square_pulse = double(abs(t) <= T/2);  % Square pulse centered at t=0
```

---

### **Step 3: Create Band-Limited Channel (Ideal Low-Pass Filter)**

```matlab
N = length(t);
f = linspace(-Fs/2, Fs/2, N);  % Frequency axis
H = double(abs(f) <= B/2);     % Ideal filter: passes only within [-B/2, B/2]
```

---

### **Step 4: Apply Filter in Frequency Domain**

```matlab
Square_Freq = fftshift(fft(square_pulse));
Filtered_Freq = Square_Freq .* H;
filtered_time = ifft(ifftshift(Filtered_Freq), 'symmetric');
```

---

### **Step 5: Plot Time Domain (Before and After)**

```matlab
figure;
plot(t*1e6, square_pulse, 'b', 'LineWidth', 1.5); hold on;
plot(t*1e6, filtered_time, 'r', 'LineWidth', 1.5);
xlabel('Time (\mus)'); ylabel('Amplitude');
legend('Original', 'Filtered');
title('Square Pulse Before and After Band-Limited Channel');
grid on;
```

#### 🔍 **Why This Shape?**

After filtering, the square pulse becomes **smeared out** — no longer sharp edges. This is due to the loss of high-frequency components. The result is a **sinc-like ringing** (Gibbs phenomenon), which **extends beyond the original duration T**. This is the beginning of **Inter-Symbol Interference (ISI)**.

---

### **Step 6: Plot Frequency Domain (Before and After)**

```matlab
figure;
plot(f/1e3, abs(Square_Freq), 'b'); hold on;
plot(f/1e3, abs(Filtered_Freq), 'r');
xlabel('Frequency (kHz)'); ylabel('|Amplitude|');
legend('Original Spectrum', 'Filtered Spectrum');
title('Frequency Domain Before and After Filtering');
grid on;
```

#### 🔍 **Why This Shape?**

* The original square pulse has infinite frequency content (sinc spectrum).
* The filtered signal has components **truncated at ±50 kHz**, causing time-domain ringing.

---

## ✅ **Part 2: Two Consecutive Square Pulses and ISI Visualization**

---

### **Step 7: Create First and Second Pulses at Different Time Offsets**

```matlab
pulse1 = double(abs(t - T) <= T/2);  % First pulse at t = T
pulse2 = double(abs(t - 3*T) <= T/2); % Second pulse at t = 3T
```

### **Step 8: Filter Each Pulse Separately**

```matlab
% Frequency-domain filtering
P1_F = fftshift(fft(pulse1));
P1_Filt = P1_F .* H;
pulse1_out = ifft(ifftshift(P1_Filt), 'symmetric');

P2_F = fftshift(fft(pulse2));
P2_Filt = P2_F .* H;
pulse2_out = ifft(ifftshift(P2_Filt), 'symmetric');
```

---

### **Step 9: Plot Time Domain Before Filtering (Both Pulses)**

```matlab
figure;
plot(t*1e6, pulse1, 'b--', 'LineWidth', 1.2); hold on;
plot(t*1e6, pulse2, 'g--', 'LineWidth', 1.2);
xlabel('Time (\mus)'); ylabel('Amplitude');
legend('Pulse 1 (input)', 'Pulse 2 (input)');
title('Original Two Square Pulses Before Channel');
grid on;
```

---

### **Step 10: Plot Time Domain After Filtering (Both Pulses)**

```matlab
figure;
plot(t*1e6, pulse1_out, 'b', 'LineWidth', 1.5); hold on;
plot(t*1e6, pulse2_out, 'g', 'LineWidth', 1.5);
xlabel('Time (\mus)'); ylabel('Amplitude');
legend('Pulse 1 (output)', 'Pulse 2 (output)');
title('Filtered Pulses After Band-Limited Channel');
grid on;
```

#### 🔍 **Why This Shape?**

The tails of the filtered pulses **overlap** in time — even though the original square pulses are clearly separated. This tail overlap causes **ISI**. The next bit's shape is now affected by the previous one.

---

## ✅ **Part 3: ISI-Free Pulse Shapes (Nyquist Criterion)**

---

### **Step 11: Nyquist Criterion Explanation**

A pulse shape satisfies **zero-ISI** if:

```math
p(nT) = 1  for n = 0
p(nT) = 0  for all other integers n ≠ 0
```

This is the **Nyquist first criterion**. It ensures sampled pulse values at bit centers are not affected by other pulses.

---

### **Step 12: Raised Cosine Pulse Example (Roll-off = 0.5)**

```matlab
span = 10;  % Number of symbols
sps = Fs / B;  % Samples per symbol
rolloff = 0.5;
rc_pulse = rcosdesign(rolloff, span, sps, 'normal');
rc_time = (-(length(rc_pulse)/2):(length(rc_pulse)/2 - 1)) / Fs;
```

---

### **Step 13: Pass Raised Cosine Through Same Channel**

```matlab
RC_F = fftshift(fft(rc_pulse, N));
RC_F_filt = RC_F .* H;
rc_out = ifft(ifftshift(RC_F_filt), 'symmetric');
```

---

### **Step 14: Plot Time Domain of Raised Cosine (Before & After)**

```matlab
figure;
plot(rc_time*1e6, rc_pulse, 'b', 'LineWidth', 1.5); hold on;
plot(t*1e6, rc_out, 'r', 'LineWidth', 1.5);
xlabel('Time (\mus)'); ylabel('Amplitude');
legend('Raised Cosine (original)', 'After Channel');
title('Raised Cosine Pulse - Time Domain');
grid on;
```

---

### **Step 15: Plot Frequency Domain of Raised Cosine (Before & After)**

```matlab
figure;
plot(f/1e3, abs(RC_F), 'b'); hold on;
plot(f/1e3, abs(RC_F_filt), 'r');
xlabel('Frequency (kHz)'); ylabel('|Amplitude|');
legend('RC Spectrum', 'Filtered RC Spectrum');
title('Raised Cosine Pulse - Frequency Domain');
grid on;
```

#### 🔍 **Why This Shape?**

The raised cosine pulse has **smooth transitions** and its spectrum is well-contained, so the band-limited channel affects it **less drastically**. After filtering, it **retains its ISI-free properties**, unlike the square pulse.

---

## ✅ (Optional) BER Simulation in AWGN (Advanced)

You may simulate **BER performance** of square pulse vs. raised cosine using `awgn()` and a matched filter setup. This helps demonstrate real-world benefit of ISI-free pulses in noisy environments.

---

## 🔚 Summary

| Task                                      | Observation                                                           |
| ----------------------------------------- | --------------------------------------------------------------------- |
| Square pulse through band-limited channel | Severe distortion, ringing, and time-spreading ⇒ causes ISI           |
| Two square pulses                         | Overlap occurs ⇒ clearly demonstrates Inter-Symbol Interference       |
| Raised Cosine pulse                       | Smoother, well-bounded spectrum ⇒ survives filtering with minimal ISI |

---



## part 2 :

## part 3 :
