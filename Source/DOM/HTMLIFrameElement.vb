'''<summary>The HTMLIFrameElement interface provides special properties and methods (beyond those of the HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of inline frame elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLIFrameElement]
Inherits HTMLElement

  '''<summary>Is a Boolean indicating whether the Payment Request API may be invoked inside a cross-origin iframe.</summary>
  Property [allowPaymentRequest] As Boolean
  '''<summary>Returns a WindowProxy, the window proxy for the nested browsing context.</summary>
  ReadOnly Property [contentWindow] As Window
  '''<summary>Is a DOMString that reflects the height HTML attribute, indicating the height of the frame.</summary>
  Property [height] As Integer
  '''<summary>Is a DOMString that reflects the name HTML attribute, containing a name by which to refer to the frame.</summary>
  Property [name] As String
  '''<summary>Is a DOMSettableTokenList that reflects the sandbox HTML attribute, indicating extra restrictions on the behavior of the nested content.</summary>
  Property [sandbox] As DOMTokenList
  '''<summary>Is a DOMString that reflects the src HTML attribute, containing the address of the content to be embedded. Note that programatically removing an &lt;iframe&gt;'s src attribute (e.g. via Element.removeAttribute()) causes about:blank to be loaded in the frame in Firefox (from version 65), Chromium-based browsers, and Safari/iOS.</summary>
  Property [src] As String
  '''<summary>Is a DOMString that represents the content to display in the frame.</summary>
  Property [srcdoc] As String
  '''<summary>Is a DOMString that reflects the width HTML attribute, indicating the width of the frame.</summary>
  Property [width] As Integer
End Interface