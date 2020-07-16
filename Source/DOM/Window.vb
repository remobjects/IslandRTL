'''<Summary>The Window interface represents a window containing a DOM document; the document property points to the DOM document loaded in that window.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Window]
  '''<Summary>Returns a reference to the console object which provides access to the browser's debugging console.</Summary>
  ReadOnly Property [console] As Dynamic
  '''<Summary>returns a reference to the CustomElementRegistry object, which can be used to register new custom elements and get information about previously registered custom elements.</Summary>
  ReadOnly Property [customElements] As Dynamic
  '''<Summary>Returns the browser crypto object.</Summary>
  ReadOnly Property [crypto] As Dynamic
  '''<Summary>Gets the arguments passed to the window (if it's a dialog box) at the time window.showModalDialog() was called. This is an nsIArray.</Summary>
  ReadOnly Property [dialogArguments] As Dynamic
  '''<Summary>Returns a reference to the document that the window contains.</Summary>
  ReadOnly Property [document] As Document
  '''<Summary>Returns the current event, which is the event currently being handled by the JavaScript code's context, or undefined if no event is currently being handled. The Event object passed directly to event handlers should be used instead whenever possible.</Summary>
  ReadOnly Property [event] As Dynamic
  '''<Summary>Returns the element in which the window is embedded, or null if the window is not embedded.</Summary>
  ReadOnly Property [frameElement] As Element
  '''<Summary>Returns an array of the subframes in the current window.</Summary>
  ReadOnly Property [frames] As Document()
  '''<Summary>This property indicates whether the window is displayed in full screen or not.</Summary>
  Property [fullScreen] As Dynamic
  '''<Summary>Returns a reference to the history object.</Summary>
  ReadOnly Property [history] As Dynamic
  '''<Summary>Gets the height of the content area of the browser window including, if rendered, the horizontal scrollbar.</Summary>
  ReadOnly Property [innerHeight] As Integer
  '''<Summary>Gets the width of the content area of the browser window including, if rendered, the vertical scrollbar.</Summary>
  ReadOnly Property [innerWidth] As Integer
  '''<Summary>Returns the number of frames in the window. See also window.frames.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Gets/sets the location, or current URL, of the window object.</Summary>
  Property [location] As Dynamic
  '''<Summary>Returns the locationbar object, whose visibility can be toggled in the window.</Summary>
  ReadOnly Property [locationbar] As Dynamic
  '''<Summary>Returns a reference to the local storage object used to store data that may only be accessed by the origin that created it.</Summary>
  ReadOnly Property [localStorage] As Dynamic
  '''<Summary>Returns the menubar object, whose visibility can be toggled in the window.</Summary>
  ReadOnly Property [menubar] As Dynamic
  '''<Summary>Returns the message manager object for this window.</Summary>
  Property [messageManager] As Dynamic
  '''<Summary>Gets/sets the name of the window.</Summary>
  Property [name] As String
  '''<Summary>Returns a reference to the navigator object.</Summary>
  ReadOnly Property [navigator] As Dynamic
  '''<Summary>Returns a reference to the window that opened this current window.</Summary>
  Property [opener] As Dynamic
  '''<Summary>Gets the height of the outside of the browser window.</Summary>
  ReadOnly Property [outerHeight] As Integer
  '''<Summary>Gets the width of the outside of the browser window.</Summary>
  ReadOnly Property [outerWidth] As Integer
  '''<Summary>Returns a reference to the parent of the current window or subframe.</Summary>
  ReadOnly Property [parent] As Dynamic
  '''<Summary>Returns a Performance object, which includes the timing and navigation attributes, each of which is an object providing performance-related data. See also Using Navigation Timing for additional information and examples.</Summary>
  ReadOnly Property [performance] As Dynamic
  '''<Summary>Returns the personalbar object, whose visibility can be toggled in the window.</Summary>
  ReadOnly Property [personalbar] As Dynamic
  '''<Summary>Returns a reference to the screen object associated with the window.</Summary>
  ReadOnly Property [screen] As Dynamic
  '''<Summary>Both properties return the horizontal distance from the left border of the user's browser viewport to the left side of the screen.</Summary>
  ReadOnly Property [screenX] As Dynamic
  '''<Summary>Both properties return the vertical distance from the top border of the user's browser viewport to the top side of the screen.</Summary>
  ReadOnly Property [screenY] As Dynamic
  '''<Summary>Returns the scrollbars object, whose visibility can be toggled in the window.</Summary>
  ReadOnly Property [scrollbars] As Dynamic
  '''<Summary>Returns the number of pixels that the document has already been scrolled horizontally.</Summary>
  ReadOnly Property [scrollX] As Integer
  '''<Summary>Returns the number of pixels that the document has already been scrolled vertically.</Summary>
  ReadOnly Property [scrollY] As Integer
  '''<Summary>Returns a reference to the session storage object used to store data that may only be accessed by the origin that created it.</Summary>
  Property [sessionStorage] As Dynamic
  '''<Summary>Gets/sets the text in the statusbar at the bottom of the browser.</Summary>
  Property [status] As String
  '''<Summary>Returns the statusbar object, whose visibility can be toggled in the window.</Summary>
  ReadOnly Property [statusbar] As Dynamic
  '''<Summary>Returns the toolbar object, whose visibility can be toggled in the window.</Summary>
  ReadOnly Property [toolbar] As Dynamic
  '''<Summary>Returns a reference to the topmost window in the window hierarchy. This property is read only.</Summary>
  ReadOnly Property [top] As Dynamic
  '''<Summary>Returns a VisualViewport object which represents the visual viewport for a given window.</Summary>
  ReadOnly Property [visualViewport] As Dynamic
  '''<Summary>Returns a reference to the current window.</Summary>
  ReadOnly Property [window] As Dynamic
  '''<Summary>Returns the CacheStorage object associated with the current context. This object enables functionality such as storing assets for offline use, and generating custom responses to requests.</Summary>
  ReadOnly Property [caches] As Dynamic
  '''<Summary>Provides a mechanism for applications to asynchronously access capabilities of indexed databases; returns an IDBFactory object.</Summary>
  ReadOnly Property [indexedDB] As Dynamic
  '''<Summary>Returns a boolean indicating whether the current context is secure (true) or not (false).</Summary>
  ReadOnly Property [isSecureContext] As Boolean
  '''<Summary>Returns the global object's origin, serialized as a string. (This does not yet appear to be implemented in any browser.)</Summary>
  ReadOnly Property [origin] As String
  '''<Summary>Called when the page is installed as a webapp. See appinstalled event.</Summary>
  Property [onappinstalled] As EventListener
  '''<Summary>An event handler property dispatched before a user is prompted to save a web site to a home screen on mobile.</Summary>
  Property [onbeforeinstallprompt] As EventListener
  '''<Summary>An event handler property for any ambient light levels changes</Summary>
  Property [ondevicelight] As EventListener
  '''<Summary>Called if accelerometer detects a change (For mobile devices)</Summary>
  Property [ondevicemotion] As EventListener
  '''<Summary>Called when the orientation is changed (For mobile devices)</Summary>
  Property [ondeviceorientation] As EventListener
  '''<Summary>An event handler property for device proximity event</Summary>
  Property [ondeviceproximity] As EventListener
  '''<Summary>Represents an event handler that will run when a gamepad is connected (when the gamepadconnected event fires).</Summary>
  Property [ongamepadconnected] As EventListener
  '''<Summary>Represents an event handler that will run when a gamepad is disconnected (when the gamepaddisconnected event fires).</Summary>
  Property [ongamepaddisconnected] As EventListener
  '''<Summary>An event handler property for the MozBeforePaint event, which is sent before repainting the window if the event has been requested by a call to the Window.mozRequestAnimationFrame() method.</Summary>
  Property [onmozbeforepaint] As EventListener
  '''<Summary>An event handler property for paint events on the window.</Summary>
  Property [onpaint] As EventListener
  '''<Summary>An event handler property for user proximity events.</Summary>
  Property [onuserproximity] As EventListener
  '''<Summary>Represents an event handler that will run when a compatible VR device has been connected to the computer (when the vrdisplayconnected event fires).</Summary>
  Property [onvrdisplayconnect] As EventListener
  '''<Summary>Represents an event handler that will run when a compatible VR device has been disconnected from the computer (when the vrdisplaydisconnected event fires).</Summary>
  Property [onvrdisplaydisconnect] As EventListener
  '''<Summary>Represents an event handler that will run when a display is able to be presented to (when the vrdisplayactivate event fires), for example if an HMD has been moved to bring it out of standby, or woken up by being put on.</Summary>
  Property [onvrdisplayactivate] As EventListener
  '''<Summary>Represents an event handler that will run when a display can no longer be presented to (when the vrdisplaydeactivate event fires), for example if an HMD has gone into standby or sleep mode due to a period of inactivity.</Summary>
  Property [onvrdisplaydeactivate] As EventListener
  '''<Summary>Represents an event handler that will run when presentation to a display has been paused for some reason by the browser, OS, or VR hardware (when the vrdisplayblur event fires) — for example, while the user is interacting with a system menu or browser, to prevent tracking or loss of experience.</Summary>
  Property [onvrdisplayblur] As EventListener
  '''<Summary>Represents an event handler that will run when presentation to a display has resumed after being blurred (when the vrdisplayfocus event fires).</Summary>
  Property [onvrdisplayfocus] As EventListener
  '''<Summary>represents an event handler that will run when the presenting state of a VR device changes — i.e. goes from presenting to not presenting, or vice versa (when the vrdisplaypresentchange event fires).</Summary>
  Property [onvrdisplaypresentchange] As EventListener
  '''<Summary>Displays an alert dialog.</Summary>
  Function [alert]([parmessage] As Dynamic) As Dynamic
  '''<Summary>Sets focus away from the window.</Summary>
  Function [blur]() As Dynamic
  '''<Summary>Cancels the repeated execution set using setImmediate.</Summary>
  Function [clearImmediate]([parimmediateID] As Dynamic) As Dynamic
  '''<Summary>Closes the current window.</Summary>
  Function [close]() As Dynamic
  '''<Summary>Displays a dialog with a message that the user needs to respond to.</Summary>
  Function [confirm]([parmessage] As Dynamic) As Dynamic
  '''<Summary>Searches for a given string in a window.</Summary>
  Function [find]([parparaString] As Dynamic, [paraCaseSensitive] As Dynamic, [paraBackwards] As Dynamic, [paraWrapAround] As Dynamic, [paraWholeWord] As Dynamic, [paraSearchInFrames] As Dynamic, [paraShowDialog] As Dynamic) As String
  '''<Summary>Sets focus on the current window.</Summary>
  Function [focus]() As Dynamic
  '''<Summary>Gets computed style for the specified element. Computed style indicates the computed values of all CSS properties of the element.</Summary>
  Function [getComputedStyle]([parelement] As Dynamic) As HTMLElement
  '''<Summary>Returns the selection object representing the selected item(s).</Summary>
  Function [getSelection]() As Dynamic
  '''<Summary>Returns a MediaQueryList object representing the specified media query string.</Summary>
  Function [matchMedia]([parmediaQueryString] As Dynamic) As Dynamic
  '''<Summary>FIXME: NeedsContents</Summary>
  Function [maximize]() As Dynamic
  '''<Summary>Minimizes the window.</Summary>
  Function [minimize]() As Dynamic
  '''<Summary>Moves the current window by a specified amount.</Summary>
  Function [moveBy]() As Dynamic
  '''<Summary>Moves the window to the specified coordinates.</Summary>
  Function [moveTo]() As Dynamic
  '''<Summary>Opens a new window.</Summary>
  Function [open]([parurl] As Dynamic, [parwindowName] As Dynamic, [parwindowFeatures] As Dynamic) As Dynamic
  '''<Summary>Provides a secure means for one window to send a string of data to another window, which need not be within the same domain as the first.</Summary>
  Function [postMessage]([parmessage] As Dynamic, [partargetOrigin] As Dynamic, [partransfer]] As Dynamic) As String
  '''<Summary>Opens the Print Dialog to print the current document.</Summary>
  Function [print]() As Dynamic
  '''<Summary>Returns the text entered by the user in a prompt dialog.</Summary>
  Function [prompt]([parmessage] As Dynamic, [pardefault] As Dynamic) As String
  '''<Summary>Tells the browser that an animation is in progress, requesting that the browser schedule a repaint of the window for the next animation frame.</Summary>
  Function [requestAnimationFrame]([parcallback] As Dynamic) As Dynamic
  '''<Summary>Resizes the current window by a certain amount.</Summary>
  Function [resizeBy]() As Dynamic
  '''<Summary>Dynamically resizes window.</Summary>
  Function [resizeTo]([parwidth] As Dynamic, [parheight] As Dynamic) As Dynamic
  '''<Summary>Scrolls the window to a particular place in the document.</Summary>
  Function [scroll]() As Dynamic
  '''<Summary>Scrolls the document in the window by the given amount.</Summary>
  Function [scrollBy]() As Dynamic
  '''<Summary>Scrolls to a particular set of coordinates in the document.</Summary>
  Function [scrollTo]() As Dynamic
  '''<Summary>Executes a function after the browser has finished other heavy tasks</Summary>
  Function [setImmediate]([parparfunc] As Dynamic, [parparparam1] As Dynamic, [parparparam2] As Dynamic) As Dynamic
  '''<Summary>This method stops window loading.</Summary>
  Function [stop]() As Dynamic
  '''<Summary>Register an event handler to a specific event type on the window.</Summary>
  Function [addEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [parcapture] As Dynamic, [paronce] As Dynamic, [parpassive] As Dynamic) As Dynamic
  '''<Summary>Used to trigger an event.</Summary>
  Function [dispatchEvent]([parevent] As Dynamic) As Dynamic
  '''<Summary>Decodes a string of data which has been encoded using base-64 encoding.</Summary>
  Function [atob]([parencodedData] As Dynamic) As String
  '''<Summary>Creates a base-64 encoded ASCII string from a string of binary data.</Summary>
  Function [btoa]([parstringToEncode] As Dynamic) As String
  '''<Summary>Cancels the repeated execution set using WindowOrWorkerGlobalScope.setInterval().</Summary>
  Function [clearInterval]([parintervalID] As Dynamic) As Dynamic
  '''<Summary>Cancels the delayed execution set using WindowOrWorkerGlobalScope.setTimeout().</Summary>
  Function [clearTimeout]([partimeoutID] As Dynamic) As Dynamic
  '''<Summary>Accepts a variety of different image sources, and returns a Promise which resolves to an ImageBitmap. Optionally the source is cropped to the rectangle of pixels originating at (sx, sy) with width sw, and height sh.</Summary>
  Function [createImageBitmap]([parimage] As Dynamic, [parsx] As Dynamic, [parsy] As Dynamic, [parsw] As Dynamic, [parsh] As Dynamic, [paroptions] As Dynamic) As Integer
  '''<Summary>Starts the process of fetching a resource from the network.</Summary>
  Function [fetch]([parresource] As Dynamic, [parinit] As Dynamic, [parmethod] As Dynamic, [parheaders] As Dynamic, [parbody] As Dynamic, [parmode] As Dynamic, [parcredentials] As Dynamic, [parcache] As Dynamic, [parredirect] As Dynamic, [parreferrer] As Dynamic, [parreferrerPolicy] As Dynamic, [parintegrity] As Dynamic, [parkeepalive] As Dynamic, [parsignal] As Dynamic) As Dynamic
  '''<Summary>Removes an event listener from the window.</Summary>
  Function [removeEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [paruseCapture] As Dynamic) As Dynamic
  '''<Summary>Schedules a function to execute every time a given number of milliseconds elapses.</Summary>
  Function [setInterval]([parfunc] As Dynamic, [parcode] As Dynamic, [pardelay] As Dynamic, ParamArray args() As Dynamic) As Long
  '''<Summary>Schedules a function to execute in a given amount of time.</Summary>
  Function [setTimeout]([parfunction] As Dynamic, [parcode] As Dynamic, [pardelay] As Dynamic, [pararg1] As Dynamic) As Dynamic
End Interface