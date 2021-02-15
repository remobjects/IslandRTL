'''<summary>The CSSStyleDeclaration interface represents an object that is a CSS declaration block, and exposes style information and various style-related methods and properties.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CSSStyleDeclaration]
  '''<summary>Returns the optional priority, "important".</summary>
  Function [getPropertyPriority]() As String
  '''<summary>Returns the property value given a property name.</summary>
  Function [getPropertyValue]() As String
  '''<summary>Returns a CSS property name by its index, or the empty string if the index is out-of-bounds.</summary>
  Function [item]() As String
  '''<summary>Removes a property from the CSS declaration block.</summary>
  Function [removeProperty]() As String
  '''<summary>Modifies an existing CSS property or creates a new CSS property in the declaration block.</summary>
  Sub [setProperty]()
End Interface