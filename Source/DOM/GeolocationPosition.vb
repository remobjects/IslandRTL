'''<Summary>The GeolocationPosition interface represents the position of the concerned device at a given time. The position, represented by a GeolocationCoordinates object, comprehends the 2D position of the device, on a spheroid representing the Earth, but also its altitude and its speed.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [GeolocationPosition]
'Defined on this type 
  '''<Summary>Returns a GeolocationCoordinates object defining the current location.</Summary>
  ReadOnly Property [coords] As Dynamic
  '''<Summary>Returns a DOMTimeStamp representing the time at which the location was retrieved.</Summary>
  ReadOnly Property [timestamp] As DOMTimeStamp
End Interface