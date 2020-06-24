'''<Summary>The WEBGL_debug_shaders extension is part of the WebGL API and exposes a method to debug shaders from privileged contexts.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WEBGL_debug_shaders]
'Defined on this type 
  '''<Summary>Returns the translated shader source.</Summary>
  Function [getTranslatedShaderSource]([parshader] As Dynamic) As String
End Interface