'''<Summary>The HTMLStyleElement interface represents a &lt;style> element. It inherits properties and methods from its parent, HTMLElement, and from LinkStyle.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLStyleElement]
Inherits HTMLElement, LinkStyle

'Defined on this type 
  '''<Summary>Is a DOMString representing the intended destination medium for style information.</Summary>
  Property [media] As Dynamic
  '''<Summary>Is a DOMString representing the type of style being applied by this statement.</Summary>
  Property [type] As Dynamic
  '''<Summary>Is a Boolean value representing whether or not the stylesheet is disabled (true) or not (false).</Summary>
  Property [disabled] As Boolean
End Interface