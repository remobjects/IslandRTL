'''<summary>The Accelerometer interface of the Sensor APIs provides on each reading the acceleration applied to the device along all three axes. </summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Accelerometer]
  '''<summary>Returns a double containing the acceleration of the device along the device's x axis.</summary>
  ReadOnly Property [x] As Double
  '''<summary>Returns a double containing the acceleration of the device along the device's y axis.</summary>
  ReadOnly Property [y] As Double
  '''<summary>Returns a double containing the acceleration of the device along the device's z axis.</summary>
  ReadOnly Property [z] As Double
End Interface