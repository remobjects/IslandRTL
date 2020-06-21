'''<Summary>The AudioNode interface is a generic interface for representing an audio processing module. Examples include:</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [AudioNode]
'Defined on this type 
  '''<Summary>Allows us to connect the output of this node to be input into another node, either as audio data or as the value of an AudioParam.</Summary>
  Function [connect]([pardestination] As Dynamic, [paroutputIndex] As Dynamic, [parinputIndex] As Dynamic) As AudioNode
  '''<Summary>Allows us to disconnect the current node from another one it is already connected to.</Summary>
  Sub [disconnect]([pardestination] As Dynamic, [paroutput] As Dynamic, [parinput] As Dynamic)
End Interface