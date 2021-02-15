'''<summary>The OfflineAudioContext interface is an AudioContext interface representing an audio-processing graph built from linked together AudioNodes. In contrast with a standard AudioContext, an OfflineAudioContext doesn't render the audio to the device hardware; instead, it generates it, as fast as it can, and outputs the result to an AudioBuffer.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [OfflineAudioContext]
Inherits BaseAudioContext

  '''<summary>An integer representing the size of the buffer in sample-frames.</summary>
  ReadOnly Property [length] As Integer
  '''<summary>Is an EventHandler called when processing is terminated, that is when the complete event (of type OfflineAudioCompletionEvent) is raised, after the event-based version of OfflineAudioContext.startRendering() is used.</summary>
  Property [oncomplete] As EventListener
  '''<summary>Schedules a suspension of the time progression in the audio context at the specified time and returns a promise.</summary>
  Function [suspend]([parsuspendTime] As Dynamic) As Dynamic
  '''<summary>Starts rendering the audio, taking into account the current connections and the current scheduled changes. This page covers both the event-based version and the promise-based version.</summary>
  Function [startRendering]() As Dynamic
  '''<summary>Resumes the progression of time in an audio context that has previously been suspended.</summary>
  Function [resume]() As Dynamic
End Interface