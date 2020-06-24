'''<Summary>The OES_vertex_array_object extension is part of the WebGL API and provides vertex array objects (VAOs) which encapsulate vertex array states. These objects keep pointers to vertex data and provide names for different sets of vertex data.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [OES_vertex_array_object]
'Defined on this type 
  '''<Summary>	Creates a new WebGLVertexArrayObject.	</Summary>
  Function [createVertexArrayOES]() As WebGLVertexArrayObject
  '''<Summary>	Deletes a given WebGLVertexArrayObject.	</Summary>
  Sub [deleteVertexArrayOES]([pararrayObject] As Dynamic)
  '''<Summary>	Returns true if a given object is a WebGLVertexArrayObject.	</Summary>
  Function [isVertexArrayOES]([pararrayObject] As Dynamic) As Boolean
  '''<Summary>	Binds a given WebGLVertexArrayObject to the buffer.	</Summary>
  Sub [bindVertexArrayOES]([pararrayObject] As Dynamic)
End Interface