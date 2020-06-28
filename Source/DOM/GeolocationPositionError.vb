'''<Summary>The GeolocationPositionError interface represents the reason of an error occurring when using the geolocating device.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [GeolocationPositionError]
  '''<Summary>Returns an unsigned short representing the error code. The following values are possible:</Summary>
  ReadOnly Property [code] As UShort
  '''<Summary>Returns a human-readable DOMString describing the details of the error. Specifications note that this is primarily intended for debugging use and not to be shown directly in a user interface.</Summary>
  ReadOnly Property [message] As String
End Interface