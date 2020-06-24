'''<Summary>The WEBGL_draw_buffers extension is part of the WebGL API and enables a fragment shader to write to several textures, which is useful for deferred shading, for example.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [WEBGL_draw_buffers]
'Defined on this type 
  '''<Summary> Defines the draw buffers to which all fragment colors are written. (When using WebGL2, this method is available as gl.drawBuffers() by default). </Summary>
  Sub [drawBuffersWEBGL]([parbuffers] As Dynamic)
End Interface