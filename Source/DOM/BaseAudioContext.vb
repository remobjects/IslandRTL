'''<summary>The BaseAudioContext interface of the Web Audio API acts as a base definition for online and offline audio-processing graphs, as represented by AudioContext and OfflineAudioContext respectively.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [BaseAudioContext]
  '''<summary>Returns a double representing an ever-increasing hardware time in seconds used for scheduling. It starts at 0.</summary>
  ReadOnly Property [currentTime] As DateTime
  '''<summary>Returns an AudioDestinationNode representing the final destination of all audio in the context. It can be thought of as the audio-rendering device.</summary>
  ReadOnly Property [destination] As AudioDestinationNode
  '''<summary>Returns the AudioListener object, used for 3D spatialization.</summary>
  ReadOnly Property [listener] As AudioListener
  '''<summary>Returns a float representing the sample rate (in samples per second) used by all nodes in this context. The sample-rate of an AudioContext cannot be changed.</summary>
  ReadOnly Property [sampleRate] As Double
  '''<summary>Returns the current state of the AudioContext.</summary>
  ReadOnly Property [state] As String
  '''<summary>An event handler that runs when an event of type statechange has fired. This occurs when the AudioContext's state changes, due to the calling of one of the state change methods (AudioContext.suspend, AudioContext.resume, or AudioContext.close).</summary>
  Property [onstatechange] As EventListener
  '''<summary>Creates an AnalyserNode, which can be used to expose audio time and frequency data and for example to create data visualisations.</summary>
  Function [createAnalyser]() As AnalyserNode
  '''<summary>Creates a BiquadFilterNode, which represents a second order filter configurable as several different common filter types: high-pass, low-pass, band-pass, etc</summary>
  Function [createBiquadFilter]() As BiquadFilterNode
  '''<summary>Creates an AudioBufferSourceNode, which can be used to play and manipulate audio data contained within an AudioBuffer object. AudioBuffers are created using AudioContext.createBuffer or returned by AudioContext.decodeAudioData when it successfully decodes an audio track.</summary>
  Function [createBufferSource]() As AudioBufferSourceNode
  '''<summary>Creates a ConstantSourceNode object, which is an audio source that continuously outputs a monaural (one-channel) sound signal whose samples all have the same value.</summary>
  Function [createConstantSource]() As ConstantSourceNode
  '''<summary>Creates a ChannelMergerNode, which is used to combine channels from multiple audio streams into a single audio stream.</summary>
  Function [createChannelMerger]([parnumberOfInputs] As Dynamic) As ChannelMergerNode
  '''<summary>Creates a ChannelSplitterNode, which is used to access the individual channels of an audio stream and process them separately.</summary>
  Function [createChannelSplitter]([parnumberOfOutputs] As Dynamic) As ChannelSplitterNode
  '''<summary>Creates a ConvolverNode, which can be used to apply convolution effects to your audio graph, for example a reverberation effect.</summary>
  Function [createConvolver]() As ConvolverNode
  '''<summary>Creates a DelayNode, which is used to delay the incoming audio signal by a certain amount. This node is also useful to create feedback loops in a Web Audio API graph.</summary>
  Function [createDelay]([parmaxDelayTime] As Dynamic) As DelayNode
  '''<summary>Creates a DynamicsCompressorNode, which can be used to apply acoustic compression to an audio signal.</summary>
  Function [createDynamicsCompressor]() As DynamicsCompressorNode
  '''<summary>Creates a GainNode, which can be used to control the overall volume of the audio graph.</summary>
  Function [createGain]() As GainNode
  '''<summary>Creates an IIRFilterNode, which represents a second order filter configurable as several different common filter types.</summary>
  Function [createIIRFilter]([parfeedforward] As Dynamic, [parfeedback] As Dynamic) As IIRFilterNode
  '''<summary>Creates an OscillatorNode, a source representing a periodic waveform. It basically generates a tone.</summary>
  Function [createOscillator]() As OscillatorNode
  '''<summary>Creates a PannerNode, which is used to spatialise an incoming audio stream in 3D space.</summary>
  Function [createPanner]() As PannerNode
  '''<summary>Creates a PeriodicWave, used to define a periodic waveform that can be used to determine the output of an OscillatorNode.</summary>
  Function [createPeriodicWave]([parreal] As Dynamic, [parimag] As Dynamic) As PeriodicWave
  '''<summary>Creates a StereoPannerNode, which can be used to apply stereo panning to an audio source.</summary>
  Function [createStereoPanner]() As StereoPannerNode
  '''<summary>Creates a WaveShaperNode, which is used to implement non-linear distortion effects.</summary>
  Function [createWaveShaper]() As WaveShaperNode
  '''<summary>Asynchronously decodes audio file data contained in an ArrayBuffer. In this case, the ArrayBuffer is usually loaded from an XMLHttpRequest's response attribute after setting the responseType to arraybuffer. This method only works on complete files, not fragments of audio files.</summary>
  Function [decodeAudioData]([parArrayBuffer] As Dynamic, [parDecodeSuccessCallback] As Dynamic, [parDecodeErrorCallback] As Dynamic) As Byte()
End Interface