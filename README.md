# Digital Signal Distortion Using Eye Diagram

A MATLAB simulation demonstrating digital signal distortion analysis and visualization using eye diagrams for a B.Tech ENTC (Electronics and Telecommunication) Digital Communication project.

## Overview

This project simulates the effects of noise (AWGN - Additive White Gaussian Noise) and intersymbol interference (ISI) on digital signals in communication systems. It visualizes signal degradation through time-domain analysis and eye diagram representations, which are essential tools in digital communication for assessing signal quality.

## Features

- **Flexible Input Options**: Generate random binary data or manually enter bit sequences
- **Configurable Channel Impairments**: 
  - AWGN (Additive White Gaussian Noise) with adjustable SNR
  - ISI (Intersymbol Interference) with variable strength
- **Four Signal Representations**:
  - Ideal signal (clean, undistorted)
  - Signal with AWGN only
  - Signal with ISI only
  - Signal with combined AWGN and ISI
- **Time-Domain Visualization**: Plots comparing all four signal variants
- **Eye Diagram Analysis**: Visual representation of signal quality metrics
- **Quantitative Measurements**:
  - Eye Height (vertical opening at sampling point)
  - Eye Width (horizontal opening at 90% of maximum)

## How to Use

### Running the Program

1. Open MATLAB and navigate to the project directory
2. Run the program:
   ```matlab
   program
   ```

### Input Parameters

When prompted, provide the following inputs:

1. **Input Data Selection**:
   - Option 1: Generate random binary data (requires number of bits)
   - Option 2: Enter binary sequence manually (e.g., `[1 1 0 0 1 0]`)

2. **AWGN SNR**: Signal-to-Noise Ratio in dB (e.g., 10 dB)

3. **ISI Strength**: Intersymbol Interference as percentage (0-100%)

### Example Usage

```
Select Input Data:
1. Random Binary Data
2. Enter Binary Data Manually
Enter your choice (1 or 2): 1

Enter number of bits (minimum 6): 20
Enter AWGN SNR in dB (example: 10): 15
Enter ISI strength in % (example: 30): 25
```

## Simulation Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| Bit Duration (Tb) | 1 ms | Time for one bit transmission |
| Bit Rate (Rb) | 1 kbps | 1000 bits per second |
| Samples per Symbol | 5 | Samples per bit (5x oversampling) |
| Sampling Frequency (Fs) | 5 kHz | Sampling rate |
| ISI Delay | 2 samples | Delay for ISI component |
| Eye Traces | 5 | Number of overlaid symbol periods |

## Signal Processing Steps

1. **Polar NRZ Mapping**: Convert binary data to symbols (0 → -1, 1 → +1)
2. **Baseband Signal**: Upsample symbols using rectangular pulse shaping
3. **AWGN Application**: Add Gaussian noise at specified SNR level
4. **ISI Channel**: Apply channel impulse response with controlled ISI
5. **Combined Distortion**: Add both AWGN and ISI together
6. **Eye Diagram Generation**: Extract multiple symbol periods and overlay them

## Output

The program generates two MATLAB figures:

### Figure 1: Digital Signal Comparison
Time-domain plots showing:
- Ideal signal (undistorted)
- Signal with AWGN
- Signal with ISI
- Signal with combined AWGN and ISI

### Figure 2: Eye Diagram Analysis
Four 2×2 subplots displaying eye diagrams with:
- 5 superimposed symbol traces
- Eye height markers (vertical dashed line)
- Sampling point indicator
- Eye height and width measurements in the title

## Understanding Eye Diagrams

**Eye Height**: 
- Measures the vertical opening at the sampling point
- Higher eye height indicates better signal quality
- Determines noise margin and bit error rate (BER)

**Eye Width**: 
- Measures the horizontal opening at 90% of maximum amplitude
- Indicates timing margin available for clock recovery
- Narrower eye width means more timing-sensitive systems

## Key Findings

- **Ideal Signal**: Maximum eye opening (height = 2.0, width = 1.0 Tb)
- **AWGN Only**: Vertical eye closure due to noise
- **ISI Only**: Horizontal eye closure and amplitude reduction
- **AWGN + ISI**: Combined effects reduce both eye height and width

## Technical Details

### Modulation Scheme
- **Polar NRZ (Non-Return-to-Zero)**: Standard baseband signaling
  - 0 → -1 volt
  - 1 → +1 volt

### Channel Model
ISI channel impulse response:
```
h(n) = (1-α)δ(n) + α·δ(n-2)
```
where α is the ISI strength (0 to 1)

### AWGN Model
Gaussian noise with power determined by the specified SNR

## Requirements

- MATLAB R2018a or later
- Signal Processing Toolbox (for `awgn` function)

## Educational Applications

This project is useful for:
- Understanding digital communication fundamentals
- Analyzing effects of channel impairments
- Visualizing signal quality metrics
- Learning eye diagram interpretation
- Studying baseband communication systems

## References

- Digital Communications textbooks covering eye diagrams
- MATLAB Signal Processing documentation
- Baseband signaling and ISI fundamentals

## License

This is an educational project for B.Tech ENTC students.

## Author

B.Tech ENTC - Digital Communication Macro-Project

---

**Note**: Adjust simulation parameters in Section 2 of the code to experiment with different configurations and observe their effects on signal quality and eye diagrams.
