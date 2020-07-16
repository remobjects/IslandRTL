'''<Summary>The BaseAudioContext interface of the Web Audio API acts as a base definition for online and offline audio-processing graphs, as represented by AudioContext and OfflineAudioContext respectively.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [BaseAudioContext]
  '''<Summary>Returns a double representing an ever-increasing hardware time in seconds used for scheduling. It starts at 0.</Summary>
  ReadOnly Property [currentTime] As Date
  '''<Summary>Returns an AudioDestinationNode representing the final destination of all audio in the context. It can be thought of as the audio-rendering device.</Summary>
  ReadOnly Property [destination] As AudioDestinationNode
  '''<Summary>Returns the AudioListener object, used for 3D spatialization.</Summary>
  ReadOnly Property [listener] As AudioListener
  '''<Summary>Returns a float representing the sample rate (in samples per second) used by all nodes in this context. The sample-rate of an AudioContext cannot be changed.</Summary>
  ReadOnly Property [sampleRate] As Double
  '''<Summary>Returns the current state of the AudioContext.</Summary>
  ReadOnly Property [state] As String
  '''<Summary>An event handler that runs when an event of type statechange has fired. This occurs when the AudioContext's state changes, due to the calling of one of the state change methods (AudioContext.suspend, AudioContext.resume, or AudioContext.close).</Summary>
  Property [onstatechange] As EventListener
  '''<Summary>Creates an AnalyserNode, which can be used to expose audio time and frequency data and for example to create data visualisations.</Summary>
  Function [createAnalyser]() As AnalyserNode
  '''<Summary>Creates a BiquadFilterNode, which represents a second order filter configurable as several different common filter types: high-pass, low-pass, band-pass, etc</Summary>
  Function [createBiquadFilter]() As BiquadFilterNode
  '''<Summary>Creates an AudioBufferSourceNode, which can be used to play and manipulate audio data contained within an AudioBuffer object. AudioBuffers are created using AudioContext.createBuffer or returned by AudioContext.decodeAudioData when it successfully decodes an audio track.</Summary>
  Function [createBufferSource]() As AudioBufferSourceNode
  '''<Summary>Creates a ConstantSourceNode object, which is an audio source that continuously outputs a monaural (one-channel) sound signal whose samples all have the same value.</Summary>
  Function [createConstantSource]() As ConstantSourceNode
  '''<Summary>Creates a ChannelMergerNode, which is used to combine channels from multiple audio streams into a single audio stream.</Summary>
  Function [createChannelMerger]([parnumberOfInputs] As Dynamic) As ChannelMergerNode
  '''<Summary>Creates a ChannelSplitterNode, which is used to access the individual channels of an audio stream and process them separately.</Summary>
  Function [createChannelSplitter]([parnumberOfOutputs] As Dynamic) As ChannelSplitterNode
  '''<Summary>Creates a ConvolverNode, which can be used to apply convolution effects to your audio graph, for example a reverberation effect.</Summary>
  Function [createConvolver]() As ConvolverNode
  '''<Summary>Creates a DelayNode, which is used to delay the incoming audio signal by a certain amount. This node is also useful to create feedback loops in a Web Audio API graph.</Summary>
  Function [createDelay]([parmaxDelayTime] As Dynamic) As DelayNode
  '''<Summary>Creates a DynamicsCompressorNode, which can be used to apply acoustic compression to an audio signal.</Summary>
  Function [createDynamicsCompressor]() As DynamicsCompressorNode
  '''<Summary>Creates a GainNode, which can be used to control the overall volume of the audio graph.</Summary>
  Function [createGain]() As GainNode
  '''<Summary>Creates an IIRFilterNode, which represents a second order filter configurable as several different common filter types.</Summary>
  Function [createIIRFilter]([parfeedforward] As Dynamic, [parfeedback] As Dynamic) As IIRFilterNode
  '''<Summary>Creates an OscillatorNode, a source representing a periodic waveform. It basically generates a tone.</Summary>
  Function [createOscillator]() As OscillatorNode
  '''<Summary>Creates a PannerNode, which is used to spatialise an incoming audio stream in 3D space.</Summary>
  Function [createPanner]() As PannerNode
  '''<Summary>Creates a PeriodicWave, used to define a periodic waveform that can be used to determine the output of an OscillatorNode.</Summary>
  Function [createPeriodicWave]([parreal] As Dynamic, [parimag] As Dynamic) As PeriodicWave
  '''<Summary>Creates a StereoPannerNode, which can be used to apply stereo panning to an audio source.</Summary>
  Function [createStereoPanner]() As StereoPannerNode
  '''<Summary>Creates a WaveShaperNode, which is used to implement non-linear distortion effects.</Summary>
  Function [createWaveShaper]() As WaveShaperNode
  '''<Summary>Asynchronously decodes audio file data contained in an ArrayBuffer. In this case, the ArrayBuffer is usually loaded from an XMLHttpRequest's response attribute after setting the responseType to arraybuffer. This method only works on complete files, not fragments of audio files.</Summary>
  Function [decodeAudioData]([parArrayBuffer] As Dynamic, [parDecodeSuccessCallback] As Dynamic, [parDecodeErrorCallback] As Dynamic) As Byte()
End Interface