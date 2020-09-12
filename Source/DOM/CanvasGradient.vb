'''<Summary>The CanvasGradient interface represents an opaque object describing a gradient. It is returned by the methods CanvasRenderingContext2D.createLinearGradient() or CanvasRenderingContext2D.createRadialGradient().</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [CanvasGradient]
  '''<Summary>Adds a new stop, defined by an offset and a color, to the gradient. If the offset is not between 0 and 1, inclusive, an INDEX_SIZE_ERR is raised; if the color can't be parsed as a CSS  CSS data type represents a color in the sRGB color space. A &lt;color> may also include an alpha-channel transparency value, indicating how the color should composite with its background.">&lt;color&gt;, a SYNTAX_ERR is raised.</Summary>
  Function [addColorStop]([paroffset] As Dynamic, [parcolor] As Dynamic) As CSS
End Interface