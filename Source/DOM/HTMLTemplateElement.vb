'''<Summary>The HTMLTemplateElement interface enables access to the contents of an HTML &lt;template> element.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLTemplateElement]
  '''<Summary>A read-only DocumentFragment which contains the DOM subtree representing the ) element is a mechanism for holding HTML that is not to be rendered immediately when a page is loaded but may be instantiated subsequently during runtime using JavaScript.">&lt;template&gt; element's template contents.</Summary>
  ReadOnly Property [content] As DocumentFragment
End Interface