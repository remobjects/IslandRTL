'''<Summary>The Media Session API's MediaImage dictionary describes the images associated with the media resource MediaMetadata.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [MediaImage]
  '''<Summary>The URL from which user agent can fetch the image's data.</Summary>
  Property [src] As String
  '''<Summary>Specifies the resource in multiple sizes so that user agent does not have to scale a single image.</Summary>
  Property [sizes] As Dynamic
  '''<Summary>The MIME type hint for the user agant. Note that it is just a hint so that user agent may ignore images of types it does not support; user agent still may use mime type sniffing after downloading the image to determine its type.</Summary>
  Property [type] As Dynamic
End Interface