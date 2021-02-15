'''<summary>The DocumentType interface represents a Node containing a doctype.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DocumentType]
Inherits Node

  '''<summary>A DOMString, eg "html" for &lt;!DOCTYPE HTML&gt;.</summary>
  ReadOnly Property [name] As String
  '''<summary>A DOMString, eg "-//W3C//DTD HTML 4.01//EN", empty string for HTML5.</summary>
  ReadOnly Property [publicId] As Integer
  '''<summary>A DOMString, eg "http://www.w3.org/TR/html4/strict.dtd", empty string for HTML5.</summary>
  ReadOnly Property [systemId] As Integer
End Interface