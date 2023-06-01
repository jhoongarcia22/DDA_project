# Audio Effects Implemented on Zybo Zynq-7000

Within this project, different audio effects have been implemented by utilizing the Cordic Rotation and Circular Buffer blocks present in the `entrega1` and `entrega2` directories. These effects are showcased and described below.

- `Echo Effect`: Simulates an echo by storing previous audio samples in a circular buffer and mixing them with the current sample.
- `Cordic Effect`: Performs frequency shifting of incoming data using the Cordic Rotation algorithm.
- `Chorus Effect`: Creates a chorus effect by combining multiple delayed copies of the input signal.
- `Both Effect (Echo and Cordic)`: Combines the echo and cordic effects.
- `Both Effect (Cordic and Chorus)`: Combines the cordic and chorus effects.
    
