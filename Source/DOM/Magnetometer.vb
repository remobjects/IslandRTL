'''<Summary>The Magnetometer interface of the Sensor APIs provides information about the magnetic field as detected by the device’s primary magnetometer sensor. </Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Magnetometer]
'Defined on this type 
  '''<Summary>Returns a double containing the magnetic field around the device's x axis.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>Returns a double containing the magnetic field around the device's y axis.</Summary>
  ReadOnly Property [y] As Double
  '''<Summary>Returns a double containing the magnetic field around the device's z axis.</Summary>
  ReadOnly Property [z] As Double
  '''<Summary>Creates a new Magnetometer object.</Summary>
  Function [Magnetometer]() As Magnetometer
End Interface