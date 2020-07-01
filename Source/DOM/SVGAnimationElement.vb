'''<Summary>The SVGAnimationElement interface is the base interface for all of the animation element interfaces: SVGAnimateElement, SVGSetElement, SVGAnimateColorElement, SVGAnimateMotionElement and SVGAnimateTransformElement.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [SVGAnimationElement]
Inherits SVGElement

  '''<Summary>An SVGElement representing the element which is being animated. If no target element is being animated (for example, because the href specifies an unknown element) the value returned is null.</Summary>
  ReadOnly Property [targetElement] As Element
End Interface