'''<Summary>The PerformanceResourceTiming interface enables retrieval and analysis of detailed network timing data regarding the loading of an application's resources. An application can use the timing metrics to determine, for example, the length of time it takes to fetch a specific resource, such as an XMLHttpRequest, &lt;SVG>, image, or script.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PerformanceResourceTiming]
'Defined on this type 
  '''<Summary>A string representing the type of resource that initiated the performance entry, as specified in PerformanceResourceTiming.initiatorType.</Summary>
  ReadOnly Property [initiatorType] As Dynamic
  '''<Summary>A string representing the network protocol used to fetch the resource, as identified by the ALPN Protocol ID (RFC7301).</Summary>
  ReadOnly Property [nextHopProtocol] As String
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