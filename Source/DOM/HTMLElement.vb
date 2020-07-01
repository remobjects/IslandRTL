'''<Summary>The HTMLElement interface represents any HTML element. Some elements directly implement this interface, while others implement it via an interface that inherits it.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLElement]
Inherits Element

  '''<Summary>Is a DOMString representing the access key assigned to the element.</Summary>
  Property [accessKey] As String
  '''<Summary>Returns a DOMString containing the element's assigned access key.</Summary>
  ReadOnly Property [accessKeyLabel] As String
  '''<Summary>Is a DOMString, where a value of true means the element is editable and a value of false means it isn't.</Summary>
  Property [contentEditable] As String
  '''<Summary>Returns a Boolean that indicates whether or not the content of the element can be edited.</Summary>
  ReadOnly Property [isContentEditable] As Boolean
  '''<Summary>Returns a DOMStringMap with which script can read and write the element's custom data attributes (data-*) .</Summary>
  ReadOnly Property [dataset] As String
  '''<Summary>Is a DOMString, reflecting the dir global attribute, representing the directionality of the element. Possible values are "ltr", "rtl", and "auto".</Summary>
  Property [dir] As String
  '''<Summary>Is a Boolean indicating if the element can be dragged.</Summary>
  Property [draggable] As HTMLElement
  '''<Summary>Returns a DOMSettableTokenList reflecting the dropzone global attribute and describing the behavior of the element regarding a drop operation.</Summary>
  ReadOnly Property [dropzone] As DOMTokenList
  '''<Summary>Is a Boolean indicating if the element is hidden or not.</Summary>
  Property [hidden] As HTMLElement
  '''<Summary>Is a Boolean indicating whether the user agent must act as though the given node is absent for the purposes of user interaction events, in-page text searches ("find in page"), and text selection.</Summary>
  Property [inert] As Boolean
  '''<Summary>Represents the "rendered" text content of a node and its descendants. As a getter, it approximates the text the user would get if they highlighted the contents of the element with the cursor and then copied it to the clipboard.</Summary>
  Property [innerText] As String
  '''<Summary>Is a DOMString representing the language of an element's attributes, text, and element contents.</Summary>
  Property [lang] As String
  '''<Summary>Is a Boolean indicating whether an import script can be executed in user agents that support module scripts.</Summary>
  Property [noModule] As Boolean
  '''<Summary>Is a Boolean that controls spell-checking. It is present on all HTML elements, though it doesn't have an effect on all of them.</Summary>
  Property [spellcheck] As Boolean
  '''<Summary>Is a CSSStyleDeclaration, an object representing the declarations of an element's style attributes.</Summary>
  Property [style] As Dynamic
  '''<Summary>Is a long representing the position of the element in the tabbing order.</Summary>
  Property [tabIndex] As Integer
  '''<Summary>Is a DOMString containing the text that appears in a popup box when mouse is over the element.</Summary>
  Property [title] As String
End Interface