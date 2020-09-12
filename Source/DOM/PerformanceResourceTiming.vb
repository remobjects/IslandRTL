'''<Summary>The PerformanceResourceTiming interface enables retrieval and analysis of detailed network timing data regarding the loading of an application's resources. An application can use the timing metrics to determine, for example, the length of time it takes to fetch a specific resource, such as an XMLHttpRequest, &lt;SVG>, image, or script.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PerformanceResourceTiming]
  '''<Summary>A string representing the type of resource that initiated the performance entry, as specified in PerformanceResourceTiming.initiatorType.</Summary>
  ReadOnly Property [initiatorType] As Dynamic
  '''<Summary>A string representing the network protocol used to fetch the resource, as identified by the ALPN Protocol ID (RFC7301).</Summary>
  ReadOnly Property [nextHopProtocol] As String
  '''<Summary>Returns a DOMHighResTimeStamp immediately before dispatching the FetchEvent if a Service Worker thread is already running, or immediately before starting the Service Worker thread if it is not already running. If the resource is not intercepted by a Service Worker the property will always return 0.</Summary>
  ReadOnly Property [workerStart] As DOMHighResTimeStamp
  '''<Summary>A DOMHighResTimeStamp that represents the start time of the fetch which initiates the redirect.</Summary>
  ReadOnly Property [redirectStart] As DOMHighResTimeStamp
  '''<Summary>A DOMHighResTimeStamp immediately after receiving the last byte of the response of the last redirect.</Summary>
  ReadOnly Property [redirectEnd] As byte
  '''<Summary>A DOMHighResTimeStamp immediately before the browser starts to fetch the resource.</Summary>
  ReadOnly Property [fetchStart] As DOMHighResTimeStamp
  '''<Summary>A DOMHighResTimeStamp immediately before the browser starts the domain name lookup for the resource.</Summary>
  ReadOnly Property [domainLookupStart] As DOMHighResTimeStamp
  '''<Summary>A DOMHighResTimeStamp representing the time immediately after the browser finishes the domain name lookup for the resource.</Summary>
  ReadOnly Property [domainLookupEnd] As DOMHighResTimeStamp
  '''<Summary>A DOMHighResTimeStamp immediately before the browser starts to establish the connection to the server to retrieve the resource.</Summary>
  ReadOnly Property [connectStart] As DOMHighResTimeStamp
  '''<Summary>A DOMHighResTimeStamp immediately after the browser finishes establishing the connection to the server to retrieve the resource.</Summary>
  ReadOnly Property [connectEnd] As DOMHighResTimeStamp
  '''<Summary>A DOMHighResTimeStamp immediately before the browser starts the handshake process to secure the current connection.</Summary>
  ReadOnly Property [secureConnectionStart] As DOMHighResTimeStamp
  '''<Summary>A DOMHighResTimeStamp immediately before the browser starts requesting the resource from the server.</Summary>
  ReadOnly Property [requestStart] As DOMHighResTimeStamp
  '''<Summary>A DOMHighResTimeStamp immediately after the browser receives the first byte of the response from the server.</Summary>
  ReadOnly Property [responseStart] As byte
  '''<Summary>A DOMHighResTimeStamp immediately after the browser receives the last byte of the resource or immediately before the transport connection is closed, whichever comes first.</Summary>
  ReadOnly Property [responseEnd] As byte
  '''<Summary>A number representing the size (in octets) of the fetched resource. The size includes the response header fields plus the response payload body.</Summary>
  ReadOnly Property [transferSize] As Double
  '''<Summary>A number representing the size (in octets) received from the fetch (HTTP or cache), of the payload body, before removing any applied content-codings.</Summary>
  ReadOnly Property [encodedBodySize] As Double
  '''<Summary>A number that is the size (in octets) received from the fetch (HTTP or cache) of the message body, after removing any applied content-codings.</Summary>
  ReadOnly Property [decodedBodySize] As Double
  '''<Summary>An array of PerformanceServerTiming entries containing server timing metrics.</Summary>
  ReadOnly Property [serverTiming] As PerformanceServerTiming()
  '''<Summary>Returns a DOMString that is the JSON representation of the PerformanceResourceTiming object.</Summary>
  Function [toJSON]() As String
End Interface