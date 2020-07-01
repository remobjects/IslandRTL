'''<Summary>The Document interface represents any web page loaded in the browser and serves as an entry point into the web page's content, which is the DOM tree.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Document]
  '''<Summary>Returns a list of all of the anchors in the document.</Summary>
  ReadOnly Property [anchors] As Dynamic
  '''<Summary>Returns the  Element represents the content of an HTML document. There can be only one &lt;body> element in a document.">&lt;body&gt; or  element is used to contain &lt;frame> elements.">&lt;frameset&gt; node of the current document.</Summary>
  Property [body] As HTMLElement
  '''<Summary>Returns the character set being used by the document.</Summary>
  ReadOnly Property [characterSet] As String
  '''<Summary>Returns the Document Type Definition (DTD) of the current document.</Summary>
  ReadOnly Property [doctype] As Dynamic
  '''<Summary>Returns the Element that is a direct child of the document. For HTML documents, this is normally the HTMLHtmlElement object representing the document's  element represents the root (top-level element) of an HTML document, so it is also referred to as the root element. All other elements must be descendants of this element.">&lt;html&gt; element.</Summary>
  ReadOnly Property [documentElement] As Element
  '''<Summary>Returns the document location as a string.</Summary>
  ReadOnly Property [documentURI] As String
  '''<Summary>Returns a list of the embedded  element embeds external content at the specified point in the document. This content is provided by an external application or other source of interactive content such as a browser plug-in.">&lt;embed&gt; elements within the current document.</Summary>
  ReadOnly Property [embeds] As Element()
  '''<Summary>Returns the FontFaceSet interface of the current document.</Summary>
  Property [fonts] As Dynamic
  '''<Summary>Returns a list of the  element represents a document section containing interactive controls for submitting information.">&lt;form&gt; elements within the current document.</Summary>
  ReadOnly Property [forms] As HTMLElement()
  '''<Summary>Returns the  element contains machine-readable information (metadata) about the document, like its title, scripts, and style sheets.">&lt;head&gt; element of the current document.</Summary>
  ReadOnly Property [head] As HTMLElement
  '''<Summary>Returns a Boolean value indicating if the page is considered hidden or not.</Summary>
  ReadOnly Property [hidden] As Boolean
  '''<Summary>Returns a list of the images in the current document.</Summary>
  ReadOnly Property [images] As Dynamic
  '''<Summary>Returns the DOM implementation associated with the current document.</Summary>
  ReadOnly Property [implementation] As String
  '''<Summary>Returns the name of the style sheet set that was last enabled. Has the value null until the style sheet is changed by setting the value of selectedStyleSheetSet.</Summary>
  ReadOnly Property [lastStyleSheetSet] As String
  '''<Summary>Returns a list of all the hyperlinks in the document.</Summary>
  ReadOnly Property [links] As Dynamic
  '''<Summary>Returns a list of the available plugins.</Summary>
  ReadOnly Property [plugins] As Dynamic
  '''<Summary>Returns the preferred style sheet set as specified by the page author.</Summary>
  ReadOnly Property [preferredStyleSheetSet] As String
  '''<Summary>Returns all the  element is used to embed or reference executable code; this is typically used to embed or refer to JavaScript code.">&lt;script&gt; elements on the document.</Summary>
  ReadOnly Property [scripts] As HTMLElement
  '''<Summary>Returns a reference to the Element that scrolls the document.</Summary>
  ReadOnly Property [scrollingElement] As Element
  '''<Summary>Returns which style sheet set is currently in use.</Summary>
  Property [selectedStyleSheetSet] As String
  '''<Summary>Returns a list of the style sheet sets available on the document.</Summary>
  ReadOnly Property [styleSheetSets] As String()
  '''<Summary>Returns a string denoting the visibility state of the document. Possible values are visible, hidden, prerender, and unloaded.</Summary>
  ReadOnly Property [visibilityState] As String
  '''<Summary>Returns a semicolon-separated list of the cookies for that document or sets a single cookie.</Summary>
  Property [cookie] As Dynamic
  '''<Summary>Returns a reference to the window object.</Summary>
  ReadOnly Property [defaultView] As Window
  '''<Summary>Gets/sets the ability to edit the whole document.</Summary>
  Property [designMode] As Dynamic
  '''<Summary>Gets/sets directionality (rtl/ltr) of the document.</Summary>
  ReadOnly Property [dir] As Dynamic
  '''<Summary>Gets/sets the domain of the current document.</Summary>
  Property [domain] As Dynamic
  '''<Summary>Returns the date on which the document was last modified.</Summary>
  ReadOnly Property [lastModified] As Date
  '''<Summary>Returns the URI of the current document.</Summary>
  ReadOnly Property [location] As Dynamic
  '''<Summary>Returns loading status of the document.</Summary>
  ReadOnly Property [readyState] As Dynamic
  '''<Summary>Returns the URI of the page that linked to this page.</Summary>
  ReadOnly Property [referrer] As Dynamic
  '''<Summary>Sets or gets the title of the current document.</Summary>
  Property [title] As String
  '''<Summary>Returns the document location as a string.</Summary>
  ReadOnly Property [URL] As String
  '''<Summary>The element that's currently in full screen mode for this document.</Summary>
  ReadOnly Property [fullscreenElement] As Element
  '''<Summary>Is an EventHandler representing the code to be called when the fullscreenchange event is raised.</Summary>
  Property [onfullscreenchange] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the fullscreenerror event is raised.</Summary>
  Property [onfullscreenerror] As EventListener
  '''<Summary>Represents the event handling code for the readystatechange event.</Summary>
  Property [onreadystatechange] As EventListener
  '''<Summary>Is an EventHandler representing the code to be called when the visibilitychange event is raised.</Summary>
  Property [onvisibilitychange] As EventListener
End Interface