'''<summary>The GeolocationPosition interface represents the position of the concerned device at a given time. The position, represented by a GeolocationCoordinates object, comprehends the 2D position of the device, on a spheroid representing the Earth, but also its altitude and its speed.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [GeolocationPosition]
  '''<summary>Returns a GeolocationCoordinates object defining the current location.</summary>
  ReadOnly Property [coords] As Dynamic
  '''<summary>Returns a DOMTimeStamp representing the time at which the location was retrieved.</summary>
  ReadOnly Property [timestamp] As DOMTimeStamp
End Interface