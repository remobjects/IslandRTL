'''<Summary>Element is the most general base class from which all element objects (i.e. objects that represent elements) in a Document inherit. It only has methods and properties common to all kinds of elements. More specific classes inherit from Element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Element]
Inherits Node

  '''<Summary>Returns a NamedNodeMap object containing the assigned attributes of the corresponding HTML element.</Summary>
  ReadOnly Property [attributes] As NamedNodeMap
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
  '''<Summary>Registers an event handler to a specific event type on the element.</Summary>
  Sub [addEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [parcapture] As Dynamic, [paronce] As Dynamic, [parpassive] As Dynamic)
  '''<Summary>Attaches a shadow DOM tree to the specified element and returns a reference to its ShadowRoot.</Summary>
  Function [attachShadow]([parshadowRootInit] As Dynamic, [parmode] As Dynamic, [pardelegatesFocus] As Dynamic) As ShadowRoot
  '''<Summary>Dispatches an event to this node in the DOM and returns a Boolean that indicates whether no handler canceled the event.</Summary>
  Function [dispatchEvent]([parevent] As Dynamic) As Dynamic
  '''<Summary>Retrieves the value of the attribute with the specified name, from the current node and returns it as an Object.</Summary>
  Function [getAttribute]([parname] As Dynamic) As String
  '''<Summary>Retrieves the value of the attribute with the specified name and namespace, from the current node and returns it as an Object.</Summary>
  Function [getAttributeNS]([parnamespace] As Dynamic, [parname] As Dynamic) As String
  '''<Summary>Returns the size of an element and its position relative to the viewport.</Summary>
  Function [getBoundingClientRect]() As DOMRect
  '''<Summary>Returns a collection of rectangles that indicate the bounding rectangles for each line of text in a client.</Summary>
  Function [getClientRects]() As DOMRect
  '''<Summary>Returns a live HTMLCollection that contains all descendants of the current element that possess the list of classes given in the parameter.</Summary>
  Function [getElementsByClassName]([parnames] As Dynamic) As HTMLCollection
  '''<Summary>Returns a live HTMLCollection containing all descendant elements, of a particular tag name, from the current element.</Summary>
  Function [getElementsByTagName]([partagName] As Dynamic) As HTMLCollection
  '''<Summary>Returns a live HTMLCollection containing all descendant elements, of a particular tag name and namespace, from the current element.</Summary>
  Function [getElementsByTagNameNS]([parnamespaceURI] As Dynamic, [parlocalName] As Dynamic) As HTMLCollection
  '''<Summary>Returns a Boolean indicating if the element has the specified attribute or not.</Summary>
  Function [hasAttribute]([parname] As Dynamic) As HTMLElement
  '''<Summary>Returns a Boolean indicating if the element has the specified attribute, in the specified namespace, or not.</Summary>
  Function [hasAttributeNS]([parnamespace] As Dynamic,localName] As Dynamic) As HTMLElement
  '''<Summary>Returns a Boolean indicating if the element has one or more HTML attributes present.</Summary>
  Function [hasAttributes]() As HTMLElement
  '''<Summary>Indicates whether the element on which it is invoked has pointer capture for the pointer identified by the given pointer ID.</Summary>
  Function [hasPointerCapture]([parpointerId] As Dynamic) As HTMLElement
  '''<Summary>Inserts a given element node at a given position relative to the element it is invoked upon.</Summary>
  Function [insertAdjacentElement]([parposition] As Dynamic, [parelement] As Dynamic) As HTMLElement
  '''<Summary>Parses the text as HTML or XML and inserts the resulting nodes into the tree in the position given.</Summary>
  Function [insertAdjacentHTML]([parposition] As Dynamic, [partext] As Dynamic) As String
  '''<Summary>Inserts a given text node at a given position relative to the element it is invoked upon.</Summary>
  Function [insertAdjacentText]([parposition] As Dynamic, [parelement] As Dynamic) As HTMLElement
  '''<Summary>Returns the first Node which matches the specified selector string relative to the element.</Summary>
  Function [querySelector]([parselectors] As Dynamic) As Element
  '''<Summary>Returns a NodeList of nodes which match the specified selector string relative to the element.</Summary>
  Function [querySelectorAll]([parselectors] As Dynamic) As HTMLElement
  '''<Summary>Releases (stops) pointer capture that was previously set for a specific pointer event.</Summary>
  Sub [releasePointerCapture]([parpointerId] As Dynamic)
  '''<Summary>Removes the named attribute from the current node.</Summary>
  Sub [removeAttribute]([parattrName] As Dynamic)
  '''<Summary>Removes an event listener from the element.</Summary>
  Function [removeEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [paruseCapture] As Dynamic) As Dynamic
  '''<Summary>Sets the value of a named attribute of the current node.</Summary>
  Sub [setAttribute]([parname] As Dynamic, [parvalue] As Dynamic)
  '''<Summary>Designates a specific element as the capture target of future pointer events.</Summary>
  Sub [setPointerCapture]([parpointerId] As Dynamic)
  '''<Summary>Toggles a boolean attribute, removing it if it is present and adding it if it is not present, on the specified element.</Summary>
  Function [toggleAttribute]([parname] As Dynamic, [parforce] As Dynamic) As Boolean
End Interface