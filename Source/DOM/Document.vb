'''<Summary>Adopt node from an external document.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Document]
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