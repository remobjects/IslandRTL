'''<Summary>The WEBGL_compressed_texture_astc extension is part of the WebGL API and exposes Adaptive Scalable Texture Compression (ASTC) compressed texture formats to WebGL.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WEBGL_compressed_texture_astc]
  '''<Summary> Returns an array of strings containing the names of the ASTC profiles supported by the implementation. </Summary>
  Function [getSupportedProfiles]() As String
End Interface