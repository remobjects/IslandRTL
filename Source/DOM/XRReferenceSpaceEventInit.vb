'''<summary>The XRReferenceSpaceEventInit dictionary is used when calling the XRReferenceSpaceEvent() constructor to provide the values for its properties. Since the properties are read-only, this is the only opportunity available to set their values.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRReferenceSpaceEventInit]
  '''<summary>The XRReferenceSpace from which the event originated.</summary>
  Property [referenceSpace] As XRReferenceSpace
  '''<summary>An XRRigidTransform which maps the old coordinate system (from before the changes indicated by this event) to the new coordiante system.</summary>
  Property [transform] As XRRigidTransform
End Interface