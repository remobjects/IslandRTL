'''<Summary>The WebGLActiveInfo interface is part of the WebGL API and represents the information returned by calling the WebGLRenderingContext.getActiveAttrib() and WebGLRenderingContext.getActiveUniform() methods.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WebGLActiveInfo]
  '''<Summary>The read-only name of the requested variable.</Summary>
  Property [name] As String
  '''<Summary>The read-only type of the requested variable.</Summary>
  Property [type] As Dynamic
End Interface