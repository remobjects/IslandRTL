'''<Summary>The TransformStream interface of the Streams API represents a set of transformable data.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TransformStream]
  '''<Summary>The readable end of a TransformStream.</Summary>
  ReadOnly Property [readable] As Dynamic
  '''<Summary>The writable end of a TransformStream.</Summary>
  ReadOnly Property [writable] As Dynamic
End Interface