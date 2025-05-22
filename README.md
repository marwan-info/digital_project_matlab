# digital_project_matlab

## part 1 :  Inter-Symbol Interference due to band-limited channels
the output or part1 : 

<!-- ![image](https://github.com/user-attachments/assets/17a0ef5b-4f56-4401-95f2-31f361aa8ac9) -->
![image](https://github.com/user-attachments/assets/86437740-2e7c-4c08-ac9c-8f3554f4e09b)
![image](https://github.com/user-attachments/assets/21f0cfb0-5a0b-4044-9e27-7be0253ba14c)
![image](https://github.com/user-attachments/assets/5622f0de-4e5b-4b9c-92c5-a1e3305b0c44)
![image](https://github.com/user-attachments/assets/cf7bbd29-8bae-4e7f-9ec3-48b8ddc8f30e)
![1221](https://github.com/user-attachments/assets/dff69bf4-4400-443d-b412-863a8c1e1c8d)


### to overcome the isi we can use delta function delta with filter take shap of filter we can make filter square pulse so we are sure we see at receiver square pulse and negative square pulse in case of negative delta .
### or we can use functions which shap in frequncy domain is square pulse like this 

![image](https://github.com/user-attachments/assets/0ac2bacd-6662-4fa6-901c-e0e08628be59)
### after passing 3 upper shaps to filter notice that the 3 graphs between [ -100khz , 100khz ]
![image](https://github.com/user-attachments/assets/dff4ecf9-8e79-4fe1-a829-7b8e89515e81)
## overlap happen but very small because we assume the filter is sharp edge filter not practical 

## BER Simulation for Different Pulse Shapes in AWGN using BPSK 
```
ones(1, samples_per_symbol);                               % Rectangular
rcosdesign(1.0, span, samples_per_symbol, 'normal');        % Raised Cosine, roll-off = 1.0
rcosdesign(0.35, span, samples_per_symbol, 'sqrt');         % Root Raised Cosine, roll-off = 0.35
gaussdesign(0.3, span, samples_per_symbol)                  % Gaussian, BT = 0.3
```
### diffrente shaps of filters : 
![image](https://github.com/user-attachments/assets/278bf343-fed7-4ecd-b012-908ab1fa2260)

### ones : simple rectangular pulse , Causes high ISI if symbols are close together , Not bandwidth-efficient; leads to significant spectral spreading , many side lobes
### Normal Raised Cosine  : roll-off = 1.0 High roll-off factor → wider bandwidth but smoother transitions , Used to minimize ISI while controlling bandwidth , Good balance between time-domain smoothness and frequency-domain compactness
### rcosdesign(0.35, span, samples_per_symbol, 'sqrt') — Root Raised Cosine (RRC) : roll-off = 0.35: Good trade-off → compact spectrum + reduced ISI , Common in systems like LTE, QAM 
### gaussdesign(0.3, span, samples_per_symbol) — Gaussian Pulse : Controlled by BT (Bandwidth-Time product) , BT = 0.3: Bandwidth-efficient, but more pulse spreading , Smoothest pulse; no sharp edges. , Used in GMSK, GFSK (e.g., GSM, Bluetooth).
![image](https://github.com/user-attachments/assets/dabe022e-da77-4887-b319-a0c8e33a8c1f)


---
