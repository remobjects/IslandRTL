'''<summary>The WebGLShaderPrecisionFormat interface is part of the WebGL API and represents the information returned by calling the WebGLRenderingContext.getShaderPrecisionFormat() method.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WebGLShaderPrecisionFormat]
  '''<summary>The number of bits of precision that can be represented. For integer formats this value is always 0.</summary>
  ReadOnly Property [precision] As Double
End Interface