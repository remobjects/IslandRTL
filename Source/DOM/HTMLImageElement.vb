'''<Summary>The HTMLImageElement interface represents an HTML &lt;img> element, providing the properties and methods used to manipulate image elements.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [HTMLImageElement]
'Defined on this type 
  '''<Summary>A DOMString that reflects the alt HTML attribute, thus indicating the alternate fallback content to be displayed if the image has not been loaded.</Summary>
  Property [alt] As String
  '''<Summary>Returns a Boolean that is true if the browser has finished fetching the image, whether successful or not. That means this value is also true if the image has no src value indicating an image to load.</Summary>
  ReadOnly Property [complete] As Boolean
  '''<Summary>A DOMString specifying the CORS setting for this image element. See CORS settings attributes for further details. This may be null if CORS is not used.</Summary>
  Property [crossOrigin] As String
  '''<Summary>Returns a USVString representing the URL from which the currently displayed image was loaded. This may change as the image is adjusted due to changing conditions, as directed by any media queries which are in place.</Summary>
  ReadOnly Property [currentSrc] As String
  '''<Summary>An optional DOMString representing a hint given to the browser on how it should decode the image. If this value is provided, it must be one of the possible permitted values: sync to decode the image synchronously, async to decode it asynchronously, or auto to indicate no preference (which is the default). Read the decoding page for details on the implications of this property's values.</Summary>
  Property [decoding] As String
  '''<Summary>An integer value that reflects the height HTML attribute, indicating the rendered height of the image in CSS pixels.</Summary>
  Property [height] As Integer
  '''<Summary>A Boolean that reflects the ismap HTML attribute, indicating that the image is part of a server-side image map. This is different from a client-side image map, specified using an &lt;img&gt; element and a corresponding  element is used with &lt;area> elements to define an image map (a clickable link area).">&lt;map&gt; which contains  element defines a hot-spot region on an image, and optionally associates it with a hypertext link. This element is used only within a &lt;map> element.">&lt;area&gt; elements indicating the clickable areas in the image. The image must be contained within an  element (or anchor element), with its href attribute, creates a hyperlink to web pages, files, email addresses, locations in the same page, or anything else a URL can address.">&lt;a&gt; element; see the ismap page for details.</Summary>
  Property [isMap] As Boolean
  '''<Summary>A DOMString providing a hint to the browser used to optimize loading the document by determining whether to load the image immediately (eager) or on an as-needed basis (lazy).</Summary>
  Property [loading] As String
  '''<Summary>Returns an integer value representing the intrinsic height of the image in CSS pixels, if it is available; else, it shows 0. This is the height the image would be if it were rendered at its natural full size.</Summary>
  ReadOnly Property [naturalHeight] As Integer
  '''<Summary>An integer value representing the intrinsic width of the image in CSS pixels, if it is available; otherwise, it will show 0. This is the width the image would be if it were rendered at its natural full size.</Summary>
  ReadOnly Property [naturalWidth] As Integer
  '''<Summary>A DOMString that reflects the referrerpolicy HTML attribute, which tells the user agent how to decide which referrer to use in order to fetch the image. Read this article for details on the possible values of this string.</Summary>
  Property [referrerPolicy] As Dynamic
  '''<Summary>A DOMString reflecting the sizes HTML attribute. This string specifies a list of comma-separated conditional sizes for the image; that is, for a given viewport size, a particular image size is to be used. Read the documentation on the sizes page for details on the format of this string.</Summary>
  Property [sizes] As Dynamic
  '''<Summary>A USVString that reflects the src HTML attribute, which contains the full URL of the image including base URI. You can load a different image into the element by changing the URL in the src attribute.</Summary>
  Property [src] As String
  '''<Summary>A USVString reflecting the srcset HTML attribute. This specifies a list of candidate images, separated by commas (',', U+002C COMMA). Each candidate image is a URL followed by a space, followed by a specially-formatted string indicating the size of the image. The size may be specified either the width or a size multiple. Read the srcset page for specifics on the format of the size substring.</Summary>
  Property [srcset] As String
  '''<Summary>A DOMString reflecting the usemap HTML attribute, containing the page-local URL of the  element is used with &lt;area> elements to define an image map (a clickable link area).">&lt;map&gt; element describing the image map to use. The page-local URL is a pound (hash) symbol (#) followed by the ID of the &lt;map&gt; element, such as #my-map-element. The &lt;map&gt; in turn contains  element defines a hot-spot region on an image, and optionally associates it with a hypertext link. This element is used only within a &lt;map> element.">&lt;area&gt; elements indicating the clickable areas in the image.</Summary>
  Property [useMap] As String
  '''<Summary>An integer value that reflects the width HTML attribute, indicating the rendered width of the image in CSS pixels.</Summary>
  Property [width] As Integer
  '''<Summary>An integer indicating the horizontal offset of the left border edge of the image's CSS layout box relative to the origin of the  element represents the root (top-level element) of an HTML document, so it is also referred to as the root element. All other elements must be descendants of this element.">&lt;html&gt; element's containing block.</Summary>
  ReadOnly Property [x] As Double
  '''<Summary>The integer vertical offset of the top border edge of the image's CSS layout box relative to the origin of the  element represents the root (top-level element) of an HTML document, so it is also referred to as the root element. All other elements must be descendants of this element.">&lt;html&gt; element's containing block.</Summary>
  ReadOnly Property [y] As Double
  '''<Summary>Returns a Promise that resolves when the image is decoded and it's safe to append the image to the DOM. This prevents rendering of the next frame from having to pause to decode the image, as would happen if an undecoded image were added to the DOM.</Summary>
  Function [decode]() As Dynamic
End Interface