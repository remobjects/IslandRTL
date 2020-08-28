'''<Summary>The BlobEvent interface represents events associated with a Blob. These blobs are typically, but not necessarily,  associated with media content.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [BlobEvent]
  '''<Summary>A Blob representing the data associated with the event. The event was fired on the EventTarget because of something happening on that specific Blob.</Summary>
  ReadOnly Property [data] As Dynamic
  '''<Summary>A DOMHighResTimeStamp indicating the difference between the timestamp of the first chunk in data and the timestamp of the first chunk in the first BlobEvent produced by this recorder. Note that the timecode in the first produced BlobEvent does not need to be zero.</Summary>
  ReadOnly Property [timecode] As DateTime
End Interface