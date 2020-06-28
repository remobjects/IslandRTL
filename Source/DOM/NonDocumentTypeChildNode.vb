'''<Summary>The NonDocumentTypeChildNode interface contains methods that are particular to Node objects that can have a parent, but not suitable for DocumentType.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [NonDocumentTypeChildNode]
  '''<Summary>Returns the Element immediately prior to this node in its parent's children list, or null if there is no Element in the list prior to this node.</Summary>
  ReadOnly Property [previousElementSibling] As HTMLElement
  '''<Summary>Returns the Element immediately following this node in its parent's children list, or null if there is no Element in the list following this node.</Summary>
  ReadOnly Property [nextElementSibling] As HTMLElement
End Interface