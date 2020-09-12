'''<Summary>This interface is a compiled XPath expression that can be evaluated on a document or specific node to return information from its DOM tree.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XPathExpression]
  '''<Summary>Evaluates the XPath expression on the given node or document.</Summary>
  Function [evaluate]([parcontextNode] As Dynamic, [partype] As Dynamic, [parresult] As Dynamic) As XPathResult
End Interface