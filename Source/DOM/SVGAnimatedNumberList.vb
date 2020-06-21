'''<Summary>The SVGAnimatedNumber interface is used for attributes which take a list of numbers and which can be animated.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGAnimatedNumberList]
'Defined on this type 
  '''<Summary>Is a read only SVGNumberList that represents the current animated value of the given attribute. If the given attribute is not currently being animated, then the SVGNumberList will have the same contents as baseVal. The object referenced by animVal will always be distinct from the one referenced by baseVal, even when the attribute is not animated.</Summary>
  ReadOnly Property [animVal] As Dynamic
End Interface