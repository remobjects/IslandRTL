'''<Summary>The HTMLTimeElement interface provides special properties (beyond the regular HTMLElement interface it also has available to it by inheritance) for manipulating &lt;time> elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLTimeElement]
Inherits HTMLElement

  '''<Summary>Is a DOMString that reflects the datetime HTML attribute, containing a machine-readable form of the element's date and time value.</Summary>
  Property [dateTime] As DateTime
End Interface