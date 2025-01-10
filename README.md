# Digital Communication In IC Design

## Homework 1
### Overview
This assignment focuses on QPSK, OFDM, and OTFS techniques.   
Key tasks include waveform generation, spectral analysis, and modulation simulation.

### Tasks
1. Generate 16 binary bits as a seed.
2. QPSK Modulation:
   - Plot O-QPSK and π/4-QPSK waveforms.
   - Compare their spectra.
3. OFDM Signals:
   - Generate 8 subcarriers and sum their waveforms.
   - Apply IFFT and compare results.
4. OTFS Signals:
   - Generate time-domain signals using ISFFT/IFFT.
   - Compare delay-Doppler domain methods.

## Homework 2
### Overview
This assignment explores Zadoff-Chu sequences, Walsh Hadamard codes, and Linear Feedback Shift Registers (LFSR) for communication systems.   
Key tasks include autocorrelation, cross-correlation, code spreading, and maximum length sequence generation.

### Tasks
1. **Zadoff-Chu Sequences**:
   - Generate sequences and examine autocorrelation and cross-correlation.
   - Map sequences to LTE subcarriers and analyze their properties.
2. **Walsh Hadamard Codes**:
   - Generate Walsh matrix and analyze cross-correlation.
   - Simulate data spreading and dispreading with synchronization.
3. **LFSR and ML Sequences**:
   - Implement LFSR for given polynomials.
   - Generate ML sequences and analyze autocorrelation properties.
---

## Homework 3
### Overview
This assignment focuses on multipath fading, IQ imbalance, and OFDM system design.   
The tasks include analyzing delay profiles, simulating OFDM signals, and examining channel effects.

### Tasks
1. **Channel Delay Profile**:
   - Compute power ratios, mean delay, and RMS delay.
2. **Multipath Fading Channel**:
   - Simulate fading channel and derive frequency response.
   - Plot magnitude and phase.
3. **IQ Imbalance**:
   - Analyze demodulated signals under imbalance.
4. **OFDM System Design**:
   - Simulate BPSK-modulated OFDM with cyclic prefix.
   - Analyze received signals and compare frequency responses.

## Homework 4  
### Overview:
- **MIMO Systems**: Modeling MIMO communication with a channel matrix, beamforming with antenna arrays, and interference management.
- **QPSK Costas Loop**: Analyzing phase error in a QPSK receiver and computing error signals after phase detection.
- **Detection Techniques**:
  - **Zero-Forcing (ZF) Detection**: Applied to 16-QAM signal in MIMO systems to detect transmitted data.
  - **Beamforming and Phase Shift**: Studying the beamforming effect with the phase shift at the receiver side and optimizing it based on antenna angle.
  - **Phase Error Estimation**: Calculating the phase error and explaining phase ambiguity in a decision-directed Costas loop.
### Tasks:
1. **Beamforming Analysis**: Analyze the beamforming response with phase shifts and evaluate the beam pattern associated with specific receiver angles.
2. **QPSK Detection**: Use a QPSK Costas loop to detect phase errors and estimate the phase offset in received signals.
3. **ZF Detection**: Apply the ZF detection matrix to the MIMO system for QPSK detection.
4. **Phase Error Calculation**: Calculate error signals after QPSK detection and visualize phase ambiguity in the system.
   
## Homework 5  
### Overview:
- **Carrier Frequency Offset (CFO) Estimation**: Study of CFO in OFDM systems, its impact, and methods for estimating CFO using cross-correlation.
- **GSM Midamble Autocorrelation**: Examining the autocorrelation of a GSM midamble sequence to assess channel properties.
- **Channel Estimation**: Estimating the channel impulse response in GSM systems using correlation techniques.
- **OFDM Signal Processing**: Applying FFT to OFDM signals, processing cyclic prefix, and estimating channel frequency responses for OFDM transmission.

### Tasks:
1. **Carrier Frequency Offset Estimation**: Using cross-correlation methods to estimate CFO in a simulated OFDM system.
2. **Autocorrelation of GSM Midamble**: Calculating and plotting the autocorrelation of the GSM midamble sequence.
3. **Channel Estimation in GSM**: Perform channel estimation using the received GSM signals, calculate impulse response, and estimate the maximum range for interference-free estimation.
4. **OFDM Signal Analysis**: Perform FFT on OFDM signals, calculate channel frequency response, and evaluate the effects of CFO on signal accuracy.
   
## Homework 6  
### Overview:
- **MIMO Detection**: Investigating different MIMO detection algorithms, such as ZF and OSIC, to improve signal detection in a 16-QAM MIMO system.
- **BER vs SNR Curve**: Generating and analyzing the BER curve as a function of SNR to evaluate system performance.
- **OSIC Detection**: Understanding the principles of OSIC and using it to cancel interference and enhance detection accuracy.
- **Exhaustive Search for Signal Detection**: Using an exhaustive search method to find the optimal detection strategy in a 3x3 MIMO system.

### Tasks:
1. **ZF Detection**: Apply Zero-Forcing detection to a MIMO system and compute the detection output. Compare it with noise-free signals and noisy signals.
2. **BER vs SNR Curve**: Simulate a MIMO system and generate the BER vs SNR curve for performance analysis.
3. **OSIC Detection**: Apply OSIC to the MIMO system to detect transmitted symbols, iterating over interference removal.
4. **Exhaustive Search for MIMO Detection**: Implement an exhaustive search for the MIMO signal detection problem and analyze the results.
   
## Final Project  
Please check out https://github.com/shihjimmy/MIMO_BFS_Sphere_Decoder  

