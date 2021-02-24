'''<summary>The OES_vertex_array_object extension is part of the WebGL API and provides vertex array objects (VAOs) which encapsulate vertex array states. These objects keep pointers to vertex data and provide names for different sets of vertex data.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [OES_vertex_array_object]
	'''<summary>  Creates a new WebGLVertexArrayObject.  </summary>
	Function [createVertexArrayOES]() As WebGLVertexArrayObject
	'''<summary>  Deletes a given WebGLVertexArrayObject.  </summary>
	Sub [deleteVertexArrayOES]([pararrayObject] As Dynamic)
	'''<summary>  Returns true if a given object is a WebGLVertexArrayObject.  </summary>
	Function [isVertexArrayOES]([pararrayObject] As Dynamic) As Boolean
	'''<summary>  Binds a given WebGLVertexArrayObject to the buffer.  </summary>
	Sub [bindVertexArrayOES]([pararrayObject] As Dynamic)
End Interface