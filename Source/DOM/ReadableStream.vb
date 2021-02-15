'''<summary>The ReadableStream interface of the Streams API represents a readable stream of byte data. The Fetch API offers a concrete instance of a ReadableStream through the body property of a Response object.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [ReadableStream]
  '''<summary>The locked getter returns whether or not the readable stream is locked to a reader.</summary>
  ReadOnly Property [locked] As Dynamic
  '''<summary>Cancels the stream, signaling a loss of interest in the stream by a consumer. The supplied reason argument will be given to the underlying source, which may or may not use it.</summary>
  Function [cancel]([parreason] As Dynamic) As Dynamic
  '''<summary>Creates a ReadableStream async iterator instance and locks the stream to it. While the stream is locked, no other reader can be acquired until this one is released.</summary>
  Function [getIterator]() As ReadableStream
  '''<summary>Creates a reader and locks the stream to it. While the stream is locked, no other reader can be acquired until this one is released.</summary>
  Function [getReader]([parmode] As Dynamic) As Dynamic
  '''<summary>The tee method tees this readable stream, returning a two-element array containing the two resulting branches as new ReadableStream instances. Each of those streams receives the same incoming data.</summary>
  Function [tee]() As Dynamic
  '''<summary>Alias of getIterator method.</summary>
  Function [ReadableStream]() As Dynamic
End Interface