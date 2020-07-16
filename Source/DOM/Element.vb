'''<Summary>Element is the most general base class from which all element objects (i.e. objects that represent elements) in a Document inherit. It only has methods and properties common to all kinds of elements. More specific classes inherit from Element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Element]
Inherits Node

  '''<Summary>Returns a NamedNodeMap object containing the assigned attributes of the corresponding HTML element.</Summary>
  ReadOnly Property [attributes] As Dynamic
  '''<Summary>Returns a DOMTokenList containing the list of class attributes.</Summary>
  ReadOnly Property [classList] As DOMTokenList
  '''<Summary>Is a DOMString representing the class of the element.</Summary>
  Property [className] As String
  '''<Summary>Returns a Number representing the inner height of the element.</Summary>
  ReadOnly Property [clientHeight] As Integer
  '''<Summary>Returns a Number representing the width of the left border of the element.</Summary>
  ReadOnly Property [clientLeft] As HTMLElement
  '''<Summary>Returns a Number representing the width of the top border of the element.</Summary>
  ReadOnly Property [clientTop] As HTMLElement
  '''<Summary>Returns a Number representing the inner width of the element.</Summary>
  ReadOnly Property [clientWidth] As Integer
  '''<Summary>Returns a DOMString containing the label exposed to accessibility.</Summary>
  ReadOnly Property [computedName] As String
  '''<Summary>Returns a DOMString containing the ARIA role that has been applied to a particular element.</Summary>
  ReadOnly Property [computedRole] As String
  '''<Summary>Is a DOMString representing the id of the element.</Summary>
  Property [id] As String
  '''<Summary>Is a DOMString representing the markup of the element's content.</Summary>
  Property [innerHTML] As String
  '''<Summary>A DOMString representing the local part of the qualified name of the element.</Summary>
  ReadOnly Property [localName] As String
  '''<Summary>The namespace URI of the element, or null if it is no namespace.</Summary>
  ReadOnly Property [namespaceURI] As String
  '''<Summary>Is a DOMString representing the markup of the element including its content. When used as a setter, replaces the element with nodes parsed from the given string.</Summary>
  Property [outerHTML] As String
  '''<Summary>Represents the part identifier(s) of the element (i.e. set using the part attribute), returned as a DOMTokenList.</Summary>
  Property [part] As DOMTokenList
  '''<Summary>A DOMString representing the namespace prefix of the element, or null if no prefix is specified.</Summary>
  ReadOnly Property [prefix] As String
  '''<Summary>Returns a Number representing the scroll view height of an element.</Summary>
  ReadOnly Property [scrollHeight] As Integer
  '''<Summary>Is a Number representing the left scroll offset of the element.</Summary>
  Property [scrollLeft] As HTMLElement
  '''<Summary>A Number representing number of pixels the top of the document is scrolled vertically.</Summary>
  Property [scrollTop] As Integer
  '''<Summary>Returns a Number representing the scroll view width of the element.</Summary>
  ReadOnly Property [scrollWidth] As Integer
  '''<Summary>Returns the open shadow root that is hosted by the element, or null if no open shadow root is present.</Summary>
  ReadOnly Property [shadowRoot] As HTMLElement
  '''<Summary>Returns a String with the name of the tag for the given element.</Summary>
  ReadOnly Property [tagName] As String
  '''<Summary>An event handler for the fullscreenchange event, which is sent when the element enters or exits full-screen mode. This can be used to watch both for successful expected transitions, but also to watch for unexpected changes, such as when your app is running in the background.</Summary>
  Property [onfullscreenchange] As Dynamic
  '''<Summary>An event handler for the fullscreenerror event, which is sent when an error occurs while attempting to change into full-screen mode.</Summary>
  Property [onfullscreenerror] As Dynamic
End Interface