'''<summary>The DOM Node interface is a key base class upon which many other DOM API objects are based, thus letting those object types to be used similarly and often interchangeably.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Node]
Inherits EventTarget

  '''<summary>Returns a DOMString representing the base URL of the document containing the Node.</summary>
  ReadOnly Property [baseURI] As String
  '''<summary>Returns a live NodeList containing all the children of this node. NodeList being live means that if the children of the Node change, the NodeList object is automatically updated.</summary>
  ReadOnly Property [childNodes] As Node
  '''<summary>Returns a Node representing the first direct child node of the node, or null if the node has no child.</summary>
  ReadOnly Property [firstChild] As Node
  '''<summary>A boolean indicating whether or not the Node is connected (directly or indirectly) to the context object, e.g. the Document object in the case of the normal DOM, or the ShadowRoot in the case of a shadow DOM.</summary>
  ReadOnly Property [isConnected] As Boolean
  '''<summary>Returns a Node representing the last direct child node of the node, or null if the node has no child.</summary>
  ReadOnly Property [lastChild] As Node
  '''<summary>Returns a Node representing the next node in the tree, or null if there isn't such node.</summary>
  ReadOnly Property [nextSibling] As Node
  '''<summary>Returns a DOMString containing the name of the Node. The structure of the name will differ with the node type. E.g. An HTMLElement will contain the name of the corresponding tag, like 'audio' for an HTMLAudioElement, a Text node will have the '#text' string, or a Document node will have the '#document' string.</summary>
  ReadOnly Property [nodeName] As Node
  '''<summary>Returns / Sets the value of the current node.</summary>
  Property [nodeValue] As Node
  '''<summary>Returns the Document that this node belongs to. If the node is itself a document, returns null.</summary>
  ReadOnly Property [ownerDocument] As Document
  '''<summary>Returns a Node that is the parent of this node. If there is no such node, like if this node is the top of the tree or if doesn't participate in a tree, this property returns null.</summary>
  ReadOnly Property [parentNode] As Node
  '''<summary>Returns an Element that is the parent of this node. If the node has no parent, or if that parent is not an Element, this property returns null.</summary>
  ReadOnly Property [parentElement] As Element
  '''<summary>Returns a Node representing the previous node in the tree, or null if there isn't such node.</summary>
  ReadOnly Property [previousSibling] As Node
  '''<summary>Returns / Sets the textual content of an element and all its descendants.</summary>
  Property [textContent] As String
  '''<summary>Adds the specified childNode argument as the last child to the current node. If the argument referenced an existing node on the DOM tree, the node will be detached from its current position and attached at the new position.</summary>
  Function [appendChild]([paraChild] As Dynamic) As Node
  '''<summary>Clone a Node, and optionally, all of its contents. By default, it clones the content of the node.</summary>
  Function [cloneNode]([par[pardeep]] As Dynamic) As Node
  '''<summary>Compares the position of the current node against another node in any other document.</summary>
  Function [compareDocumentPosition]([parotherNode] As Dynamic) As Integer
  '''<summary>Returns a Boolean value indicating whether or not a node is a descendant of the calling node.</summary>
  Function [contains]([parotherNode] As Dynamic) As Boolean
  '''<summary>Returns the context object's root which optionally includes the shadow root if it is available. </summary>
  Function [getRootNode]([paroptions] As Dynamic) As Node
  '''<summary>Returns a Boolean indicating whether or not the element has any child nodes.</summary>
  Function [hasChildNodes]() As Node
  '''<summary>Inserts a Node before the reference node as a child of a specified parent node.</summary>
  Function [insertBefore]([parnewNode] As Dynamic, [parreferenceNode] As Dynamic) As Node
  '''<summary>Accepts a namespace URI as an argument and returns a Boolean with a value of true if the namespace is the default namespace on the given node or false if not.</summary>
  Function [isDefaultNamespace]() As Boolean
  '''<summary>Returns a Boolean which indicates whether or not two nodes are of the same type and all their defining data points match.</summary>
  Function [isEqualNode]([parotherNode] As Node) As Node
  '''<summary>Returns a Boolean value indicating whether or not the two nodes are the same (that is, they reference the same object).</summary>
  Function [isSameNode]() As Node
  '''<summary>Accepts a prefix and returns the namespace URI associated with it on the given node if found (and null if not). Supplying null for the prefix will return the default namespace.</summary>
  Sub [lookupNamespaceURI]([parprefix] As Dynamic)
  '''<summary>Clean up all the text nodes under this element (merge adjacent, remove empty).</summary>
  Function [normalize]() As String
  '''<summary>Replaces one child Node of the current one with the second one given in parameter.</summary>
  Function [replaceChild]([parnewChild] As Dynamic, [paroldChild] As Dynamic) As Node
End Interface