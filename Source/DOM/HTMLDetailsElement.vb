'''<summary>The HTMLDetailsElement interface provides special properties (beyond the regular HTMLElement interface it also has available to it by inheritance) for manipulating &lt;details> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLDetailsElement]
Inherits HTMLElement

  '''<summary>Is a boolean reflecting the open HTML attribute, indicating whether or not the element’s contents (not counting the ) element specifies a summary, caption, or legend for a &lt;details> element's disclosure box.">&lt;summary&gt;) is to be shown to the user.</summary>
  Property [open] As HTMLElement
End Interface