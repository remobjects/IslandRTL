'''<Summary>The SVGRect represents a rectangle. Rectangles consist of an x and y coordinate pair identifying a minimum x value, a minimum y value, and a width and height, which are constrained to be non-negative.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGRect]
'Defined on this type 
  '''<Summary>The exact effect of this coordinate depends on each element. If the attribute is not specified, the effect is as if a value of 0 were specified.</Summary>
  Property [x] As Dynamic
  '''<Summary>The exact effect of this coordinate depends on each element.If the attribute is not specified, the effect is as if a value of 0 were specified.</Summary>
  Property [y] As Dynamic
  '''<Summary>This represents the width of the rectangle.A value that is negative results to an error. A value of zero disables rendering of the element</Summary>
  Property [width] As Integer
End Interface