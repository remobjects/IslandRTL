'''<Summary>The ReadableStream interface of the Streams API represents a readable stream of byte data. The Fetch API offers a concrete instance of a ReadableStream through the body property of a Response object.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ReadableStream]
'Defined on this type 
  '''<Summary>The locked getter returns whether or not the readable stream is locked to a reader.</Summary>
  ReadOnly Property [locked] As Dynamic
  '''<Summary>Creates and returns a readable stream object from the given handlers.</Summary>
  Function [ReadableStream]() As ReadableStream
  '''<Summary>Cancels the stream, signaling a loss of interest in the stream by a consumer. The supplied reason argument will be given to the underlying source, which may or may not use it.</Summary>
  Function [cancel]([parreason] As Dynamic) As Dynamic
  '''<Summary>Creates a ReadableStream async iterator instance and locks the stream to it. While the stream is locked, no other reader can be acquired until this one is released.</Summary>
  Function [getIterator]() As ReadableStream
  '''<Summary>Creates a reader and locks the stream to it. While the stream is locked, no other reader can be acquired until this one is released.</Summary>
  Function [getReader]([parmode] As Dynamic) As Dynamic
  '''<Summary>The tee method tees this readable stream, returning a two-element array containing the two resulting branches as new ReadableStream instances. Each of those streams receives the same incoming data.</Summary>
  Function [tee]() As Dynamic
End Interface