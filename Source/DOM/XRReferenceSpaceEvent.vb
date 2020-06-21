'''<Summary>The WebXR Device API interface XRReferenceSpaceEvent represents an event sent to an XRReferenceSpace. Currently, the only event  that uses this type is the reset event.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRReferenceSpaceEvent]
'Defined on this type 
  '''<Summary>An XRReferenceSpace indicating the reference space that generated the event.</Summary>
  ReadOnly Property [referenceSpace] As XRReferenceSpace
  '''<Summary>An XRRigidTransform object indicating the position and orientation of the specified referenceSpace's native origin after the event, defined relative to the coordinate system before the event.</Summary>
  ReadOnly Property [transform] As Dynamic
  '''<Summary>Returns a new XRReferenceSpaceEvent with the specified type and configured using the values in the given XRReferenceSpaceEventInit dictionary.</Summary>
  Function [XRReferenceSpaceEvent]() As XRReferenceSpaceEvent
End Interface