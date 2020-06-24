'''<Summary>The XRReferenceSpaceEventInit dictionary is used when calling the XRReferenceSpaceEvent() constructor to provide the values for its properties. Since the properties are read-only, this is the only opportunity available to set their values.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XRReferenceSpaceEventInit]
'Defined on this type 
  '''<Summary>The XRReferenceSpace from which the event originated.</Summary>
  Property [referenceSpace] As XRReferenceSpace
  '''<Summary>An XRRigidTransform which maps the old coordinate system (from before the changes indicated by this event) to the new coordiante system.</Summary>
  Property [transform] As XRRigidTransform
End Interface