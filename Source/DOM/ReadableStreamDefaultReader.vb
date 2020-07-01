'''<Summary>The ReadableStreamDefaultReader interface of the Streams API represents a default reader that can be used to read stream data supplied from a network (e.g. a fetch request). </Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ReadableStreamDefaultReader]
  '''<Summary>Allows you to write code that responds to an end to the streaming process. Returns a promise that fulfills if the stream becomes closed or the reader's lock is released, or rejects if the stream errors.</Summary>
  ReadOnly Property [closed] As Dynamic
End Interface