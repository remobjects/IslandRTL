'''<summary>The BlobEvent interface represents events associated with a Blob. These blobs are typically, but not necessarily,  associated with media content.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [BlobEvent]
  '''<summary>A Blob representing the data associated with the event. The event was fired on the EventTarget because of something happening on that specific Blob.</summary>
  ReadOnly Property [data] As Dynamic
  '''<summary>A DOMHighResTimeStamp indicating the difference between the timestamp of the first chunk in data and the timestamp of the first chunk in the first BlobEvent produced by this recorder. Note that the timecode in the first produced BlobEvent does not need to be zero.</summary>
  ReadOnly Property [timecode] As DateTime
End Interface