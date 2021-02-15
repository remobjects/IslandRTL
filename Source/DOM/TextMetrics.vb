'''<summary>The TextMetrics interface represents the dimensions of a piece of text in the canvas; a textMetrics() instance can be retrieved using the CanvasRenderingContext2D.measureText() method.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TextMetrics]
  '''<summary>Is a double giving the calculated width of a segment of inline text in CSS pixels. It takes into account the current font of the context.</summary>
  ReadOnly Property [width] As Integer
  '''<summary>Is a double giving the distance from the alignment point given by the CanvasRenderingContext2D.textAlign property to the left side of the bounding rectangle of the given text, in CSS pixels. The distance is measured parallel to the baseline.</summary>
  ReadOnly Property [actualBoundingBoxLeft] As Integer
  '''<summary>Is a double giving the distance from the alignment point given by the CanvasRenderingContext2D.textAlign property to the right side of the bounding rectangle of the given text, in CSS pixels. The distance is measured parallel to the baseline.</summary>
  ReadOnly Property [actualBoundingBoxRight] As Integer
  '''<summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline attribute to the top of the highest bounding rectangle of all the fonts used to render the text, in CSS pixels.</summary>
  ReadOnly Property [fontBoundingBoxAscent] As Integer
  '''<summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline attribute to the bottom of the bounding rectangle of all the fonts used to render the text, in CSS pixels.</summary>
  ReadOnly Property [fontBoundingBoxDescent] As Integer
  '''<summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline attribute to the top of the bounding rectangle used to render the text, in CSS pixels.</summary>
  ReadOnly Property [actualBoundingBoxAscent] As Integer
  '''<summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline attribute to the bottom of the bounding rectangle used to render the text, in CSS pixels.</summary>
  ReadOnly Property [actualBoundingBoxDescent] As Integer
  '''<summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline property to the top of the em square in the line box, in CSS pixels.</summary>
  ReadOnly Property [emHeightAscent] As Integer
  '''<summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline property to the bottom of the em square in the line box, in CSS pixels.</summary>
  ReadOnly Property [emHeightDescent] As Integer
  '''<summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline property to the hanging baseline of the line box, in CSS pixels.</summary>
  ReadOnly Property [hangingBaseline] As Integer
  '''<summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline property to the alphabetic baseline of the line box, in CSS pixels.</summary>
  ReadOnly Property [alphabeticBaseline] As Integer
  '''<summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline property to the ideographic baseline of the line box, in CSS pixels.</summary>
  ReadOnly Property [ideographicBaseline] As Integer
End Interface