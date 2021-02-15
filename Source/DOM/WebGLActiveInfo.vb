'''<summary>The WebGLActiveInfo interface is part of the WebGL API and represents the information returned by calling the WebGLRenderingContext.getActiveAttrib() and WebGLRenderingContext.getActiveUniform() methods.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WebGLActiveInfo]
  '''<summary>The read-only name of the requested variable.</summary>
  Property [name] As String
  '''<summary>The read-only type of the requested variable.</summary>
  Property [type] As Dynamic
End Interface