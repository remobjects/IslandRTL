'''<Summary>The DocumentType interface represents a Node containing a doctype.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DocumentType]
Inherits RemObjects.Elements.WebAssembly.DOM.Node

  '''<Summary>A DOMString, eg "html" for &lt;!DOCTYPE HTML&gt;.</Summary>
  ReadOnly Property [name] As String
  '''<Summary>A DOMString, eg "-//W3C//DTD HTML 4.01//EN", empty string for HTML5.</Summary>
  ReadOnly Property [publicId] As Integer
  '''<Summary>A DOMString, eg "http://www.w3.org/TR/html4/strict.dtd", empty string for HTML5.</Summary>
  ReadOnly Property [systemId] As Integer
End Interface