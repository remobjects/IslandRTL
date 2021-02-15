'''<summary>The HTMLLIElement interface exposes specific properties and methods (beyond those defined by regular HTMLElement interface it also has available to it by inheritance) for manipulating list elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLLIElement]
Inherits HTMLElement

  '''<summary>Is a long indicating the ordinal position of the list element inside a given  element represents an ordered list of items — typically rendered as a numbered list.">&lt;ol&gt;. It reflects the value attribute of the HTML  element is used to represent an item in a list.">&lt;li&gt; element, and can be smaller than 0. If the  element is used to represent an item in a list.">&lt;li&gt; element is not a child of an  element represents an ordered list of items — typically rendered as a numbered list.">&lt;ol&gt; element, the property has no meaning.</summary>
  Property [value] As String
End Interface