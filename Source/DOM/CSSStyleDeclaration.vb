'''<Summary>The CSSStyleDeclaration interface represents an object that is a CSS declaration block, and exposes style information and various style-related methods and properties.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CSSStyleDeclaration]
'Defined on this type 
  '''<Summary>Returns the optional priority, "important".</Summary>
  Function [getPropertyPriority]() As String
  '''<Summary>Returns the property value given a property name.</Summary>
  Function [getPropertyValue]() As String
  '''<Summary>Returns a CSS property name by its index, or the empty string if the index is out-of-bounds.</Summary>
  Function [item]([parindex] As Dynamic) As String
  '''<Summary>Removes a property from the CSS declaration block.</Summary>
  Function [removeProperty]() As String
  '''<Summary>Modifies an existing CSS property or creates a new CSS property in the declaration block.</Summary>
  Sub [setProperty]()
End Interface