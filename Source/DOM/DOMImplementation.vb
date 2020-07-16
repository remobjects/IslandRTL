'''<Summary>The DOMImplementation interface represents an object providing methods which are not dependent on any particular document. Such an object is returned by the Document.implementation property.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [DOMImplementation]
  '''<Summary>Returns a Boolean indicating if a given feature is supported or not. This function is unreliable and kept for compatibility purpose alone: except for SVG-related queries, it always returns true. Old browsers are very inconsistent in their behavior.</Summary>
  Function [hasFeature]([parfeature] As Dynamic, [parversion] As Dynamic) As Boolean
End Interface