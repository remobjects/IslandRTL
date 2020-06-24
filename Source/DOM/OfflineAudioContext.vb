'''<Summary>The OfflineAudioContext interface is an AudioContext interface representing an audio-processing graph built from linked together AudioNodes. In contrast with a standard AudioContext, an OfflineAudioContext doesn't render the audio to the device hardware; instead, it generates it, as fast as it can, and outputs the result to an AudioBuffer.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [OfflineAudioContext]
'Defined on this type 
  '''<Summary>An integer representing the size of the buffer in sample-frames.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Is an EventHandler called when processing is terminated, that is when the complete event (of type OfflineAudioCompletionEvent) is raised, after the event-based version of OfflineAudioContext.startRendering() is used.</Summary>
  Property [oncomplete] As EventListener
  '''<Summary>Schedules a suspension of the time progression in the audio context at the specified time and returns a promise.</Summary>
  Function [suspend]([parsuspendTime] As Dynamic) As Dynamic
  '''<Summary>Starts rendering the audio, taking into account the current connections and the current scheduled changes. This page covers both the event-based version and the promise-based version.</Summary>
  Function [startRendering]() As Dynamic
  '''<Summary>Resumes the progression of time in an audio context that has previously been suspended.</Summary>
  Function [resume]() As Dynamic
End Interface