'''<summary>The WEBGL_debug_shaders extension is part of the WebGL API and exposes a method to debug shaders from privileged contexts.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WEBGL_debug_shaders]
  '''<summary>Returns the translated shader source.</summary>
  Function [getTranslatedShaderSource]([parshader] As Dynamic) As String
End Interface