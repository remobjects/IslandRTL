'''<Summary>The HTMLModElement interface provides special properties (beyond the regular methods and properties available through the HTMLElement interface they also have available to them by inheritance) for manipulating modification elements, that is &lt;del> and &lt;ins>.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLModElement]
Inherits HTMLElement

  '''<Summary>Is a DOMString reflecting the cite HTML attribute, containing a URI of a resource explaining the change.</Summary>
  Property [cite] As String
  '''<Summary>Is a DOMString reflecting the datetime HTML attribute, containing a date-and-time string representing a timestamp for the change.</Summary>
  Property [dateTime] As DateTime
End Interface