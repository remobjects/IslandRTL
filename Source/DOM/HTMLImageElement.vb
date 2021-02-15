'''<summary>The HTMLImageElement interface represents an HTML &lt;img> element, providing the properties and methods used to manipulate image elements.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLImageElement]
Inherits HTMLElement

  '''<summary>A DOMString that reflects the alt HTML attribute, thus indicating the alternate fallback content to be displayed if the image has not been loaded.</summary>
  Property [alt] As String
  '''<summary>Returns a Boolean that is true if the browser has finished fetching the image, whether successful or not. That means this value is also true if the image has no src value indicating an image to load.</summary>
  ReadOnly Property [complete] As Boolean
  '''<summary>A DOMString specifying the CORS setting for this image element. See CORS settings attributes for further details. This may be null if CORS is not used.</summary>
  Property [crossOrigin] As String
  '''<summary>Returns a USVString representing the URL from which the currently displayed image was loaded. This may change as the image is adjusted due to changing conditions, as directed by any media queries which are in place.</summary>
  ReadOnly Property [currentSrc] As String
  '''<summary>An optional DOMString representing a hint given to the browser on how it should decode the image. If this value is provided, it must be one of the possible permitted values: sync to decode the image synchronously, async to decode it asynchronously, or auto to indicate no preference (which is the default). Read the decoding page for details on the implications of this property's values.</summary>
  Property [decoding] As String
  '''<summary>An integer value that reflects the height HTML attribute, indicating the rendered height of the image in CSS pixels.</summary>
  Property [height] As Integer
  '''<summary>A Boolean that reflects the ismap HTML attribute, indicating that the image is part of a server-side image map. This is different from a client-side image map, specified using an &lt;img&gt; element and a corresponding  element is used with &lt;area> elements to define an image map (a clickable link area).">&lt;map&gt; which contains  element defines a hot-spot region on an image, and optionally associates it with a hypertext link. This element is used only within a &lt;map> element.">&lt;area&gt; elements indicating the clickable areas in the image. The image must be contained within an  element (or anchor element), with its href attribute, creates a hyperlink to web pages, files, email addresses, locations in the same page, or anything else a URL can address.">&lt;a&gt; element; see the ismap page for details.</summary>
  Property [isMap] As Boolean
  '''<summary>A DOMString providing a hint to the browser used to optimize loading the document by determining whether to load the image immediately (eager) or on an as-needed basis (lazy).</summary>
  Property [loading] As String
  '''<summary>Returns an integer value representing the intrinsic height of the image in CSS pixels, if it is available; else, it shows 0. This is the height the image would be if it were rendered at its natural full size.</summary>
  ReadOnly Property [naturalHeight] As Integer
  '''<summary>An integer value representing the intrinsic width of the image in CSS pixels, if it is available; otherwise, it will show 0. This is the width the image would be if it were rendered at its natural full size.</summary>
  ReadOnly Property [naturalWidth] As Integer
  '''<summary>A DOMString that reflects the referrerpolicy HTML attribute, which tells the user agent how to decide which referrer to use in order to fetch the image. Read this article for details on the possible values of this string.</summary>
  Property [referrerPolicy] As Dynamic
  '''<summary>A DOMString reflecting the sizes HTML attribute. This string specifies a list of comma-separated conditional sizes for the image; that is, for a given viewport size, a particular image size is to be used. Read the documentation on the sizes page for details on the format of this string.</summary>
  Property [sizes] As Dynamic
  '''<summary>A USVString that reflects the src HTML attribute, which contains the full URL of the image including base URI. You can load a different image into the element by changing the URL in the src attribute.</summary>
  Property [src] As String
  '''<summary>A USVString reflecting the srcset HTML attribute. This specifies a list of candidate images, separated by commas (',', U+002C COMMA). Each candidate image is a URL followed by a space, followed by a specially-formatted string indicating the size of the image. The size may be specified either the width or a size multiple. Read the srcset page for specifics on the format of the size substring.</summary>
  Property [srcset] As String
  '''<summary>A DOMString reflecting the usemap HTML attribute, containing the page-local URL of the  element is used with &lt;area> elements to define an image map (a clickable link area).">&lt;map&gt; element describing the image map to use. The page-local URL is a pound (hash) symbol (#) followed by the ID of the &lt;map&gt; element, such as #my-map-element. The &lt;map&gt; in turn contains  element defines a hot-spot region on an image, and optionally associates it with a hypertext link. This element is used only within a &lt;map> element.">&lt;area&gt; elements indicating the clickable areas in the image.</summary>
  Property [useMap] As String
  '''<summary>An integer value that reflects the width HTML attribute, indicating the rendered width of the image in CSS pixels.</summary>
  Property [width] As Integer
  '''<summary>An integer indicating the horizontal offset of the left border edge of the image's CSS layout box relative to the origin of the  element represents the root (top-level element) of an HTML document, so it is also referred to as the root element. All other elements must be descendants of this element.">&lt;html&gt; element's containing block.</summary>
  ReadOnly Property [x] As Double
  '''<summary>The integer vertical offset of the top border edge of the image's CSS layout box relative to the origin of the  element represents the root (top-level element) of an HTML document, so it is also referred to as the root element. All other elements must be descendants of this element.">&lt;html&gt; element's containing block.</summary>
  ReadOnly Property [y] As Double
  '''<summary>Returns a Promise that resolves when the image is decoded and it's safe to append the image to the DOM. This prevents rendering of the next frame from having to pause to decode the image, as would happen if an undecoded image were added to the DOM.</summary>
  Function [decode]() As Dynamic
End Interface