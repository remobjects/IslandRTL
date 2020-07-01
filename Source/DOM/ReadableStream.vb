'''<Summary>The ReadableStream interface of the Streams API represents a readable stream of byte data. The Fetch API offers a concrete instance of a ReadableStream through the body property of a Response object.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ReadableStream]
  '''<Summary>The locked getter returns whether or not the readable stream is locked to a reader.</Summary>
  ReadOnly Property [locked] As Dynamic
End Interface