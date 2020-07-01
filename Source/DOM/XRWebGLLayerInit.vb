'''<Summary>The WebXR Device API's XRWebGLLayerInit dictionary is used to provide configuration options when creating a new XRWebGLLayer object with the XRWebGLLayer() constructor.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRWebGLLayerInit]
  '''<Summary>The frame buffer's color buffer will be established with an alpha channel if the alpha Boolean property is true. Otherwise, the color buffer will not have an alpha channel. The default value is true.</Summary>
  Property [alpha] As Boolean
  '''<Summary>A Boolean value which is true if anti-aliasing is to be used when rendering in the context; otherwise false. The browser selects the anti-aliasing method to use; there is no support for requesting a specific mode yet.  The default value is true.</Summary>
  Property [antialias] As Boolean
  '''<Summary>A Boolean value which, if true, requests that the new layer have a depth buffer; otherwise, no depth layer is allocated. The default is true.</Summary>
  Property [depth] As Boolean
  '''<Summary>A floating-point value which is used to scale the image during compositing, with a value of 1.0 represents the default pixel size for the frame buffer. The static XRWebGLLayer function XRWebGLLayer.getNativeFramebufferScaleFactor() returns the scale that would result in a 1:1 pixel ratio, thereby ensuring that the rendering is occurring at the device's native resolution. The default is 1.0.</Summary>
  Property [framebufferScaleFactor] As Double
  '''<Summary>A Boolean value which indicates whether or not to ignore the contents of the depth buffer while compositing the scene. The default is false.</Summary>
  Property [ignoreDepthValues] As Boolean
  '''<Summary>A Boolean value which, if true, requests that the new layer include a stencil buffer. Otherwise, no stencil buffer is allocated. The default is false.</Summary>
  Property [stencil] As Boolean
End Interface