'''<Summary>The SVGScriptElement interface corresponds to the SVG &lt;script> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGScriptElement]
'Defined on this type 
  '''<Summary>A DOMString corresponding to the type attribute of the given &lt;script&gt; element. A DOMException is raised with the code NO_MODIFICATION_ALLOWED_ERR on an attempt to change the value of a read only attribut.</Summary>
  ReadOnly Property [type] As Dynamic
  '''<Summary>A DOMString corresponding to the crossorigin attribute of the given &lt;script&gt; element.</Summary>
  ReadOnly Property [crossOrigin] As String
End Interface