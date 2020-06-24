'''<Summary>The WebXR Device API's XRReferenceSpace interface describes the coordinate system for a specific tracked entity or object within the virtual world using a specified tracking behavior.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRReferenceSpace]
'Defined on this type 
  '''<Summary>Creates and returns a new reference space object as the same type as the one on which you call the method (so, either XRReferenceSpace or XRBoundedReferenceSpace). The new reference space can be used to transform a coordinate from the reference space of the object on which the method is called into a different coordinate space. This is useful for positioning objects while rendering, and to perform the needed transforms when changing the viewer's position and/or orientation in 3D space.</Summary>
  Function [getOffsetReferenceSpace]([paroriginOffset] As Dynamic) As Dynamic
End Interface