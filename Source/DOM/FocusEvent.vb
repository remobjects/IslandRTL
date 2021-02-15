'''<summary>The FocusEvent interface represents focus-related events, including focus, blur, focusin, and focusout.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [FocusEvent]
  '''<summary>Is an EventTarget representing a secondary target for this event. In some cases (such as when tabbing in or out a page), this property may be set to null for security reasons.</summary>
  Property [relatedTarget] As HTMLElement
End Interface