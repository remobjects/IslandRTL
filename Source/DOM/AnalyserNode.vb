'''<summary>The AnalyserNode interface represents a node able to provide real-time frequency and time-domain analysis information. It is an AudioNode that passes the audio stream unchanged from the input to the output, but allows you to take the generated data, process it, and create audio visualizations.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AnalyserNode]
Inherits AudioNode

  '''<summary>Is an unsigned long value representing the size of the FFT (Fast Fourier Transform) to be used to determine the frequency domain.</summary>
  Property [fftSize] As ULong
  '''<summary>Is an unsigned long value half that of the FFT size. This generally equates to the number of data values you will have to play with for the visualization.</summary>
  ReadOnly Property [frequencyBinCount] As Dynamic
  '''<summary>Is a double value representing the minimum power value in the scaling range for the FFT analysis data, for conversion to unsigned byte values — basically, this specifies the minimum value for the range of results when using getByteFrequencyData().</summary>
  Property [minDecibels] As Double
  '''<summary>Is a double value representing the maximum power value in the scaling range for the FFT analysis data, for conversion to unsigned byte values — basically, this specifies the maximum value for the range of results when using getByteFrequencyData().</summary>
  Property [maxDecibels] As Double
  '''<summary>Is a double value representing the averaging constant with the last analysis frame — basically, it makes the transition between values over time smoother.</summary>
  Property [smoothingTimeConstant] As Double
  '''<summary>Copies the current frequency data into a Float32Array array passed into it.</summary>
  Function [getFloatFrequencyData]([pararray] As Dynamic) As Double
  '''<summary>Copies the current frequency data into a Uint8Array (unsigned byte array) passed into it.</summary>
  Sub [getByteFrequencyData]([pararray] As Dynamic)
  '''<summary>Copies the current waveform, or time-domain, data into a Float32Array array passed into it.</summary>
  Function [getFloatTimeDomainData]([pararray] As Dynamic) As Double
  '''<summary>Copies the current waveform, or time-domain, data into a Uint8Array (unsigned byte array) passed into it.</summary>
  Sub [getByteTimeDomainData]([pararray] As Dynamic)
End Interface