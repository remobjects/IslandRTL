'''<summary>The AudioListener interface represents the position and orientation of the unique person listening to the audio scene, and is used in audio spatialization. All PannerNodes spatialize in relation to the AudioListener stored in the BaseAudioContext.listener attribute.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioListener]
  '''<summary>Represents the horizontal position of the listener in a right-hand cartesian coordinate sytem. The default is 0.</summary>
  Property [positionX] As Integer
  '''<summary>Represents the vertical position of the listener in a right-hand cartesian coordinate sytem. The default is 0.</summary>
  Property [positionY] As Integer
  '''<summary>Represents the longitudinal (back and forth) position of the listener in a right-hand cartesian coordinate sytem. The default is 0.</summary>
  Property [positionZ] As Integer
  '''<summary>Represents the horizontal position of the listener's forward direction in the same cartesian coordinate sytem as the position (positionX, positionY, and positionZ) values. The forward and up values are linearly independent of each other. The default is 0.</summary>
  Property [forwardX] As Integer
  '''<summary>Represents the vertical position of the listener's forward direction in the same cartesian coordinate sytem as the position (positionX, positionY, and positionZ) values. The forward and up values are linearly independent of each other. The default is 0.</summary>
  Property [forwardY] As Integer
  '''<summary>Represents the longitudinal (back and forth) position of the listener's forward direction in the same cartesian coordinate sytem as the position (positionX, positionY, and positionZ) values. The forward and up values are linearly independent of each other. The default is -1.</summary>
  Property [forwardZ] As Integer
  '''<summary>Represents the horizontal position of the top of the listener's head in the same cartesian coordinate sytem as the position (positionX, positionY, and positionZ) values. The forward and up values are linearly independent of each other. The default is 0.</summary>
  Property [upX] As Integer
  '''<summary>Represents the vertical position of the top of the listener's head in the same cartesian coordinate sytem as the position (positionX, positionY, and positionZ) values. The forward and up values are linearly independent of each other. The default is 1.</summary>
  Property [upY] As Integer
  '''<summary>Represents the longitudinal (back and forth) position of the top of the listener's head in the same cartesian coordinate sytem as the position (positionX, positionY, and positionZ) values. The forward and up values are linearly independent of each other. The default is 0.</summary>
  Property [upZ] As Integer
End Interface