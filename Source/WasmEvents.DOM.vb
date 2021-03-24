Namespace Global.RemObjects.Elements.WebAssembly.DOM

  Public Class HTMLElement_Events
    Extends HTMLElement

    ' onFullScreenChange

    Public Delegate Sub OnFullScreenChangeDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onFullScreenChange As OnFullScreenChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onFullScreenChange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onFullScreenError

    Public Delegate Sub OnFullScreenErrorDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onFullScreenError As OnFullScreenErrorDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onFullScreenError", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onAbort

    Public Delegate Sub OnAbortDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onAbort As OnAbortDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onAbort", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onBlur

    Public Delegate Sub OnBlurDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onBlur As OnBlurDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onBlur", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onError

    Public Delegate Sub OnErrorDelegate(sender as HTMLElement, e As UIEvent)

    Public Custom Event onError As OnErrorDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As UIEvent))
        CType(Me, EcmaScriptObject).AddEvent("onError", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), UIEvent)))
      End AddHandler
    End Event

    ' onFocus

    Public Delegate Sub OnFocusDelegate(sender as HTMLElement, e As FocusEvent)

    Public Custom Event onFocus As OnFocusDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As FocusEvent))
        CType(Me, EcmaScriptObject).AddEvent("onFocus", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), FocusEvent)))
      End AddHandler
    End Event

    ' onCancel

    Public Delegate Sub OnCancelDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onCancel As OnCancelDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onCancel", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onCanplay

    Public Delegate Sub OnCanplayDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onCanplay As OnCanplayDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onCanplay", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onCanplayThrough

    Public Delegate Sub OnCanplayThroughDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onCanplayThrough As OnCanplayThroughDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onCanplayThrough", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onChange

    Public Delegate Sub OnChangeDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onChange As OnChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onChange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onClick

    Public Delegate Sub OnClickDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onClick As OnClickDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onClick", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onClose

    Public Delegate Sub OnCloseDelegate(sender as HTMLElement, e As FocusEvent)

    Public Custom Event onClose As OnCloseDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As FocusEvent))
        CType(Me, EcmaScriptObject).AddEvent("onClose", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), FocusEvent)))
      End AddHandler
    End Event

    ' onContextMenu

    Public Delegate Sub OnContextMenuDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onContextMenu As OnContextMenuDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onContextMenu", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onCueChange

    Public Delegate Sub OnCueChangeDelegate(sender as HTMLElement, e As FocusEvent)

    Public Custom Event onCueChange As OnCueChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As FocusEvent))
        CType(Me, EcmaScriptObject).AddEvent("onCueChange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), FocusEvent)))
      End AddHandler
    End Event

    ' onDblClick

    Public Delegate Sub OnDblClickDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onDblClick As OnDblClickDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onDblClick", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onDrag

    Public Delegate Sub OnDragDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event onDrag As OnDragDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("onDrag", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' onDragEnd

    Public Delegate Sub OnDragEndDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event onDragEnd As OnDragEndDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("onDragEnd", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' onDragEnter

    Public Delegate Sub OnDragEnterDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event onDragEnter As OnDragEnterDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("onDragEnter", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' onDragExit

    Public Delegate Sub OnDragExitDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event onDragExit As OnDragExitDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("onDragExit", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' onDragLeave

    Public Delegate Sub OnDragLeaveDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event onDragLeave As OnDragLeaveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("onDragLeave", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' onDragOver

    Public Delegate Sub OnDragOverDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event onDragOver As OnDragOverDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("onDragOver", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' onDragStart

    Public Delegate Sub OnDragStartDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event onDragStart As OnDragStartDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("onDragStart", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' onDrop

    Public Delegate Sub OnDropDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event onDrop As OnDropDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("onDrop", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' onDurationChange

    Public Delegate Sub OnDurationChangeDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onDurationChange As OnDurationChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onDurationChange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onEmptied

    Public Delegate Sub OnEmptiedDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onEmptied As OnEmptiedDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onEmptied", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onEnded

    Public Delegate Sub OnEndedDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onEnded As OnEndedDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onEnded", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onFormData

    Public Delegate Sub OnFormDataDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onFormData As OnFormDataDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onFormData", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onGotPointerCapture

    Public Delegate Sub OnGotPointerCaptureDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onGotPointerCapture As OnGotPointerCaptureDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onGotPointerCapture", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onInput

    Public Delegate Sub OnInputDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onInput As OnInputDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onInput", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onInvalid

    Public Delegate Sub OnInvalidDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onInvalid As OnInvalidDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onInvalid", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onKeyDown

    Public Delegate Sub OnKeyDownDelegate(sender as HTMLElement, e As KeyboardEvent)

    Public Custom Event onKeyDown As OnKeyDownDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As KeyboardEvent))
        CType(Me, EcmaScriptObject).AddEvent("onKeyDown", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), KeyboardEvent)))
      End AddHandler
    End Event

    ' onKeyPress

    Public Delegate Sub OnKeyPressDelegate(sender as HTMLElement, e As KeyboardEvent)

    Public Custom Event onKeyPress As OnKeyPressDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As KeyboardEvent))
        CType(Me, EcmaScriptObject).AddEvent("onKeyPress", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), KeyboardEvent)))
      End AddHandler
    End Event

    ' onKeyUp

    Public Delegate Sub OnKeyUpDelegate(sender as HTMLElement, e As KeyboardEvent)

    Public Custom Event onKeyUp As OnKeyUpDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As KeyboardEvent))
        CType(Me, EcmaScriptObject).AddEvent("onKeyUp", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), KeyboardEvent)))
      End AddHandler
    End Event

    ' onLoad

    Public Delegate Sub OnLoadDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onLoad As OnLoadDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onLoad", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onLoadedData

    Public Delegate Sub OnLoadedDataDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onLoadedData As OnLoadedDataDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onLoadedData", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onLoadedMetaData

    Public Delegate Sub OnLoadedMetaDataDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onLoadedMetaData As OnLoadedMetaDataDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onLoadedMetaData", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onLoadEnd

    Public Delegate Sub OnLoadEndDelegate(sender as HTMLElement, e As ProgressEvent)

    Public Custom Event onLoadEnd As OnLoadEndDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As ProgressEvent))
        CType(Me, EcmaScriptObject).AddEvent("onLoadEnd", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), ProgressEvent)))
      End AddHandler
    End Event

    ' onLoadStart

    Public Delegate Sub OnLoadStartDelegate(sender as HTMLElement, e As ProgressEvent)

    Public Custom Event onLoadStart As OnLoadStartDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As ProgressEvent))
        CType(Me, EcmaScriptObject).AddEvent("onLoadStart", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), ProgressEvent)))
      End AddHandler
    End Event

    ' onLostPointerCapture

    Public Delegate Sub OnLostPointerCaptureDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onLostPointerCapture As OnLostPointerCaptureDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onLostPointerCapture", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onMouseDown

    Public Delegate Sub OnMouseDownDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onMouseDown As OnMouseDownDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onMouseDown", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onMouseEnter

    Public Delegate Sub OnMouseEnterDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onMouseEnter As OnMouseEnterDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onMouseEnter", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onMouseLeave

    Public Delegate Sub OnMouseLeaveDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onMouseLeave As OnMouseLeaveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onMouseLeave", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onMouseMove

    Public Delegate Sub OnMouseMoveDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onMouseMove As OnMouseMoveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onMouseMove", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onMouseOut

    Public Delegate Sub OnMouseOutDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onMouseOut As OnMouseOutDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onMouseOut", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onWheel

    Public Delegate Sub OnWheelDelegate(sender as HTMLElement, e As WheelEvent)

    Public Custom Event onWheel As OnWheelDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As WheelEvent))
        CType(Me, EcmaScriptObject).AddEvent("onWheel", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), WheelEvent)))
      End AddHandler
    End Event

    ' onPause

    Public Delegate Sub OnPauseDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onPause As OnPauseDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onPause", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onPlay

    Public Delegate Sub OnPlayDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onPlay As OnPlayDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onPlay", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onPlaying

    Public Delegate Sub OnPlayingDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onPlaying As OnPlayingDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onPlaying", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onPointerDown

    Public Delegate Sub OnPointerDownDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onPointerDown As OnPointerDownDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onPointerDown", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onPointerMove

    Public Delegate Sub OnPointerMoveDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onPointerMove As OnPointerMoveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onPointerMove", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onPointerUp

    Public Delegate Sub OnPointerUpDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onPointerUp As OnPointerUpDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onPointerUp", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onPointerCancel

    Public Delegate Sub OnPointerCancelDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onPointerCancel As OnPointerCancelDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onPointerCancel", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onPointerOver

    Public Delegate Sub OnPointerOverDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onPointerOver As OnPointerOverDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onPointerOver", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onPointerOut

    Public Delegate Sub OnPointerOutDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onPointerOut As OnPointerOutDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onPointerOut", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onPointerEnter

    Public Delegate Sub OnPointerEnterDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onPointerEnter As OnPointerEnterDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onPointerEnter", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onPointerLeave

    Public Delegate Sub OnPointerLeaveDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onPointerLeave As OnPointerLeaveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onPointerLeave", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onProgress

    Public Delegate Sub OnProgressDelegate(sender as HTMLElement, e As ProgressEvent)

    Public Custom Event onProgress As OnProgressDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As ProgressEvent))
        CType(Me, EcmaScriptObject).AddEvent("onProgress", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), ProgressEvent)))
      End AddHandler
    End Event

    ' onRateChange

    Public Delegate Sub OnRateChangeDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onRateChange As OnRateChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onRateChange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onReset

    Public Delegate Sub OnResetDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onReset As OnResetDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onReset", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onResize

    Public Delegate Sub OnResizeDelegate(sender as HTMLElement, e As UIEvent)

    Public Custom Event onResize As OnResizeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As UIEvent))
        CType(Me, EcmaScriptObject).AddEvent("onResize", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), UIEvent)))
      End AddHandler
    End Event

    ' onScroll

    Public Delegate Sub OnScrollDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onScroll As OnScrollDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onScroll", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onSeeked

    Public Delegate Sub OnSeekedDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onSeeked As OnSeekedDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onSeeked", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onSeeking

    Public Delegate Sub OnSeekingDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onSeeking As OnSeekingDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onSeeking", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onSelect

    Public Delegate Sub OnSelectDelegate(sender as HTMLElement, e As UIEvent)

    Public Custom Event onSelect As OnSelectDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As UIEvent))
        CType(Me, EcmaScriptObject).AddEvent("onSelect", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), UIEvent)))
      End AddHandler
    End Event

    ' onSelectStart

    Public Delegate Sub OnSelectStartDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onSelectStart As OnSelectStartDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onSelectStart", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onSelectionChange

    Public Delegate Sub OnSelectionChangeDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onSelectionChange As OnSelectionChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onSelectionChange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onStalled

    Public Delegate Sub OnStalledDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onStalled As OnStalledDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onStalled", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onSubmit

    Public Delegate Sub OnSubmitDelegate(sender as HTMLElement, e As SubmitEvent)

    Public Custom Event onSubmit As OnSubmitDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As SubmitEvent))
        CType(Me, EcmaScriptObject).AddEvent("onSubmit", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), SubmitEvent)))
      End AddHandler
    End Event

    ' onSuspend

    Public Delegate Sub OnSuspendDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onSuspend As OnSuspendDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onSuspend", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onTimeUpdate

    Public Delegate Sub OnTimeUpdateDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onTimeUpdate As OnTimeUpdateDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onTimeUpdate", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onVolumeChange

    Public Delegate Sub OnVolumeChangeDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onVolumeChange As OnVolumeChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onVolumeChange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onWaiting

    Public Delegate Sub OnWaitingDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onWaiting As OnWaitingDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onWaiting", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

  End Class

End Namespace