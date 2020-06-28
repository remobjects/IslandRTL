'''<Summary>The HTMLIFrameElement interface provides special properties and methods (beyond those of the HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of inline frame elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLIFrameElement]
Inherits HTMLElement

  '''<Summary>Is a Boolean indicating whether the Payment Request API may be invoked inside a cross-origin iframe.</Summary>
  Property [allowPaymentRequest] As Boolean
  '''<Summary>Returns a WindowProxy, the window proxy for the nested browsing context.</Summary>
  ReadOnly Property [contentWindow] As Window
  '''<Summary>Is a DOMString that reflects the height HTML attribute, indicating the height of the frame.</Summary>
  Property [height] As Integer
  '''<Summary>Is a DOMString that reflects the name HTML attribute, containing a name by which to refer to the frame.</Summary>
  Property [name] As String
  '''<Summary>Is a DOMSettableTokenList that reflects the sandbox HTML attribute, indicating extra restrictions on the behavior of the nested content.</Summary>
  Property [sandbox] As DOMTokenList
  '''<Summary>Is a DOMString that reflects the src HTML attribute, containing the address of the content to be embedded. Note that programatically removing an &lt;iframe&gt;'s src attribute (e.g. via Element.removeAttribute()) causes about:blank to be loaded in the frame in Firefox (from version 65), Chromium-based browsers, and Safari/iOS.</Summary>
  Property [src] As String
  '''<Summary>Is a DOMString that represents the content to display in the frame.</Summary>
  Property [srcdoc] As String
  '''<Summary>Is a DOMString that reflects the width HTML attribute, indicating the width of the frame.</Summary>
  Property [width] As Integer
End Interface