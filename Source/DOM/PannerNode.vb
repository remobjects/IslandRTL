'''<summary>A PannerNode always has exactly one input and one output: the input can be mono or stereo but the output is always stereo (2 channels); you can't have panning effects without at least two audio channels!</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [PannerNode]
Inherits AudioNode, AudioParam

  '''<summary>Is a double value describing the angle, in degrees, of a cone inside of which there will be no volume reduction.</summary>
  Property [coneInnerAngle] As Double
  '''<summary>A double value describing the angle, in degrees, of a cone outside of which the volume will be reduced by a constant value, defined by the coneOuterGain attribute.</summary>
  Property [coneOuterAngle] As Double
  '''<summary>A double value describing the amount of volume reduction outside the cone defined by the coneOuterAngle attribute. Its default value is 0, meaning that no sound can be heard.</summary>
  Property [coneOuterGain] As Double
  '''<summary>An enumerated value determining which algorithm to use to reduce the volume of the audio source as it moves away from the listener. Possible values are "linear", "inverse" and "exponential". The default value is "inverse".</summary>
  Property [distanceModel] As Dynamic
  '''<summary>A double value representing the maximum distance between the audio source and the listener, after which the volume is not reduced any further.</summary>
  Property [maxDistance] As Double
  '''<summary>Represents the horizontal position of the audio source's vector in a right-hand cartesian coordinate system. While this AudioParam cannot be directly changed, its value can be altered using its value property. The default is value is 1.</summary>
  Property [orientationX] As AudioParam
  '''<summary>Represents the vertical position of the audio source's vector in a right-hand cartesian coordinate system. The default is 0. While this AudioParam cannot be directly changed, its value can be altered using its value property. The default is value is 0.</summary>
  Property [orientationY] As AudioParam
  '''<summary>Represents the longitudinal (back and forth) position of the audio source's vector in a right-hand cartesian coordinate system. The default is 0. While this AudioParam cannot be directly changed, its value can be altered using its value property. The default is value is 0.</summary>
  Property [orientationZ] As AudioParam
  '''<summary>An enumerated value determining which spatialisation algorithm to use to position the audio in 3D space.</summary>
  Property [panningModel] As Dynamic
  '''<summary>Represents the horizontal position of the audio in a right-hand cartesian coordinate system. The default is 0. While this AudioParam cannot be directly changed, its value can be altered using its value property. The default is value is 0.</summary>
  Property [positionX] As Integer
  '''<summary>Represents the vertical position of the audio in a right-hand cartesian coordinate system. The default is 0. While this AudioParam cannot be directly changed, its value can be altered using its value property. The default is value is 0.</summary>
  Property [positionY] As Integer
  '''<summary>Represents the longitudinal (back and forth) position of the audio in a right-hand cartesian coordinate system. The default is 0. While this AudioParam cannot be directly changed, its value can be altered using its value property. The default is value is 0.</summary>
  Property [positionZ] As Integer
  '''<summary>A double value representing the reference distance for reducing volume as the audio source moves further from the listener. For distances greater than this the volume will be reduced based on rolloffFactor and distanceModel.</summary>
  Property [refDistance] As Double
  '''<summary>A double value describing how quickly the volume is reduced as the source moves away from the listener. This value is used by all distance models.</summary>
  Property [rolloffFactor] As Double
  '''<summary>Defines the position of the audio source relative to the listener (represented by an AudioListener object stored in the AudioContext.listener attribute.)</summary>
  Function [setPosition]([parx] As Dynamic,[pary] As Dynamic,[parz] As Dynamic) As Dynamic
End Interface