'''<summary>The GeolocationPositionError interface represents the reason of an error occurring when using the geolocating device.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [GeolocationPositionError]
  '''<summary>Returns an unsigned short representing the error code. The following values are possible:</summary>
  ReadOnly Property [code] As UShort
  '''<summary>Returns a human-readable DOMString describing the details of the error. Specifications note that this is primarily intended for debugging use and not to be shown directly in a user interface.</summary>
  ReadOnly Property [message] As String
End Interface