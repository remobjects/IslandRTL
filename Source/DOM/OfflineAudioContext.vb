'''<Summary>The OfflineAudioContext interface is an AudioContext interface representing an audio-processing graph built from linked together AudioNodes. In contrast with a standard AudioContext, an OfflineAudioContext doesn't render the audio to the device hardware; instead, it generates it, as fast as it can, and outputs the result to an AudioBuffer.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [OfflineAudioContext]
Inherits BaseAudioContext

  '''<Summary>An integer representing the size of the buffer in sample-frames.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Is an EventHandler called when processing is terminated, that is when the complete event (of type OfflineAudioCompletionEvent) is raised, after the event-based version of OfflineAudioContext.startRendering() is used.</Summary>
  Property [oncomplete] As EventListener
End Interface