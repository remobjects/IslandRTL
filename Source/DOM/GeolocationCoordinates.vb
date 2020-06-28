'''<Summary>The GeolocationCoordinates interface represents the position and altitude of the device on Earth, as well as the accuracy with which these properties are calculated.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [GeolocationCoordinates]
  '''<Summary>Returns a double representing the position's latitude in decimal degrees.</Summary>
  ReadOnly Property [latitude] As Double
  '''<Summary>Returns a double representing the position's longitude in decimal degrees.</Summary>
  ReadOnly Property [longitude] As Double
  '''<Summary>Returns a double representing the position's altitude in meters, relative to sea level. This value can be null if the implementation cannot provide the data.</Summary>
  ReadOnly Property [altitude] As Double
  '''<Summary>Returns a double representing the accuracy of the latitude and longitude properties, expressed in meters.</Summary>
  ReadOnly Property [accuracy] As Double
  '''<Summary>Returns a double representing the accuracy of the altitude expressed in meters. This value can be null.</Summary>
  ReadOnly Property [altitudeAccuracy] As Double
  '''<Summary>Returns a double representing the direction in which the device is traveling. This value, specified in degrees, indicates how far off from heading true north the device is. 0 degrees represents true north, and the direction is determined clockwise (which means that east is 90 degrees and west is 270 degrees). If speed is 0, heading is NaN. If the device is unable to provide heading information, this value is null.</Summary>
  ReadOnly Property [heading] As Double
  '''<Summary>Returns a double representing the velocity of the device in meters per second. This value can be null.</Summary>
  ReadOnly Property [speed] As Double
End Interface