'''<summary>The SVGScriptElement interface corresponds to the SVG &lt;script> element.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGScriptElement]
  '''<summary>A DOMString corresponding to the type attribute of the given &lt;script&gt; element. A DOMException is raised with the code NO_MODIFICATION_ALLOWED_ERR on an attempt to change the value of a read only attribut.</summary>
  ReadOnly Property [type] As Dynamic
  '''<summary>A DOMString corresponding to the crossorigin attribute of the given &lt;script&gt; element.</summary>
  ReadOnly Property [crossOrigin] As String
End Interface