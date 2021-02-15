'''<summary>The Magnetometer interface of the Sensor APIs provides information about the magnetic field as detected by the device’s primary magnetometer sensor. </summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Magnetometer]
  '''<summary>Returns a double containing the magnetic field around the device's x axis.</summary>
  ReadOnly Property [x] As Double
  '''<summary>Returns a double containing the magnetic field around the device's y axis.</summary>
  ReadOnly Property [y] As Double
  '''<summary>Returns a double containing the magnetic field around the device's z axis.</summary>
  ReadOnly Property [z] As Double
End Interface