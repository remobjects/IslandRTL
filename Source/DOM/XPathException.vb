'''<Summary>In the DOM XPath API the XPathException interface represents exception conditions that can be encountered while performing XPath operations.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [XPathException]
  '''<Summary>Returns a short that contains one of the error code constants.</Summary>
  ReadOnly Property [code] As short
End Interface