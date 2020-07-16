'''<Summary>The ReadableStreamDefaultController interface of the Streams API represents a controller allowing control of a ReadableStream's state and internal queue. Default controllers are for streams that are not byte streams. </Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ReadableStreamDefaultController]
  '''<Summary>Returns the desired size required to fill the stream's internal queue.</Summary>
  ReadOnly Property [desiredSize] As Integer
  '''<Summary>Closes the associated stream.</Summary>
  Sub [close]()
  '''<Summary>Enqueues a given chunk in the associated stream.</Summary>
  Sub [enqueue]([parchunk] As Dynamic)
  '''<Summary>Causes any future interactions with the associated stream to error.</Summary>
  Sub [error]([pare] As Dynamic)
End Interface