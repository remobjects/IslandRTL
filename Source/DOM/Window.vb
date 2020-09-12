'''<Summary>The Window interface represents a window containing a DOM document; the document property points to the DOM document loaded in that window.</Summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface [Window]
  '''<Summary>Returns a reference to the console object which provides access to the browser's debugging console.</Summary>
  ReadOnly Property [console] As Dynamic
  '''<Summary>Returns the browser crypto object.</Summary>
  ReadOnly Property [crypto] As Crypto
  '''<Summary>Gets the arguments passed to the window (if it's a dialog box) at the time window.showModalDialog() was called. This is an nsIArray.</Summary>
  ReadOnly Property [dialogArguments] As Window
  '''<Summary>Returns a reference to the document that the window contains.</Summary>
  ReadOnly Property [document] As Document
  '''<Summary>Returns the current event, which is the event currently being handled by the JavaScript code's context, or undefined if no event is currently being handled. The Event object passed directly to event handlers should be used instead whenever possible.</Summary>
  ReadOnly Property [event] As [Event]
  '''<Summary>Returns the element in which the window is embedded, or null if the window is not embedded.</Summary>
  ReadOnly Property [frameElement] As Element
  '''<Summary>Returns an array of the subframes in the current window.</Summary>
  ReadOnly Property [frames] As Document()
  '''<Summary>This property indicates whether the window is displayed in full screen or not.</Summary>
  Property [fullScreen] As Screen
  '''<Summary>Returns a reference to the history object.</Summary>
  ReadOnly Property [history] As History
  '''<Summary>Gets the height of the content area of the browser window including, if rendered, the horizontal scrollbar.</Summary>
  ReadOnly Property [innerHeight] As Integer
  '''<Summary>Gets the width of the content area of the browser window including, if rendered, the vertical scrollbar.</Summary>
  ReadOnly Property [innerWidth] As Integer
  '''<Summary>Returns the number of frames in the window. See also window.frames.</Summary>
  ReadOnly Property [length] As Integer
  '''<Summary>Gets/sets the location, or current URL, of the window object.</Summary>
  Property [location] As Window
  '''<Summary>Returns a reference to the local storage object used to store data that may only be accessed by the origin that created it.</Summary>
  ReadOnly Property [localStorage] As Storage
  '''<Summary>Gets/sets the name of the window.</Summary>
  Property [name] As String
  '''<Summary>Returns a reference to the navigator object.</Summary>
  ReadOnly Property [navigator] As Navigator
  '''<Summary>Returns a reference to the window that opened this current window.</Summary>
  Property [opener] As Window
  '''<Summary>Gets the height of the outside of the browser window.</Summary>
  ReadOnly Property [outerHeight] As Integer
  '''<Summary>Gets the width of the outside of the browser window.</Summary>
  ReadOnly Property [outerWidth] As Integer
  '''<Summary>Returns a reference to the parent of the current window or subframe.</Summary>
  ReadOnly Property [parent] As Window
  '''<Summary>Returns a Performance object, which includes the timing and navigation attributes, each of which is an object providing performance-related data. See also Using Navigation Timing for additional information and examples.</Summary>
  ReadOnly Property [performance] As Performance
  '''<Summary>Returns a reference to the screen object associated with the window.</Summary>
  ReadOnly Property [screen] As Screen
  '''<Summary>Returns the number of pixels that the document has already been scrolled horizontally.</Summary>
  ReadOnly Property [scrollX] As Integer
  '''<Summary>Returns the number of pixels that the document has already been scrolled vertically.</Summary>
  ReadOnly Property [scrollY] As Integer
  '''<Summary>Returns a reference to the session storage object used to store data that may only be accessed by the origin that created it.</Summary>
  Property [sessionStorage] As Storage
  '''<Summary>Gets/sets the text in the statusbar at the bottom of the browser.</Summary>
  Property [status] As String
  '''<Summary>Returns a reference to the topmost window in the window hierarchy. This property is read only.</Summary>
  ReadOnly Property [top] As Window
  '''<Summary>Provides a mechanism for applications to asynchronously access capabilities of indexed databases; returns an IDBFactory object.</Summary>
  ReadOnly Property [indexedDB] As IDBFactory
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
  '''<Summary>Searches for a given string in a window.</Summary>
  Function [find]([parparaString] As Dynamic, [paraCaseSensitive] As Dynamic, [paraBackwards] As Dynamic, [paraWrapAround] As Dynamic, [paraWholeWord] As Dynamic, [paraSearchInFrames] As Dynamic, [paraShowDialog] As Dynamic) As String
  '''<Summary>Gets computed style for the specified element. Computed style indicates the computed values of all CSS properties of the element.</Summary>
  Function [getComputedStyle]([parelement] As Dynamic) As HTMLElement
  '''<Summary>Returns the selection object representing the selected item(s).</Summary>
  Function [getSelection]() As Dynamic
  '''<Summary>FIXME: NeedsContents</Summary>
  Function [maximize]() As Dynamic
  '''<Summary>Minimizes the window.</Summary>
  Function [minimize]() As Dynamic
  '''<Summary>Moves the current window by a specified amount.</Summary>
  Function [moveBy]() As Window
  '''<Summary>Moves the window to the specified coordinates.</Summary>
  Function [moveTo]() As Window
  '''<Summary>Opens a new window.</Summary>
  Function [open]([parurl] As Dynamic, [parwindowName] As Dynamic, [parwindowFeatures] As Dynamic) As Dynamic
  '''<Summary>Provides a secure means for one window to send a string of data to another window, which need not be within the same domain as the first.</Summary>
  Function [postMessage]([parmessage] As Dynamic, [partargetOrigin] As Dynamic, [partransfer]] As Dynamic) As String
  '''<Summary>Opens the Print Dialog to print the current document.</Summary>
  Function [print]() As Dynamic
  '''<Summary>Returns the text entered by the user in a prompt dialog.</Summary>
  Function [prompt]([parmessage] As Dynamic, [pardefault] As Dynamic) As String
  '''<Summary>Tells the browser that an animation is in progress, requesting that the browser schedule a repaint of the window for the next animation frame.</Summary>
  Function [requestAnimationFrame]([parcallback] As Dynamic) As Integer
  '''<Summary>Resizes the current window by a certain amount.</Summary>
  Function [resizeBy]() As Window
  '''<Summary>Scrolls the window to a particular place in the document.</Summary>
  Function [scroll]() As Window
  '''<Summary>Scrolls the document in the window by the given amount.</Summary>
  Function [scrollBy]() As Document
  '''<Summary>Scrolls to a particular set of coordinates in the document.</Summary>
  Function [scrollTo]() As Dynamic
  '''<Summary>This method stops window loading.</Summary>
  Function [stop]() As Window
  '''<Summary>Register an event handler to a specific event type on the window.</Summary>
  Function [addEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [parcapture] As Dynamic, [paronce] As Dynamic, [parpassive] As Dynamic) As Dynamic
  '''<Summary>Used to trigger an event.</Summary>
  Function [dispatchEvent]([parevent] As Dynamic) As Dynamic
  '''<Summary>Decodes a string of data which has been encoded using base-64 encoding.</Summary>
  Function [atob]([parencodedData] As Dynamic) As String
  '''<Summary>Creates a base-64 encoded ASCII string from a string of binary data.</Summary>
  Function [btoa]([parstringToEncode] As Dynamic) As String
  '''<Summary>Cancels the repeated execution set using WindowOrWorkerGlobalScope.setInterval().</Summary>
  Sub [clearInterval]([parintervalID] As Dynamic)
  '''<Summary>Accepts a variety of different image sources, and returns a Promise which resolves to an ImageBitmap. Optionally the source is cropped to the rectangle of pixels originating at (sx, sy) with width sw, and height sh.</Summary>
  Function [createImageBitmap]([parimage] As Dynamic, [parsx] As Dynamic, [parsy] As Dynamic, [parsw] As Dynamic, [parsh] As Dynamic, [paroptions] As Dynamic) As Integer
  '''<Summary>Starts the process of fetching a resource from the network.</Summary>
  Function [fetch]([parresource] As Dynamic, [parinit] As Dynamic, [parmethod] As Dynamic, [parheaders] As Dynamic, [parbody] As Dynamic, [parmode] As Dynamic, [parcredentials] As Dynamic, [parcache] As Dynamic, [parredirect] As Dynamic, [parreferrer] As Dynamic, [parreferrerPolicy] As Dynamic, [parintegrity] As Dynamic, [parkeepalive] As Dynamic, [parsignal] As Dynamic) As Dynamic
  '''<Summary>Removes an event listener from the window.</Summary>
  Function [removeEventListener]([partype] As Dynamic, [parlistener] As Dynamic, [paroptions] As Dynamic, [paruseCapture] As Dynamic) As Dynamic
  '''<Summary>Schedules a function to execute every time a given number of milliseconds elapses.</Summary>
  Function [setInterval]([parfunc] As Dynamic, [parcode] As Dynamic, [pardelay] As Dynamic, ParamArray args() As Dynamic) As Integer
  '''<Summary>Schedules a function to execute in a given amount of time.</Summary>
  Function [setTimeout]([parfunction] As Dynamic, [parcode] As Dynamic, [pardelay] As Dynamic, [pararg1] As Dynamic) As Integer
End Interface