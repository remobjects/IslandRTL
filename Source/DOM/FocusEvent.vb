'''<Summary>The FocusEvent interface represents focus-related events, including focus, blur, focusin, and focusout.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [FocusEvent]
'Defined on this type 
  '''<Summary>Is an EventTarget representing a secondary target for this event. In some cases (such as when tabbing in or out a page), this property may be set to null for security reasons.</Summary>
  Property [relatedTarget] As HTMLElement
End Interface