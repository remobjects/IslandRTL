'''<summary>The Window interface represents a window containing a DOM document; the document property points to the DOM document loaded in that window.</summary>
<DynamicInterface(GetType(EcmaScriptObject))>
Public Interface Window
  '''<summary>Returns a reference to the console object which provides access to the browser's debugging console.</summary>
  ReadOnly Property console As Dynamic
  '''<summary>returns a reference to the CustomElementRegistry object, which can be used to register new custom elements and get information about previously registered custom elements.</summary>
  ReadOnly Property customElements As Dynamic
  '''<summary>Returns the browser crypto object.</summary>
  ReadOnly Property crypto As Crypto
  '''<summary>Gets the arguments passed to the window (if it's a dialog box) at the time window.showModalDialog() was called. This is an nsIArray.</summary>
  ReadOnly Property dialogArguments As Dynamic
  '''<summary>Returns a reference to the document that the window contains.</summary>
  ReadOnly Property document As Document
  '''<summary>Returns the current event, which is the event currently being handled by the JavaScript code's context, or undefined if no event is currently being handled. The Event object passed directly to event handlers should be used instead whenever possible.</summary>
  ReadOnly Property [event] As [Event]
  '''<summary>Returns the element in which the window is embedded, or null if the window is not embedded.</summary>
  ReadOnly Property frameElement As Element
  '''<summary>Returns an array of the subframes in the current window.</summary>
  ReadOnly Property frames As Document()
  '''<summary>This property indicates whether the window is displayed in full screen or not.</summary>
  Property fullScreen As Boolean
  '''<summary>Returns a reference to the history object.</summary>
  ReadOnly Property history As History
  '''<summary>Gets the height of the content area of the browser window including, if rendered, the horizontal scrollbar.</summary>
  ReadOnly Property innerHeight As Integer
  '''<summary>Gets the width of the content area of the browser window including, if rendered, the vertical scrollbar.</summary>
  ReadOnly Property innerWidth As Integer
  '''<summary>Returns the number of frames in the window. See also window.frames.</summary>
  ReadOnly Property length As Integer
  '''<summary>Gets/sets the location, or current URL, of the window object.</summary>
  Property location As Dynamic
  '''<summary>Returns the locationbar object, whose visibility can be toggled in the window.</summary>
  ReadOnly Property locationbar As Dynamic
  '''<summary>Returns a reference to the local storage object used to store data that may only be accessed by the origin that created it.</summary>
  ReadOnly Property localStorage As Storage
  '''<summary>Returns the menubar object, whose visibility can be toggled in the window.</summary>
  ReadOnly Property menubar As Dynamic
  '''<summary>Returns the message manager object for this window.</summary>
  Property messageManager As Dynamic
  '''<summary>Gets/sets the name of the window.</summary>
  Property name As String
  '''<summary>Returns a reference to the navigator object.</summary>
  ReadOnly Property navigator As Dynamic
  '''<summary>Returns a reference to the window that opened this current window.</summary>
  Property opener As Window
  '''<summary>Gets the height of the outside of the browser window.</summary>
  ReadOnly Property outerHeight As Integer
  '''<summary>Gets the width of the outside of the browser window.</summary>
  ReadOnly Property outerWidth As Integer
  '''<summary>Returns a reference to the parent of the current window or subframe.</summary>
  ReadOnly Property parent As Dynamic
  '''<summary>Returns a Performance object, which includes the timing and navigation attributes, each of which is an object providing performance-related data. See also Using Navigation Timing for additional information and examples.</summary>
  ReadOnly Property performance As Dynamic
  '''<summary>Returns the personalbar object, whose visibility can be toggled in the window.</summary>
  ReadOnly Property personalbar As Dynamic
  '''<summary>Returns a reference to the screen object associated with the window.</summary>
  ReadOnly Property screen As Screen
  '''<summary>Both properties return the horizontal distance from the left border of the user's browser viewport to the left side of the screen.</summary>
  ReadOnly Property screenX As Dynamic
  '''<summary>Both properties return the vertical distance from the top border of the user's browser viewport to the top side of the screen.</summary>
  ReadOnly Property screenY As Dynamic
  '''<summary>Returns the scrollbars object, whose visibility can be toggled in the window.</summary>
  ReadOnly Property scrollbars As Dynamic
  '''<summary>Returns the number of pixels that the document has already been scrolled horizontally.</summary>
  ReadOnly Property scrollX As Integer
  '''<summary>Returns the number of pixels that the document has already been scrolled vertically.</summary>
  ReadOnly Property scrollY As Integer
  '''<summary>Returns a reference to the session storage object used to store data that may only be accessed by the origin that created it.</summary>
  Property sessionStorage As Dynamic
  '''<summary>Gets/sets the text in the statusbar at the bottom of the browser.</summary>
  Property status As String
  '''<summary>Returns the statusbar object, whose visibility can be toggled in the window.</summary>
  ReadOnly Property statusbar As Dynamic
  '''<summary>Returns the toolbar object, whose visibility can be toggled in the window.</summary>
  ReadOnly Property toolbar As Dynamic
  '''<summary>Returns a reference to the topmost window in the window hierarchy. This property is read only.</summary>
  ReadOnly Property top As Dynamic
  '''<summary>Returns a VisualViewport object which represents the visual viewport for a given window.</summary>
  ReadOnly Property visualViewport As Dynamic'VisualViewport
  '''<summary>Returns a reference to the current window.</summary>
  ReadOnly Property window As Window
  '''<summary>Returns the CacheStorage object associated with the current context. This object enables functionality such as storing assets for offline use, and generating custom responses to requests.</summary>
  ReadOnly Property caches As Dynamic
  '''<summary>Provides a mechanism for applications to asynchronously access capabilities of indexed databases; returns an IDBFactory object.</summary>
  ReadOnly Property indexedDB As Dynamic
  '''<summary>Returns a boolean indicating whether the current context is secure (true) or not (false).</summary>
  ReadOnly Property isSecureContext As Boolean
  '''<summary>Returns the global object's origin, serialized as a string. (This does not yet appear to be implemented in any browser.)</summary>
  ReadOnly Property origin As String
  '''<summary>Called when the page is installed as a webapp. See appinstalled event.</summary>
  Property onappinstalled As EventListener
  '''<summary>An event handler property dispatched before a user is prompted to save a web site to a home screen on mobile.</summary>
  Property onbeforeinstallprompt As EventListener
  '''<summary>An event handler property for any ambient light levels changes</summary>
  Property ondevicelight As EventListener
  '''<summary>Called if accelerometer detects a change (For mobile devices)</summary>
  Property ondevicemotion As EventListener
  '''<summary>Called when the orientation is changed (For mobile devices)</summary>
  Property ondeviceorientation As EventListener
  '''<summary>An event handler property for device proximity event</summary>
  Property ondeviceproximity As EventListener
  '''<summary>Represents an event handler that will run when a gamepad is connected (when the gamepadconnected event fires).</summary>
  Property ongamepadconnected As EventListener
  '''<summary>Represents an event handler that will run when a gamepad is disconnected (when the gamepaddisconnected event fires).</summary>
  Property ongamepaddisconnected As EventListener
  '''<summary>An event handler property for the MozBeforePaint event, which is sent before repainting the window if the event has been requested by a call to the Window.mozRequestAnimationFrame() method.</summary>
  Property onmozbeforepaint As EventListener
  '''<summary>An event handler property for paint events on the window.</summary>
  Property onpaint As EventListener
  '''<summary>An event handler property for user proximity events.</summary>
  Property onuserproximity As EventListener
  '''<summary>Represents an event handler that will run when a compatible VR device has been connected to the computer (when the vrdisplayconnected event fires).</summary>
  Property onvrdisplayconnect As EventListener
  '''<summary>Represents an event handler that will run when a compatible VR device has been disconnected from the computer (when the vrdisplaydisconnected event fires).</summary>
  Property onvrdisplaydisconnect As EventListener
  '''<summary>Represents an event handler that will run when a display is able to be presented to (when the vrdisplayactivate event fires), for example if an HMD has been moved to bring it out of standby, or woken up by being put on.</summary>
  Property onvrdisplayactivate As EventListener
  '''<summary>Represents an event handler that will run when a display can no longer be presented to (when the vrdisplaydeactivate event fires), for example if an HMD has gone into standby or sleep mode due to a period of inactivity.</summary>
  Property onvrdisplaydeactivate As EventListener
  '''<summary>Represents an event handler that will run when presentation to a display has been paused for some reason by the browser, OS, or VR hardware (when the vrdisplayblur event fires) — for example, while the user is interacting with a system menu or browser, to prevent tracking or loss of experience.</summary>
  Property onvrdisplayblur As EventListener
  '''<summary>Represents an event handler that will run when presentation to a display has resumed after being blurred (when the vrdisplayfocus event fires).</summary>
  Property onvrdisplayfocus As EventListener
  '''<summary>represents an event handler that will run when the presenting state of a VR device changes — i.e. goes from presenting to not presenting, or vice versa (when the vrdisplaypresentchange event fires).</summary>
  Property onvrdisplaypresentchange As EventListener
  '''<summary>Displays an alert dialog.</summary>
  Function alert(parmessage As Dynamic) As Dynamic
  '''<summary>Sets focus away from the window.</summary>
  Function blur() As Dynamic
  '''<summary>Cancels the repeated execution set using setImmediate.</summary>
  Function clearImmediate(parimmediateID As Dynamic) As Dynamic
  '''<summary>Closes the current window.</summary>
  Function close() As Dynamic
  '''<summary>Displays a dialog with a message that the user needs to respond to.</summary>
  Function confirm(parmessage As Dynamic) As Dynamic
  '''<summary>Searches for a given string in a window.</summary>
  Function find(parparaString As Dynamic, paraCaseSensitive As Dynamic, paraBackwards As Dynamic, paraWrapAround As Dynamic, paraWholeWord As Dynamic, paraSearchInFrames As Dynamic, paraShowDialog As Dynamic) As String
  '''<summary>Sets focus on the current window.</summary>
  Function focus() As Dynamic
  '''<summary>Gets computed style for the specified element. Computed style indicates the computed values of all CSS properties of the element.</summary>
  Function getComputedStyle(parelement As Dynamic) As HTMLElement
  '''<summary>Returns the selection object representing the selected item(s).</summary>
  Function getSelection() As Dynamic'Selection
  '''<summary>Returns a MediaQueryList object representing the specified media query string.</summary>
  Function matchMedia(parmediaQueryString As Dynamic) As Dynamic
  '''<summary>FIXME: NeedsContents</summary>
  Function maximize() As Dynamic
  '''<summary>Minimizes the window.</summary>
  Function minimize() As Dynamic
  '''<summary>Moves the current window by a specified amount.</summary>
  Function moveBy() As Dynamic
  '''<summary>Moves the window to the specified coordinates.</summary>
  Function moveTo() As Dynamic
  '''<summary>Opens a new window.</summary>
  Function open(parurl As Dynamic, parwindowName As Dynamic, parwindowFeatures As Dynamic) As Dynamic
  '''<summary>Provides a secure means for one window to send a string of data to another window, which need not be within the same domain as the first.</summary>
  Function postMessage(parmessage As Dynamic, partargetOrigin As Dynamic, partransfer As Dynamic) As String
  '''<summary>Opens the Print Dialog to print the current document.</summary>
  Function print() As Dynamic
  '''<summary>Returns the text entered by the user in a prompt dialog.</summary>
  Function prompt(parmessage As Dynamic, pardefault As Dynamic) As String
  '''<summary>Tells the browser that an animation is in progress, requesting that the browser schedule a repaint of the window for the next animation frame.</summary>
  Function requestAnimationFrame(parcallback As Dynamic) As Dynamic
  '''<summary>Resizes the current window by a certain amount.</summary>
  Function resizeBy() As Dynamic
  '''<summary>Dynamically resizes window.</summary>
  Function resizeTo(parwidth As Dynamic, parheight As Dynamic) As Dynamic
  '''<summary>Scrolls the window to a particular place in the document.</summary>
  Function scroll() As Dynamic
  '''<summary>Scrolls the document in the window by the given amount.</summary>
  Function scrollBy() As Dynamic
  '''<summary>Scrolls to a particular set of coordinates in the document.</summary>
  Function scrollTo() As Dynamic
  '''<summary>Executes a function after the browser has finished other heavy tasks</summary>
  Function setImmediate(parparfunc As Dynamic, parparparam1 As Dynamic, parparparam2 As Dynamic) As Dynamic
  '''<summary>This method stops window loading.</summary>
  Function [stop]() As Dynamic
  '''<summary>Register an event handler to a specific event type on the window.</summary>
  Function addEventListener(partype As Dynamic, parlistener As Dynamic, paroptions As Dynamic, parcapture As Dynamic, paronce As Dynamic, parpassive As Dynamic) As Dynamic
  '''<summary>Used to trigger an event.</summary>
  Function dispatchEvent(parevent As Dynamic) As Dynamic
  '''<summary>Decodes a string of data which has been encoded using base-64 encoding.</summary>
  Function atob(parencodedData As Dynamic) As String
  '''<summary>Creates a base-64 encoded ASCII string from a string of binary data.</summary>
  Function btoa(parstringToEncode As Dynamic) As String
  '''<summary>Cancels the repeated execution set using WindowOrWorkerGlobalScope.setInterval().</summary>
  Function clearInterval(parintervalID As Dynamic) As Dynamic
  '''<summary>Cancels the delayed execution set using WindowOrWorkerGlobalScope.setTimeout().</summary>
  Function clearTimeout(partimeoutID As Dynamic) As Dynamic
  '''<summary>Accepts a variety of different image sources, and returns a Promise which resolves to an ImageBitmap. Optionally the source is cropped to the rectangle of pixels originating at (sx, sy) with width sw, and height sh.</summary>
  Function createImageBitmap(parimage As Dynamic, parsx As Dynamic, parsy As Dynamic, parsw As Dynamic, parsh As Dynamic, paroptions As Dynamic) As Integer
  '''<summary>Starts the process of fetching a resource from the network.</summary>
  Function fetch(parresource As Dynamic, parinit As Dynamic, parmethod As Dynamic, parheaders As Dynamic, parbody As Dynamic, parmode As Dynamic, parcredentials As Dynamic, parcache As Dynamic, parredirect As Dynamic, parreferrer As Dynamic, parreferrerPolicy As Dynamic, parintegrity As Dynamic, parkeepalive As Dynamic, parsignal As Dynamic) As Dynamic
  '''<summary>Removes an event listener from the window.</summary>
  Function removeEventListener(partype As Dynamic, parlistener As Dynamic, paroptions As Dynamic, paruseCapture As Dynamic) As Dynamic
  '''<summary>Schedules a function to execute every time a given number of milliseconds elapses.</summary>
  Function setInterval(parfunc As Dynamic, parcode As Dynamic, pardelay As Dynamic, ParamArray args() As Dynamic) As Long
  '''<summary>Schedules a function to execute in a given amount of time.</summary>
  Function setTimeout(parfunction As Dynamic, parcode As Dynamic, pardelay As Dynamic, pararg1 As Dynamic) As Dynamic
End Interface