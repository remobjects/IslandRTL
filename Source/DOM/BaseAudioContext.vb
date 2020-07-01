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
End Interface