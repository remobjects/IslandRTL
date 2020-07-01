'''<Summary>The TextMetrics interface represents the dimensions of a piece of text in the canvas; a textMetrics() instance can be retrieved using the CanvasRenderingContext2D.measureText() method.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [TextMetrics]
  '''<Summary>Is a double giving the calculated width of a segment of inline text in CSS pixels. It takes into account the current font of the context.</Summary>
  ReadOnly Property [width] As Integer
  '''<Summary>Is a double giving the distance from the alignment point given by the CanvasRenderingContext2D.textAlign property to the left side of the bounding rectangle of the given text, in CSS pixels. The distance is measured parallel to the baseline.</Summary>
  ReadOnly Property [actualBoundingBoxLeft] As Integer
  '''<Summary>Is a double giving the distance from the alignment point given by the CanvasRenderingContext2D.textAlign property to the right side of the bounding rectangle of the given text, in CSS pixels. The distance is measured parallel to the baseline.</Summary>
  ReadOnly Property [actualBoundingBoxRight] As Integer
  '''<Summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline attribute to the top of the highest bounding rectangle of all the fonts used to render the text, in CSS pixels.</Summary>
  ReadOnly Property [fontBoundingBoxAscent] As Integer
  '''<Summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline attribute to the bottom of the bounding rectangle of all the fonts used to render the text, in CSS pixels.</Summary>
  ReadOnly Property [fontBoundingBoxDescent] As Integer
  '''<Summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline attribute to the top of the bounding rectangle used to render the text, in CSS pixels.</Summary>
  ReadOnly Property [actualBoundingBoxAscent] As Integer
  '''<Summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline attribute to the bottom of the bounding rectangle used to render the text, in CSS pixels.</Summary>
  ReadOnly Property [actualBoundingBoxDescent] As Integer
  '''<Summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline property to the top of the em square in the line box, in CSS pixels.</Summary>
  ReadOnly Property [emHeightAscent] As Integer
  '''<Summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline property to the bottom of the em square in the line box, in CSS pixels.</Summary>
  ReadOnly Property [emHeightDescent] As Integer
  '''<Summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline property to the hanging baseline of the line box, in CSS pixels.</Summary>
  ReadOnly Property [hangingBaseline] As Integer
  '''<Summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline property to the alphabetic baseline of the line box, in CSS pixels.</Summary>
  ReadOnly Property [alphabeticBaseline] As Integer
  '''<Summary>Is a double giving the distance from the horizontal line indicated by the CanvasRenderingContext2D.textBaseline property to the ideographic baseline of the line box, in CSS pixels.</Summary>
  ReadOnly Property [ideographicBaseline] As Integer
End Interface