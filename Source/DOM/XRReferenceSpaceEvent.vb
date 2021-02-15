'''<summary>The WebXR Device API interface XRReferenceSpaceEvent represents an event sent to an XRReferenceSpace. Currently, the only event  that uses this type is the reset event.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRReferenceSpaceEvent]
  '''<summary>An XRReferenceSpace indicating the reference space that generated the event.</summary>
  ReadOnly Property [referenceSpace] As XRReferenceSpace
  '''<summary>An XRRigidTransform object indicating the position and orientation of the specified referenceSpace's native origin after the event, defined relative to the coordinate system before the event.</summary>
  ReadOnly Property [transform] As Dynamic
End Interface