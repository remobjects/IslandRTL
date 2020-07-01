'''<Summary>The HTMLMapElement interface provides special properties and methods (beyond those of the regular object HTMLElement interface it also has available to it by inheritance) for manipulating the layout and presentation of map elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLMapElement]
Inherits HTMLElement

  '''<Summary>Is a DOMString representing the  element is used with &lt;area> elements to define an image map (a clickable link area).">&lt;map&gt; element for referencing it other context. If the id attribute is set, this must have the same value; and it cannot be null or empty.</Summary>
  Property [name] As String
  '''<Summary>Is a live HTMLCollection representing the  element defines a hot-spot region on an image, and optionally associates it with a hypertext link. This element is used only within a &lt;map> element.">&lt;area&gt; elements associated to this  element is used with &lt;area> elements to define an image map (a clickable link area).">&lt;map&gt;.</Summary>
  ReadOnly Property [areas] As HTMLCollection
End Interface