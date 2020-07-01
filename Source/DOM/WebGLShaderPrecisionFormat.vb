'''<Summary>The WebGLShaderPrecisionFormat interface is part of the WebGL API and represents the information returned by calling the WebGLRenderingContext.getShaderPrecisionFormat() method.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WebGLShaderPrecisionFormat]
  '''<Summary>The number of bits of precision that can be represented. For integer formats this value is always 0.</Summary>
  ReadOnly Property [precision] As Double
End Interface