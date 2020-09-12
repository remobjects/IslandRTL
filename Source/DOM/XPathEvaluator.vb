'''<Summary>The XPathEvaluator interface allows to compile and evaluate XPath expressions.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XPathEvaluator]
  '''<Summary>Creates a parsed XPath expression with resolved namespaces.</Summary>
  Function [createExpression]([parexpression] As Dynamic, [parresolver] As Dynamic) As XPathExpression
  '''<Summary>Adapts any DOM node to resolve namespaces allowing the XPath expression to be evaluated relative to the context of the node where it appeared within the document.</Summary>
  Function [createNSResolver]([parnodeResolver] As Dynamic) As XPathNSResolver
  '''<Summary>Evaluates an XPath expression string and returns a result of the specified type if possible.</Summary>
  Function [evaluate]([parexpression] As Dynamic, [parcontextNode] As Dynamic, [parresolver] As Dynamic, [partype] As Dynamic, [parresult] As Dynamic) As XPathResult
End Interface