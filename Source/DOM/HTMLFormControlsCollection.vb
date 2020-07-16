'''<Summary>The HTMLFormControlsCollection interface represents a collection of HTML form control elements. </Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLFormControlsCollection]
  '''<Summary>Returns the RadioNodeList or the Element in the collection whose name or id matches the specified name, or null if no nodes match. Note that this version of namedItem() hide the one inherited from HTMLCollection. Like that one, in JavaScript, using the array bracket syntax with a String, like collection["value"] is equivalent to collection.namedItem("value").</Summary>
  Function [namedItem]() As HTMLCollection
End Interface