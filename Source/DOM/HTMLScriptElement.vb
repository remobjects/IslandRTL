'''<Summary>HTML &lt;script> elements expose the HTMLScriptElement interface, which provides special properties and methods for manipulating the behavior and execution of &lt;script> elements (beyond the inherited HTMLElement interface).</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLScriptElement]
Inherits HTMLElement

  '''<Summary>Is a DOMString representing the MIME type of the script. It reflects the type attribute.</Summary>
  Property [type] As Dynamic
  '''<Summary>Is a DOMString representing the URL of an external script. It reflects the src attribute.</Summary>
  Property [src] As String
  '''<Summary>Is a DOMString representing the character encoding of an external script. It reflects the charset attribute.</Summary>
  Property [charset] As String
  '''<Summary></Summary>
  Property [text] As String
  '''<Summary>Is a Boolean that if true, stops the script's execution in browsers that support ES2015 modules — used to run fallback scripts in older browsers that do not support JavaScript modules.</Summary>
  Property [noModule] As Boolean
  '''<Summary>Is a DOMString that reflects the referrerpolicy HTML attribute indicating which referrer to use when fetching the script, and fetches done by that script.</Summary>
  Property [referrerPolicy] As Dynamic
End Interface