'''<summary>The HTMLSourceElement interface provides special properties (beyond the regular HTMLElement object interface it also has available to it by inheritance) for manipulating &lt;source> elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLSourceElement]
Inherits HTMLElement

  '''<summary>Is a DOMString reflecting the media HTML attribute, containing the intended type of the media resource.</summary>
  Property [media] As Dynamic
  '''<summary>Is a DOMString reflecting the src HTML attribute, containing the URL for the media resource. The HTMLSourceElement.src property has a meaning only when the associated  element specifies multiple media resources for the &lt;picture>, the &lt;audio> element, or the &lt;video> element.">&lt;source&gt; element is nested in a media element that is a ) embeds a media player which supports video playback into the document. You can use &lt;video> for audio content as well, but the &lt;audio> element may provide a more appropriate user experience.">&lt;video&gt; or an  element is used to embed sound content in documents. It may contain one or more audio sources, represented using the src attribute or the &lt;source> element: the browser will choose the most suitable one. It can also be the destination for streamed media, using a MediaStream.">&lt;audio&gt; element. It has no meaning and is ignored when it is nested in a  element contains zero or more &lt;source> elements and one &lt;img> element to offer alternative versions of an image for different display/device scenarios.">&lt;picture&gt; element. </summary>
  Property [src] As String
  '''<summary>Is a DOMString reflecting the type HTML attribute, containing the type of the media resource.</summary>
  Property [type] As Dynamic
End Interface