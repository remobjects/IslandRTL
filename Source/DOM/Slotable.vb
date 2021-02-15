'''<summary>The Slotable mixin defines features that allow nodes to become the contents of a &lt;slot> element — the following features are included in both Element and Text.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Slotable]
  '''<summary>Returns the  element—part of the Web Components technology suite—is a placeholder inside a web component that you can fill with your own markup, which lets you create separate DOM trees and present them together.">&lt;slot&gt; the node is inserted in.</summary>
  ReadOnly Property [assignedSlot] As HTMLElement
End Interface