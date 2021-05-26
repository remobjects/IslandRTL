'''<summary>The HTMLElement interface represents any HTML element. Some elements directly implement this interface, while others implement it via an interface that inherits it.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLElement]
Inherits Element

  '''<summary>Is a DOMString representing the access key assigned to the element.</summary>
  Property [accessKey] As String
  '''<summary>Returns a DOMString containing the element's assigned access key.</summary>
  ReadOnly Property [accessKeyLabel] As String
  '''<summary>Is a DOMString, where a value of true means the element is editable and a value of false means it isn't.</summary>
  Property [contentEditable] As String
  '''<summary>Returns a Boolean that indicates whether or not the content of the element can be edited.</summary>
  ReadOnly Property [isContentEditable] As Boolean
  '''<summary>Returns a DOMStringMap with which script can read and write the element's custom data attributes (data-*) .</summary>
  ReadOnly Property [dataset] As String
  '''<summary>Is a DOMString, reflecting the dir global attribute, representing the directionality of the element. Possible values are "ltr", "rtl", and "auto".</summary>
  Property [dir] As String
  '''<summary>Is a Boolean indicating if the element can be dragged.</summary>
  Property [draggable] As HTMLElement
  '''<summary>Returns a DOMSettableTokenList reflecting the dropzone global attribute and describing the behavior of the element regarding a drop operation.</summary>
  ReadOnly Property [dropzone] As DOMTokenList
  '''<summary>Is a Boolean indicating if the element is hidden or not.</summary>
  Property [hidden] As Boolean
  '''<summary>Is a Boolean indicating whether the user agent must act as though the given node is absent for the purposes of user interaction events, in-page text searches ("find in page"), and text selection.</summary>
  Property [inert] As Boolean
  '''<summary>Represents the "rendered" text content of a node and its descendants. As a getter, it approximates the text the user would get if they highlighted the contents of the element with the cursor and then copied it to the clipboard.</summary>
  Property [innerText] As String
  '''<summary>Is a DOMString representing the language of an element's attributes, text, and element contents.</summary>
  Property [lang] As String
  '''<summary>Is a Boolean indicating whether an import script can be executed in user agents that support module scripts.</summary>
  Property [noModule] As Boolean
  '''<summary>Is a Boolean that controls spell-checking. It is present on all HTML elements, though it doesn't have an effect on all of them.</summary>
  Property [spellcheck] As Boolean
  '''<summary>Is a CSSStyleDeclaration, an object representing the declarations of an element's style attributes.</summary>
  Property [style] As Dynamic
  '''<summary>Is a long representing the position of the element in the tabbing order.</summary>
  Property [tabIndex] As Integer
  '''<summary>Is a DOMString containing the text that appears in a popup box when mouse is over the element.</summary>
  Property [title] As String
  '''<summary>Sends a mouse click event to the element.</summary>
  Function [click]() As HTMLElement
  '''<summary>Makes the element the current keyboard focus.</summary>
  Function [focus]([paroptions] As Dynamic, [parpreventScroll] As Dynamic) As HTMLElement
End Interface