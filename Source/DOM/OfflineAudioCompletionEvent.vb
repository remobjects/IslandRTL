'''<Summary>The Web Audio API OfflineAudioCompletionEvent interface represents events that occur when the processing of an OfflineAudioContext is terminated. The complete event implements this interface.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [OfflineAudioCompletionEvent]
Inherits [Event]

  '''<Summary>An AudioBuffer containing the result of processing an OfflineAudioContext.</Summary>
  ReadOnly Property [renderedBuffer] As AudioBuffer
End Interface