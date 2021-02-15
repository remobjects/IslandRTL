'''<summary>Element is the most general base class from which all element objects (i.e. objects that represent elements) in a Document inherit. It only has methods and properties common to all kinds of elements. More specific classes inherit from Element.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Element]
Inherits Node

  '''<summary>Returns a NamedNodeMap object containing the assigned attributes of the corresponding HTML element.</summary>
  ReadOnly Property [attributes] As NamedNodeMap
  '''<summary>Returns a DOMTokenList containing the list of class attributes.</summary>
  ReadOnly Property [classList] As DOMTokenList
  '''<summary>Is a DOMString representing the class of the element.</summary>
  Property [className] As String
  '''<summary>Returns a Number representing the inner height of the element.</summary>
  ReadOnly Property [clientHeight] As Integer
  '''<summary>Returns a Number representing the width of the left border of the element.</summary>
  ReadOnly Property [clientLeft] As HTMLElement
  '''<summary>Returns a Number representing the width of the top border of the element.</summary>
  ReadOnly Property [clientTop] As HTMLElement
  '''<summary>Returns a Number representing the inner width of the element.</summary>
  ReadOnly Property [clientWidth] As Integer
  '''<summary>Returns a DOMString containing the label exposed to accessibility.</summary>
  ReadOnly Property [computedName] As String
  '''<summary>Returns a DOMString containing the ARIA role that has been applied to a particular element.</summary>
  ReadOnly Property [computedRole] As String
  '''<summary>Is a DOMString representing the id of the element.</summary>
  Property [id] As String
  '''<summary>Is a DOMString representing the markup of the element's content.</summary>
  Property [innerHTML] As String
  '''<summary>A DOMString representing the local part of the qualified name of the element.</summary>
  ReadOnly Property [localName] As String
  '''<summary>The namespace URI of the element, or null if it is no namespace.</summary>
  ReadOnly Property [namespaceURI] As String
  '''<summary>Is a DOMString representing the markup of the element including its content. When used as a setter, replaces the element with nodes parsed from the given string.</summary>
  Property [outerHTML] As String
  '''<summary>Represents the part identifier(s) of the element (i.e. set using the part attribute), returned as a DOMTokenList.</summary>
  Property [part] As DOMTokenList
  '''<summary>A DOMString representing the namespace prefix of the element, or null if no prefix is specified.</summary>
  ReadOnly Property [prefix] As String
  '''<summary>Returns a Number representing the scroll view height of an element.</summary>
  ReadOnly Property [scrollHeight] As Integer
  '''<summary>Is a Number representing the left scroll offset of the element.</summary>
  Property [scrollLeft] As HTMLElement
  '''<summary>A Number representing number of pixels the top of the document is scrolled vertically.</summary>
  Property [scrollTop] As Integer
  '''<summary>Returns a Number representing the scroll view width of the element.</summary>
  ReadOnly Property [scrollWidth] As Integer
  '''<summary>Returns the open shadow root that is hosted by the element, or null if no open shadow root is present.</summary>
  ReadOnly Property [shadowRoot] As HTMLElement
  '''<summary>Returns a String with the name of the tag for the given element.</summary>
  ReadOnly Property [tagName] As String
  '''<summary>An event handler for the fullscreenchange event, which is sent when the element enters or exits full-screen mode. This can be used to watch both for successful expected transitions, but also to watch for unexpected changes, such as when your app is running in the background.</summary>
  Property [onfullscreenchange] As Dynamic
  '''<summary>An event handler for the fullscreenerror event, which is sent when an error occurs while attempting to change into full-screen mode.</summary>
  Property [onfullscreenerror] As Dynamic
  '''<summary>Registers an event handler to a specific event type on the element.</summary>
  Sub [addEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [parcapture] As Dynamic, [paronce] As Dynamic, [parpassive] As Dynamic)
  '''<summary>Attaches a shadow DOM tree to the specified element and returns a reference to its ShadowRoot.</summary>
  Function [attachShadow]([parshadowRootInit] As Dynamic, [parmode] As Dynamic, [pardelegatesFocus] As Dynamic) As ShadowRoot
  '''<summary>Dispatches an event to this node in the DOM and returns a Boolean that indicates whether no handler canceled the event.</summary>
  Function [dispatchEvent]([parevent] As Dynamic) As Dynamic
  '''<summary>Retrieves the value of the attribute with the specified name, from the current node and returns it as an Object.</summary>
  Function [getAttribute]([parname] As Dynamic) As String
  '''<summary>Retrieves the value of the attribute with the specified name and namespace, from the current node and returns it as an Object.</summary>
  Function [getAttributeNS]([parnamespace] As Dynamic, [parname] As Dynamic) As String
  '''<summary>Returns the size of an element and its position relative to the viewport.</summary>
  Function [getBoundingClientRect]() As DOMRect
  '''<summary>Returns a collection of rectangles that indicate the bounding rectangles for each line of text in a client.</summary>
  Function [getClientRects]() As DOMRect
  '''<summary>Returns a live HTMLCollection that contains all descendants of the current element that possess the list of classes given in the parameter.</summary>
  Function [getElementsByClassName]([parnames] As Dynamic) As HTMLCollection
  '''<summary>Returns a live HTMLCollection containing all descendant elements, of a particular tag name, from the current element.</summary>
  Function [getElementsByTagName]([partagName] As Dynamic) As HTMLCollection
  '''<summary>Returns a live HTMLCollection containing all descendant elements, of a particular tag name and namespace, from the current element.</summary>
  Function [getElementsByTagNameNS]([parnamespaceURI] As Dynamic, [parlocalName] As Dynamic) As HTMLCollection
  '''<summary>Returns a Boolean indicating if the element has the specified attribute or not.</summary>
  Function [hasAttribute]([parname] As Dynamic) As HTMLElement
  '''<summary>Returns a Boolean indicating if the element has the specified attribute, in the specified namespace, or not.</summary>
  Function [hasAttributeNS]([parnamespace] As Dynamic,localName] As Dynamic) As HTMLElement
  '''<summary>Returns a Boolean indicating if the element has one or more HTML attributes present.</summary>
  Function [hasAttributes]() As HTMLElement
  '''<summary>Indicates whether the element on which it is invoked has pointer capture for the pointer identified by the given pointer ID.</summary>
  Function [hasPointerCapture]([parpointerId] As Dynamic) As HTMLElement
  '''<summary>Inserts a given element node at a given position relative to the element it is invoked upon.</summary>
  Function [insertAdjacentElement]([parposition] As Dynamic, [parelement] As Dynamic) As HTMLElement
  '''<summary>Parses the text as HTML or XML and inserts the resulting nodes into the tree in the position given.</summary>
  Function [insertAdjacentHTML]([parposition] As Dynamic, [partext] As Dynamic) As String
  '''<summary>Inserts a given text node at a given position relative to the element it is invoked upon.</summary>
  Function [insertAdjacentText]([parposition] As Dynamic, [parelement] As Dynamic) As HTMLElement
  '''<summary>Returns the first Node which matches the specified selector string relative to the element.</summary>
  Function [querySelector]([parselectors] As Dynamic) As Element
  '''<summary>Returns a NodeList of nodes which match the specified selector string relative to the element.</summary>
  Function [querySelectorAll]([parselectors] As Dynamic) As HTMLElement
  '''<summary>Releases (stops) pointer capture that was previously set for a specific pointer event.</summary>
  Sub [releasePointerCapture]([parpointerId] As Dynamic)
  '''<summary>Removes the named attribute from the current node.</summary>
  Sub [removeAttribute]([parattrName] As Dynamic)
  '''<summary>Removes an event listener from the element.</summary>
  Function [removeEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [paruseCapture] As Dynamic) As Dynamic
  '''<summary>Sets the value of a named attribute of the current node.</summary>
  Sub [setAttribute]([parname] As Dynamic, [parvalue] As Dynamic)
  '''<summary>Designates a specific element as the capture target of future pointer events.</summary>
  Sub [setPointerCapture]([parpointerId] As Dynamic)
  '''<summary>Toggles a boolean attribute, removing it if it is present and adding it if it is not present, on the specified element.</summary>
  Function [toggleAttribute]([parname] As Dynamic, [parforce] As Dynamic) As Boolean
End Interface