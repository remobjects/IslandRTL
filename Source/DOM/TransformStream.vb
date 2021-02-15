'''<summary>The TransformStream interface of the Streams API represents a set of transformable data.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TransformStream]
  '''<summary>The readable end of a TransformStream.</summary>
  ReadOnly Property [readable] As Dynamic
  '''<summary>The writable end of a TransformStream.</summary>
  ReadOnly Property [writable] As Dynamic
End Interface