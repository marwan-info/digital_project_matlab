# digital_project_matlab

## part 1 :  Inter-Symbol Interference due to band-limited channels
the output or part1 : 

![Screenshot (9)](https://github.com/user-attachments/assets/742b37de-e25c-498c-9a1d-c0c1da439448)
![Screenshot (8)](https://github.com/user-attachments/assets/003210e3-f54d-4c40-92da-b2bd5743c698)
![Screenshot (7)](https://github.com/user-attachments/assets/21e4e743-64ec-44e7-944f-48e851fb8b7e)
![Screenshot (6)](https://github.com/user-attachments/assets/8964bf58-f1bf-423f-804f-76dd950b69e0)
![Screenshot (5)](https://github.com/user-attachments/assets/b07c0170-21a3-4441-bd9e-ebc39286f496)

### steps : 

## ✅ **Part 1: Effect of a Band-Limited Channel on a Single Square Pulse**
**Step 1: Define Parameters**
**Step 2: Generate a Square Pulse of Duration T = 2/B**
**Step 3: Create Band-Limited Channel (Ideal Low-Pass Filter)**
**Step 4: Apply Filter in Frequency Domain**
 **Step 5: Plot Time Domain (Before and After)**
#### 🔍 **Why This Shape?**
---
After filtering, the square pulse becomes **smeared out** — no longer sharp edges. This is due to the loss of high-frequency components. The result is a **sinc-like ringing** (Gibbs phenomenon), which **extends beyond the original duration T**. This is the beginning of **Inter-Symbol Interference (ISI)**.
---
### **Step 6: Plot Frequency Domain (Before and After)**
#### 🔍 **Why This Shape?**
* The original square pulse has infinite frequency content (sinc spectrum).
* The filtered signal has components **truncated at ±50 kHz**, causing time-domain ringing.
---
## ✅ **Part 2: Two Consecutive Square Pulses and ISI Visualization**
---
### **Step 7: Create First and Second Pulses at Different Time Offsets**
### **Step 8: Filter Each Pulse Separately**
---
### **Step 9: Plot Time Domain Before Filtering (Both Pulses)**
---
### **Step 10: Plot Time Domain After Filtering (Both Pulses)**
#### 🔍 **Why This Shape?**
The tails of the filtered pulses **overlap** in time — even though the original square pulses are clearly separated. This tail overlap causes **ISI**. The next bit's shape is now affected by the previous one.
---
## ✅ **Part 3: ISI-Free Pulse Shapes (Nyquist Criterion)**
---
### **Step 11: Nyquist Criterion Explanation**
A pulse shape satisfies **zero-ISI** if:
This is the **Nyquist first criterion**. It ensures sampled pulse values at bit centers are not affected by other pulses.
---
### **Step 12: Raised Cosine Pulse Example (Roll-off = 0.5)**
---
### **Step 13: Pass Raised Cosine Through Same Channel**
---
### **Step 14: Plot Time Domain of Raised Cosine (Before & After)**
---
### **Step 15: Plot Frequency Domain of Raised Cosine (Before & After)**
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
