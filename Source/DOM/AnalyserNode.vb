'''<Summary>The AnalyserNode interface represents a node able to provide real-time frequency and time-domain analysis information. It is an AudioNode that passes the audio stream unchanged from the input to the output, but allows you to take the generated data, process it, and create audio visualizations.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AnalyserNode]
'Defined on this type 
  '''<Summary>Is an unsigned long value representing the size of the FFT (Fast Fourier Transform) to be used to determine the frequency domain.</Summary>
  Property [fftSize] As ULong
  '''<Summary>Is an unsigned long value half that of the FFT size. This generally equates to the number of data values you will have to play with for the visualization.</Summary>
  ReadOnly Property [frequencyBinCount] As Dynamic
  '''<Summary>Is a double value representing the minimum power value in the scaling range for the FFT analysis data, for conversion to unsigned byte values — basically, this specifies the minimum value for the range of results when using getByteFrequencyData().</Summary>
  Property [minDecibels] As Double
  '''<Summary>Is a double value representing the maximum power value in the scaling range for the FFT analysis data, for conversion to unsigned byte values — basically, this specifies the maximum value for the range of results when using getByteFrequencyData().</Summary>
  Property [maxDecibels] As Double
  '''<Summary>Is a double value representing the averaging constant with the last analysis frame — basically, it makes the transition between values over time smoother.</Summary>
  Property [smoothingTimeConstant] As Double
  '''<Summary>Creates a new instance of an AnalyserNode object.</Summary>
  Function [AnalyserNode]() As AnalyserNode
  '''<Summary>Copies the current frequency data into a Float32Array array passed into it.</Summary>
  Function [getFloatFrequencyData]([pararray] As Dynamic) As Double
  '''<Summary>Copies the current frequency data into a Uint8Array (unsigned byte array) passed into it.</Summary>
  Sub [getByteFrequencyData]([pararray] As Dynamic)
  '''<Summary>Copies the current waveform, or time-domain, data into a Float32Array array passed into it.</Summary>
  Function [getFloatTimeDomainData]([pararray] As Dynamic) As Double
  '''<Summary>Copies the current waveform, or time-domain, data into a Uint8Array (unsigned byte array) passed into it.</Summary>
  Sub [getByteTimeDomainData]([pararray] As Dynamic)
End Interface