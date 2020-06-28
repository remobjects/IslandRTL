'''<Summary>The Gyroscope interface of the Sensor APIs provides on each reading the angular velocity of the device along all three axes. </Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Gyroscope]
  '''<Summary>Returns a double, containing the angular velocity of the device along the device's x axis.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>Returns a double, containing the angular velocity of the device along the device's y axis.</Summary>
  ReadOnly Property [y] As Double
  '''<Summary>Returns a double, containing the angular velocity of the device along the device's z axis.</Summary>
  ReadOnly Property [z] As Double
End Interface