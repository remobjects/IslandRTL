'''<summary>The HTMLStyleElement interface represents a &lt;style> element. It inherits properties and methods from its parent, HTMLElement, and from LinkStyle.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLStyleElement]
Inherits HTMLElement, LinkStyle

  '''<summary>Is a DOMString representing the intended destination medium for style information.</summary>
  Property [media] As Dynamic
  '''<summary>Is a DOMString representing the type of style being applied by this statement.</summary>
  Property [type] As Dynamic
  '''<summary>Is a Boolean value representing whether or not the stylesheet is disabled (true) or not (false).</summary>
  Property [disabled] As Boolean
End Interface