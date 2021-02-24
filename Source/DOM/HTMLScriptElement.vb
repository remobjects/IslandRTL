'''<summary>HTML &lt;script> elements expose the HTMLScriptElement interface, which provides special properties and methods for manipulating the behavior and execution of &lt;script> elements (beyond the inherited HTMLElement interface).</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLScriptElement]
Inherits HTMLElement

  '''<summary>Is a DOMString representing the MIME type of the script. It reflects the type attribute.</summary>
  Property [type] As Dynamic
  '''<summary>Is a DOMString representing the URL of an external script. It reflects the src attribute.</summary>
  Property [src] As String
  '''<summary>Is a DOMString representing the character encoding of an external script. It reflects the charset attribute.</summary>
  Property [charset] As String
  '''<summary></summary>
  Property [text] As String
  '''<summary>Is a Boolean that if true, stops the script's execution in browsers that support ES2015 modules — used to run fallback scripts in older browsers that do not support JavaScript modules.</summary>
  Property [noModule] As Boolean
  '''<summary>Is a DOMString that reflects the referrerpolicy HTML attribute indicating which referrer to use when fetching the script, and fetches done by that script.</summary>
  Property [referrerPolicy] As Dynamic
End Interface