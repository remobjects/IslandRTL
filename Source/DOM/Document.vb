'''<summary>The Document interface represents any web page loaded in the browser and serves as an entry point into the web page's content, which is the DOM tree.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface Document
  '''<summary>Returns a list of all of the anchors in the document.</summary>
  ReadOnly Property anchors As Dynamic
  '''<summary>Returns the  Element represents the content of an HTML document. There can be only one &lt;body> element in a document.">&lt;body&gt; or  element is used to contain &lt;frame> elements.">&lt;frameset&gt; node of the current document.</summary>
  Property body As HTMLElement
  '''<summary>Returns the character set being used by the document.</summary>
  ReadOnly Property characterSet As String
  '''<summary>Returns the Document Type Definition (DTD) of the current document.</summary>
  ReadOnly Property doctype As Dynamic
  '''<summary>Returns the Element that is a direct child of the document. For HTML documents, this is normally the HTMLHtmlElement object representing the document's  element represents the root (top-level element) of an HTML document, so it is also referred to as the root element. All other elements must be descendants of this element.">&lt;html&gt; element.</summary>
  ReadOnly Property documentElement As Element
  '''<summary>Returns the document location as a string.</summary>
  ReadOnly Property documentURI As String
  '''<summary>Returns a list of the embedded  element embeds external content at the specified point in the document. This content is provided by an external application or other source of interactive content such as a browser plug-in.">&lt;embed&gt; elements within the current document.</summary>
  ReadOnly Property embeds As HTMLCollection
  '''<summary>Returns the FontFaceSet interface of the current document.</summary>
  Property fonts As Dynamic
  '''<summary>Returns a list of the  element represents a document section containing interactive controls for submitting information.">&lt;form&gt; elements within the current document.</summary>
  ReadOnly Property forms As HTMLCollection
  '''<summary>Returns the  element contains machine-readable information (metadata) about the document, like its title, scripts, and style sheets.">&lt;head&gt; element of the current document.</summary>
  ReadOnly Property head As HTMLElement
  '''<summary>Returns a Boolean value indicating if the page is considered hidden or not.</summary>
  ReadOnly Property hidden As Boolean
  '''<summary>Returns a list of the images in the current document.</summary>
  ReadOnly Property images As Dynamic
  '''<summary>Returns the DOM implementation associated with the current document.</summary>
  ReadOnly Property implementation As String
  '''<summary>Returns the name of the style sheet set that was last enabled. Has the value null until the style sheet is changed by setting the value of selectedStyleSheetSet.</summary>
  ReadOnly Property lastStyleSheetSet As String
  '''<summary>Returns a list of all the hyperlinks in the document.</summary>
  ReadOnly Property links As Dynamic
  '''<summary>Returns a list of the available plugins.</summary>
  ReadOnly Property plugins As Dynamic
  '''<summary>Returns the preferred style sheet set as specified by the page author.</summary>
  ReadOnly Property preferredStyleSheetSet As String
  '''<summary>Returns all the  element is used to embed or reference executable code; this is typically used to embed or refer to JavaScript code.">&lt;script&gt; elements on the document.</summary>
  ReadOnly Property scripts As HTMLElement
  '''<summary>Returns a reference to the Element that scrolls the document.</summary>
  ReadOnly Property scrollingElement As Element
  '''<summary>Returns which style sheet set is currently in use.</summary>
  Property selectedStyleSheetSet As String
  '''<summary>Returns a list of the style sheet sets available on the document.</summary>
  ReadOnly Property styleSheetSets As String()
  '''<summary>Returns a string denoting the visibility state of the document. Possible values are visible, hidden, prerender, and unloaded.</summary>
  ReadOnly Property visibilityState As String
  '''<summary>Returns a semicolon-separated list of the cookies for that document or sets a single cookie.</summary>
  Property cookie As Dynamic
  '''<summary>Returns a reference to the window object.</summary>
  ReadOnly Property defaultView As Window
  '''<summary>Gets/sets the ability to edit the whole document.</summary>
  Property designMode As Dynamic
  '''<summary>Gets/sets directionality (rtl/ltr) of the document.</summary>
  ReadOnly Property dir As String
  '''<summary>Gets/sets the domain of the current document.</summary>
  Property domain As String
  '''<summary>Returns the date on which the document was last modified.</summary>
  ReadOnly Property lastModified As DateTime
  '''<summary>Returns the URI of the current document.</summary>
  ReadOnly Property location As Dynamic
  '''<summary>Returns loading status of the document.</summary>
  ReadOnly Property readyState As Dynamic
  '''<summary>Returns the URI of the page that linked to this page.</summary>
  ReadOnly Property referrer As String
  '''<summary>Sets or gets the title of the current document.</summary>
  Property title As String
  '''<summary>Returns the document location as a string.</summary>
  ReadOnly Property URL As String
  '''<summary>The element that's currently in full screen mode for this document.</summary>
  ReadOnly Property fullscreenElement As Element
  '''<summary>Is an EventHandler representing the code to be called when the fullscreenchange event is raised.</summary>
  Property onfullscreenchange As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the fullscreenerror event is raised.</summary>
  Property onfullscreenerror As EventListener
  '''<summary>Represents the event handling code for the readystatechange event.</summary>
  Property onreadystatechange As EventListener
  '''<summary>Is an EventHandler representing the code to be called when the visibilitychange event is raised.</summary>
  Property onvisibilitychange As EventListener
  '''<summary>Adopt node from an external document.</summary>
  Function adoptNode(parexternalNode As Dynamic) As Node
  '''<summary>Creates a new Attr object and returns it.</summary>
  Function createAttribute(parname As Dynamic) As Dynamic
  '''<summary>Creates a new attribute node in a given namespace and returns it.</summary>
  Function createAttributeNS() As Dynamic
  '''<summary>Creates a new CDATA node and returns it.</summary>
  Function createCDATASection(pardata As Dynamic) As CDATASection
  '''<summary>Creates a new comment node and returns it.</summary>
  Function createComment(pardata As Dynamic) As Comment
  '''<summary>Creates a new document fragment.</summary>
  Function createDocumentFragment() As Document
  '''<summary>Creates a new element with the given tag name.</summary>
  Function createElement(partagName As Dynamic, paroptions As Dynamic) As Element
  '''<summary>Creates a new element with the given tag name.</summary>
  Function createElement(tagName As Dynamic) As Element
  '''<summary>Creates a new element with the given tag name and namespace URI.</summary>
  Function createElementNS(parnamespaceURI As Dynamic, parqualifiedName As Dynamic, paroptions As Dynamic) As Element
  '''<summary>Creates an event object.</summary>
  Function createEvent(partype As Dynamic) As [Event]
  '''<summary>Creates a NodeIterator object.</summary>
  Function createNodeIterator(parroot As Dynamic, parwhatToShow As Dynamic, parfilter As Dynamic) As Node
  '''<summary>Creates a new ProcessingInstruction object.</summary>
  Function createProcessingInstruction() As ProcessingInstruction
  '''<summary>Creates a Range object.</summary>
  Function createRange() As Range
  '''<summary>Creates a text node.</summary>
  Function createTextNode(pardata As Dynamic) As Node
  '''<summary>Creates a TouchList object.</summary>
  Function createTouchList(partouches As Dynamic) As TouchList
  '''<summary>Creates a TreeWalker object.</summary>
  Function createTreeWalker(parroot As Dynamic, parwhatToShow As Dynamic, parfilter As Dynamic, parentityReferenceExpansion As Dynamic) As TreeWalker
  '''<summary>Enables the style sheets for the specified style sheet set.</summary>
  Function enableStyleSheetsForSet(parname As Dynamic) As Dynamic
  '''<summary>Returns a list of elements with the given class name.</summary>
  Function getElementsByClassName(parnames As Dynamic) As HTMLCollection
  '''<summary>Returns a list of elements with the given tag name.</summary>
  Function getElementsByTagName(parname As Dynamic) As HTMLCollection
  '''<summary>Returns a list of elements with the given tag name and namespace.</summary>
  Function getElementsByTagNameNS(parnamespace As Dynamic, parname As Dynamic) As HTMLCollection
  '''<summary>Returns a clone of a node from an external document.</summary>
  Function importNode(parexternalNode As Dynamic, pardeep As Dynamic) As Node
  '''<summary>Returns an object reference to the identified element.</summary>
  Function getElementById(parid As Dynamic) As Dynamic
  '''<summary>Returns the first Element node within the document, in document order, that matches the specified selectors.</summary>
  Function querySelector(parselectors As Dynamic) As Element
  '''<summary>Returns a list of all the Element nodes within the document that match the specified selectors.</summary>
  Function querySelectorAll(parselectors As Dynamic) As HTMLElement
  '''<summary>Compiles an XPathExpression which can then be used for (repeated) evaluations.</summary>
  Function createExpression() As Dynamic
  '''<summary>Creates an XPathNSResolver object.</summary>
  Function createNSResolver() As XPathNSResolver
  '''<summary>Evaluates an XPath expression.</summary>
  Function evaluate(parxpathExpression As Dynamic, parcontextNode As Dynamic, parnamespaceResolver As Dynamic, parresultType As Dynamic, parresult As Dynamic) As Dynamic
  '''<summary>Closes a document stream for writing.</summary>
  Function close() As Dynamic
  '''<summary>On an editable document, executes a formating command.</summary>
  Function execCommand(paraCommandName As Dynamic, paraShowDefaultUI As Dynamic, paraValueArgument As Dynamic) As Dynamic
  '''<summary>Returns a list of elements with the given name.</summary>
  Function getElementsByName(parname As Dynamic) As HTMLCollection
  '''<summary>Returns true if the focus is currently located anywhere inside the specified document.</summary>
  Function hasFocus() As Boolean
  '''<summary>Opens a document stream for writing.</summary>
  Function open() As Dynamic
  '''<summary>Returns true if the formating command can be executed on the current range.</summary>
  Function queryCommandEnabled() As Boolean
  '''<summary>Returns true if the formating command is in an indeterminate state on the current range.</summary>
  Function queryCommandIndeterm() As Boolean
  '''<summary>Returns true if the formating command has been executed on the current range.</summary>
  Function queryCommandState(parcommand As Dynamic) As Boolean
  '''<summary>Returns true if the formating command is supported on the current range.</summary>
  Function queryCommandSupported() As Boolean
  '''<summary>Returns the current value of the current range for a formating command.</summary>
  Function queryCommandValue() As Dynamic
  '''<summary>Writes text in a document.</summary>
  Function write(parmarkup As Dynamic) As Dynamic
  '''<summary>Writes a line of text in a document.</summary>
  Function writeln(parline As Dynamic) As Dynamic
  '''<summary>Returns the topmost element at the specified coordinates.</summary>
  Function elementFromPoint(parx As Dynamic, pary As Dynamic) As Dynamic
End Interface