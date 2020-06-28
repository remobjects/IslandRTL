'''<Summary>The AudioListener interface represents the position and orientation of the unique person listening to the audio scene, and is used in audio spatialization. All PannerNodes spatialize in relation to the AudioListener stored in the BaseAudioContext.listener attribute.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioListener]
  '''<Summary>Represents the horizontal position of the listener in a right-hand cartesian coordinate sytem. The default is 0.</Summary>
  Property [positionX] As Integer
  '''<Summary>Represents the vertical position of the listener in a right-hand cartesian coordinate sytem. The default is 0.</Summary>
  Property [positionY] As Integer
  '''<Summary>Represents the longitudinal (back and forth) position of the listener in a right-hand cartesian coordinate sytem. The default is 0.</Summary>
  Property [positionZ] As Integer
  '''<Summary>Represents the horizontal position of the listener's forward direction in the same cartesian coordinate sytem as the position (positionX, positionY, and positionZ) values. The forward and up values are linearly independent of each other. The default is 0.</Summary>
  Property [forwardX] As Integer
  '''<Summary>Represents the vertical position of the listener's forward direction in the same cartesian coordinate sytem as the position (positionX, positionY, and positionZ) values. The forward and up values are linearly independent of each other. The default is 0.</Summary>
  Property [forwardY] As Integer
  '''<Summary>Represents the longitudinal (back and forth) position of the listener's forward direction in the same cartesian coordinate sytem as the position (positionX, positionY, and positionZ) values. The forward and up values are linearly independent of each other. The default is -1.</Summary>
  Property [forwardZ] As Integer
  '''<Summary>Represents the horizontal position of the top of the listener's head in the same cartesian coordinate sytem as the position (positionX, positionY, and positionZ) values. The forward and up values are linearly independent of each other. The default is 0.</Summary>
  Property [upX] As Integer
  '''<Summary>Represents the vertical position of the top of the listener's head in the same cartesian coordinate sytem as the position (positionX, positionY, and positionZ) values. The forward and up values are linearly independent of each other. The default is 1.</Summary>
  Property [upY] As Integer
  '''<Summary>Represents the longitudinal (back and forth) position of the top of the listener's head in the same cartesian coordinate sytem as the position (positionX, positionY, and positionZ) values. The forward and up values are linearly independent of each other. The default is 0.</Summary>
  Property [upZ] As Integer
End Interface