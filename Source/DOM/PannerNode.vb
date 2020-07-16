'''<Summary>A PannerNode always has exactly one input and one output: the input can be mono or stereo but the output is always stereo (2 channels); you can't have panning effects without at least two audio channels!</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PannerNode]
Inherits AudioNode, AudioParam

  '''<Summary>Is a double value describing the angle, in degrees, of a cone inside of which there will be no volume reduction.</Summary>
  Property [coneInnerAngle] As Double
  '''<Summary>A double value describing the angle, in degrees, of a cone outside of which the volume will be reduced by a constant value, defined by the coneOuterGain attribute.</Summary>
  Property [coneOuterAngle] As Double
  '''<Summary>A double value describing the amount of volume reduction outside the cone defined by the coneOuterAngle attribute. Its default value is 0, meaning that no sound can be heard.</Summary>
  Property [coneOuterGain] As Double
  '''<Summary>An enumerated value determining which algorithm to use to reduce the volume of the audio source as it moves away from the listener. Possible values are "linear", "inverse" and "exponential". The default value is "inverse".</Summary>
  Property [distanceModel] As Dynamic
  '''<Summary>A double value representing the maximum distance between the audio source and the listener, after which the volume is not reduced any further.</Summary>
  Property [maxDistance] As Double
  '''<Summary>Represents the horizontal position of the audio source's vector in a right-hand cartesian coordinate system. While this AudioParam cannot be directly changed, its value can be altered using its value property. The default is value is 1.</Summary>
  Property [orientationX] As AudioParam
  '''<Summary>Represents the vertical position of the audio source's vector in a right-hand cartesian coordinate system. The default is 0. While this AudioParam cannot be directly changed, its value can be altered using its value property. The default is value is 0.</Summary>
  Property [orientationY] As AudioParam
  '''<Summary>Represents the longitudinal (back and forth) position of the audio source's vector in a right-hand cartesian coordinate system. The default is 0. While this AudioParam cannot be directly changed, its value can be altered using its value property. The default is value is 0.</Summary>
  Property [orientationZ] As AudioParam
  '''<Summary>An enumerated value determining which spatialisation algorithm to use to position the audio in 3D space.</Summary>
  Property [panningModel] As Dynamic
  '''<Summary>Represents the horizontal position of the audio in a right-hand cartesian coordinate system. The default is 0. While this AudioParam cannot be directly changed, its value can be altered using its value property. The default is value is 0.</Summary>
  Property [positionX] As Integer
  '''<Summary>Represents the vertical position of the audio in a right-hand cartesian coordinate system. The default is 0. While this AudioParam cannot be directly changed, its value can be altered using its value property. The default is value is 0.</Summary>
  Property [positionY] As Integer
  '''<Summary>Represents the longitudinal (back and forth) position of the audio in a right-hand cartesian coordinate system. The default is 0. While this AudioParam cannot be directly changed, its value can be altered using its value property. The default is value is 0.</Summary>
  Property [positionZ] As Integer
  '''<Summary>A double value representing the reference distance for reducing volume as the audio source moves further from the listener. For distances greater than this the volume will be reduced based on rolloffFactor and distanceModel.</Summary>
  Property [refDistance] As Double
  '''<Summary>A double value describing how quickly the volume is reduced as the source moves away from the listener. This value is used by all distance models.</Summary>
  Property [rolloffFactor] As Double
  '''<Summary>Defines the position of the audio source relative to the listener (represented by an AudioListener object stored in the AudioContext.listener attribute.)</Summary>
  Function [setPosition]([parx] As Dynamic,[pary] As Dynamic,[parz] As Dynamic) As Dynamic
End Interface