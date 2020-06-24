'''<Summary>The AudioBuffer interface represents a short audio asset residing in memory, created from an audio file using the AudioContext.decodeAudioData() method, or from raw data using AudioContext.createBuffer(). Once put into an AudioBuffer, the audio can then be played by being passed into an AudioBufferSourceNode.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioBuffer]
'Defined on this type 
  '''<Summary>Returns a float representing the sample rate, in samples per second, of the PCM data stored in the buffer.</Summary>
  ReadOnly Property [sampleRate] As Double
  '''<Summary>Returns an integer representing the length, in sample-frames, of the PCM data stored in the buffer.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Returns a double representing the duration, in seconds, of the PCM data stored in the buffer.</Summary>
  ReadOnly Property [duration] As Double
  '''<Summary>Returns an integer representing the number of discrete audio channels described by the PCM data stored in the buffer.</Summary>
  ReadOnly Property [numberOfChannels] As Integer
  '''<Summary>Returns a Float32Array containing the PCM data associated with the channel, defined by the channel parameter (with 0 representing the first channel).</Summary>
  Function [getChannelData]([parchannel] As Dynamic) As Double
  '''<Summary>Copies the samples from the specified channel of the AudioBuffer to the destination array.</Summary>
  Sub [copyFromChannel]([pardestination] As Dynamic, [parchannelNumber] As Dynamic, [parstartInChannel] As Dynamic)
End Interface