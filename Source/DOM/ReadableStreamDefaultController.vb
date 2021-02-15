'''<summary>The ReadableStreamDefaultController interface of the Streams API represents a controller allowing control of a ReadableStream's state and internal queue. Default controllers are for streams that are not byte streams. </summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ReadableStreamDefaultController]
  '''<summary>Returns the desired size required to fill the stream's internal queue.</summary>
  ReadOnly Property [desiredSize] As Integer
  '''<summary>Closes the associated stream.</summary>
  Sub [close]()
  '''<summary>Enqueues a given chunk in the associated stream.</summary>
  Sub [enqueue]([parchunk] As Dynamic)
  '''<summary>Causes any future interactions with the associated stream to error.</summary>
  Sub [error]([pare] As Dynamic)
End Interface