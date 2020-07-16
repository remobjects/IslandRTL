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
  '''<Summary>Adopt node from an external document.</Summary>
  Function [adoptNode]([parexternalNode] As Dynamic) As Node
  '''<Summary>Creates a new Attr object and returns it.</Summary>
  Function [createAttribute]([parname] As Dynamic) As Dynamic
  '''<Summary>Creates a new attribute node in a given namespace and returns it.</Summary>
  Function [createAttributeNS]() As Dynamic
  '''<Summary>Creates a new CDATA node and returns it.</Summary>
  Function [createCDATASection]([pardata] As Dynamic) As CDATASection
  '''<Summary>Creates a new comment node and returns it.</Summary>
  Function [createComment]([pardata] As Dynamic) As Comment
  '''<Summary>Creates a new document fragment.</Summary>
  Function [createDocumentFragment]() As Document
  '''<Summary>Creates a new element with the given tag name.</Summary>
  Function [createElement]([partagName] As Dynamic, [paroptions] As Dynamic) As Element
  '''<Summary>Creates a new element with the given tag name.</Summary>
  Function [createElement]([tagName] As Dynamic) As Element
  '''<Summary>Creates a new element with the given tag name and namespace URI.</Summary>
  Function [createElementNS]([parnamespaceURI] As Dynamic, [parqualifiedName] As Dynamic, [paroptions] As Dynamic) As Element
  '''<Summary>Creates an event object.</Summary>
  Function [createEvent]([partype] As Dynamic) As [Event]
  '''<Summary>Creates a NodeIterator object.</Summary>
  Function [createNodeIterator]([parroot] As Dynamic, [parwhatToShow] As Dynamic, [parfilter] As Dynamic) As Node
  '''<Summary>Creates a new ProcessingInstruction object.</Summary>
  Function [createProcessingInstruction]() As ProcessingInstruction
  '''<Summary>Creates a Range object.</Summary>
  Function [createRange]() As Range
  '''<Summary>Creates a text node.</Summary>
  Function [createTextNode]([pardata] As Dynamic) As Node
  '''<Summary>Creates a TouchList object.</Summary>
  Function [createTouchList]([partouches] As Dynamic) As TouchList
  '''<Summary>Creates a TreeWalker object.</Summary>
  Function [createTreeWalker]([parroot] As Dynamic, [parwhatToShow] As Dynamic, [parfilter] As Dynamic, [parentityReferenceExpansion] As Dynamic) As TreeWalker
  '''<Summary>Enables the style sheets for the specified style sheet set.</Summary>
  Function [enableStyleSheetsForSet]([parname] As Dynamic) As Dynamic
  '''<Summary>Returns a list of elements with the given class name.</Summary>
  Function [getElementsByClassName]([parnames] As Dynamic) As Element()
  '''<Summary>Returns a list of elements with the given tag name.</Summary>
  Function [getElementsByTagName]([parname] As Dynamic) As Element()
  '''<Summary>Returns a list of elements with the given tag name and namespace.</Summary>
  Function [getElementsByTagNameNS]([parnamespace] As Dynamic, [parname] As Dynamic) As Element()
  '''<Summary>Returns a clone of a node from an external document.</Summary>
  Function [importNode]([parexternalNode] As Dynamic, [pardeep] As Dynamic) As Node
  '''<Summary>Returns an object reference to the identified element.</Summary>
  Function [getElementById]([parid] As Dynamic) As Dynamic
  '''<Summary>Returns the first Element node within the document, in document order, that matches the specified selectors.</Summary>
  Function [querySelector]([parselectors] As Dynamic) As Element
  '''<Summary>Returns a list of all the Element nodes within the document that match the specified selectors.</Summary>
  Function [querySelectorAll]([parselectors] As Dynamic) As HTMLElement
  '''<Summary>Compiles an XPathExpression which can then be used for (repeated) evaluations.</Summary>
  Function [createExpression]() As Dynamic
  '''<Summary>Creates an XPathNSResolver object.</Summary>
  Function [createNSResolver]() As XPathNSResolver
  '''<Summary>Evaluates an XPath expression.</Summary>
  Function [evaluate]([parxpathExpression] As Dynamic, [parcontextNode] As Dynamic, [parnamespaceResolver] As Dynamic, [parresultType] As Dynamic, [parresult] As Dynamic) As Dynamic
  '''<Summary>Closes a document stream for writing.</Summary>
  Function [close]() As Dynamic
  '''<Summary>On an editable document, executes a formating command.</Summary>
  Function [execCommand]([paraCommandName] As Dynamic, [paraShowDefaultUI] As Dynamic, [paraValueArgument] As Dynamic) As Dynamic
  '''<Summary>Returns a list of elements with the given name.</Summary>
  Function [getElementsByName]([parname] As Dynamic) As Element()
  '''<Summary>Returns true if the focus is currently located anywhere inside the specified document.</Summary>
  Function [hasFocus]() As Boolean
  '''<Summary>Opens a document stream for writing.</Summary>
  Function [open]() As Dynamic
  '''<Summary>Returns true if the formating command can be executed on the current range.</Summary>
  Function [queryCommandEnabled]() As Boolean
  '''<Summary>Returns true if the formating command is in an indeterminate state on the current range.</Summary>
  Function [queryCommandIndeterm]() As Boolean
  '''<Summary>Returns true if the formating command has been executed on the current range.</Summary>
  Function [queryCommandState]([parcommand] As Dynamic) As Boolean
  '''<Summary>Returns true if the formating command is supported on the current range.</Summary>
  Function [queryCommandSupported]() As Boolean
  '''<Summary>Returns the current value of the current range for a formating command.</Summary>
  Function [queryCommandValue]() As Dynamic
  '''<Summary>Writes text in a document.</Summary>
  Function [write]([parmarkup] As Dynamic) As Dynamic
  '''<Summary>Writes a line of text in a document.</Summary>
  Function [writeln]([parline] As Dynamic) As Dynamic
  '''<Summary>Returns the topmost element at the specified coordinates.</Summary>
  Function [elementFromPoint]([parx] As Dynamic, [pary] As Dynamic) As Dynamic
End Interface