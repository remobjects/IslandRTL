'''<summary>The ReadableStreamDefaultReader interface of the Streams API represents a default reader that can be used to read stream data supplied from a network (e.g. a fetch request). </summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ReadableStreamDefaultReader]
  '''<summary>Allows you to write code that responds to an end to the streaming process. Returns a promise that fulfills if the stream becomes closed or the reader's lock is released, or rejects if the stream errors.</summary>
  ReadOnly Property [closed] As Dynamic
  '''<summary>Cancels the stream, signaling a loss of interest in the stream by a consumer. The supplied reason argument will be given to the underlying source, which may or may not use it.</summary>
  Function [cancel]([parreason] As Dynamic) As Dynamic
  '''<summary>Returns a promise providing access to the next chunk in the stream's internal queue.</summary>
  Function [read]() As Dynamic
  '''<summary>Releases the reader's lock on the stream.</summary>
  Function [releaseLock]() As Dynamic
End Interface