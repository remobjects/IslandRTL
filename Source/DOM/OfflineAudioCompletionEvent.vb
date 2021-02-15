'''<summary>The Web Audio API OfflineAudioCompletionEvent interface represents events that occur when the processing of an OfflineAudioContext is terminated. The complete event implements this interface.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [OfflineAudioCompletionEvent]
Inherits [Event]

  '''<summary>An AudioBuffer containing the result of processing an OfflineAudioContext.</summary>
  ReadOnly Property [renderedBuffer] As AudioBuffer
End Interface