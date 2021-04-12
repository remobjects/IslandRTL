Namespace Global.RemObjects.Elements.WebAssembly.DOM

  Public Class Delegates
    Public Delegate Sub OnFullScreenChangeDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnFullScreenErrorDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnAbortDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnBlurDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnErrorDelegate(sender as HTMLElement, e As Dom.UIEvent)
    Public Delegate Sub OnFocusDelegate(sender as HTMLElement, e As Dom.FocusEvent)
    Public Delegate Sub OnCancelDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnCanplayDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnCanplayThroughDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnChangeDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnClickDelegate(sender as HTMLElement, e As Dom.MouseEvent)
    Public Delegate Sub OnCloseDelegate(sender as HTMLElement, e As Dom.FocusEvent)
    Public Delegate Sub OnContextMenuDelegate(sender as HTMLElement, e As Dom.MouseEvent)
    Public Delegate Sub OnCueChangeDelegate(sender as HTMLElement, e As Dom.FocusEvent)
    Public Delegate Sub OnDblClickDelegate(sender as HTMLElement, e As Dom.MouseEvent)
    Public Delegate Sub OnDragDelegate(sender as HTMLElement, e As Dom.DragEvent)
    Public Delegate Sub OnDragEndDelegate(sender as HTMLElement, e As Dom.DragEvent)
    Public Delegate Sub OnDragEnterDelegate(sender as HTMLElement, e As Dom.DragEvent)
    Public Delegate Sub OnDragExitDelegate(sender as HTMLElement, e As Dom.DragEvent)
    Public Delegate Sub OnDragLeaveDelegate(sender as HTMLElement, e As Dom.DragEvent)
    Public Delegate Sub OnDragOverDelegate(sender as HTMLElement, e As Dom.DragEvent)
    Public Delegate Sub OnDragStartDelegate(sender as HTMLElement, e As Dom.DragEvent)
    Public Delegate Sub OnDropDelegate(sender as HTMLElement, e As Dom.DragEvent)
    Public Delegate Sub OnDurationChangeDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnEmptiedDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnEndedDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnFormDataDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnGotPointerCaptureDelegate(sender as HTMLElement, e As Dom.PointerEvent)
    Public Delegate Sub OnInputDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnInvalidDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnKeyDownDelegate(sender as HTMLElement, e As Dom.KeyboardEvent)
    Public Delegate Sub OnKeyPressDelegate(sender as HTMLElement, e As Dom.KeyboardEvent)
    Public Delegate Sub OnKeyUpDelegate(sender as HTMLElement, e As Dom.KeyboardEvent)
    Public Delegate Sub OnLoadDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnLoadedDataDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnLoadedMetaDataDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnLoadEndDelegate(sender as HTMLElement, e As Dom.ProgressEvent)
    Public Delegate Sub OnLoadStartDelegate(sender as HTMLElement, e As Dom.ProgressEvent)
    Public Delegate Sub OnLostPointerCaptureDelegate(sender as HTMLElement, e As Dom.PointerEvent)
    Public Delegate Sub OnMouseDownDelegate(sender as HTMLElement, e As Dom.MouseEvent)
    Public Delegate Sub OnMouseEnterDelegate(sender as HTMLElement, e As Dom.MouseEvent)
    Public Delegate Sub OnMouseLeaveDelegate(sender as HTMLElement, e As Dom.MouseEvent)
    Public Delegate Sub OnMouseMoveDelegate(sender as HTMLElement, e As Dom.MouseEvent)
    Public Delegate Sub OnMouseOutDelegate(sender as HTMLElement, e As Dom.MouseEvent)
    Public Delegate Sub OnWheelDelegate(sender as HTMLElement, e As Dom.WheelEvent)
    Public Delegate Sub OnPauseDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnPlayDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnPlayingDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnPointerDownDelegate(sender as HTMLElement, e As Dom.PointerEvent)
    Public Delegate Sub OnPointerMoveDelegate(sender as HTMLElement, e As Dom.PointerEvent)
    Public Delegate Sub OnPointerUpDelegate(sender as HTMLElement, e As Dom.PointerEvent)
    Public Delegate Sub OnPointerCancelDelegate(sender as HTMLElement, e As Dom.PointerEvent)
    Public Delegate Sub OnPointerOverDelegate(sender as HTMLElement, e As Dom.PointerEvent)
    Public Delegate Sub OnPointerOutDelegate(sender as HTMLElement, e As Dom.PointerEvent)
    Public Delegate Sub OnPointerEnterDelegate(sender as HTMLElement, e As Dom.PointerEvent)
    Public Delegate Sub OnPointerLeaveDelegate(sender as HTMLElement, e As Dom.PointerEvent)
    Public Delegate Sub OnProgressDelegate(sender as HTMLElement, e As Dom.ProgressEvent)
    Public Delegate Sub OnRateChangeDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnResetDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnResizeDelegate(sender as HTMLElement, e As Dom.UIEvent)
    Public Delegate Sub OnScrollDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnSeekedDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnSeekingDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnSelectDelegate(sender as HTMLElement, e As Dom.UIEvent)
    Public Delegate Sub OnSelectStartDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnSelectionChangeDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnStalledDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnSubmitDelegate(sender as HTMLElement, e As Dom.SubmitEvent)
    Public Delegate Sub OnSuspendDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnTimeUpdateDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnVolumeChangeDelegate(sender as HTMLElement, e As Dom.Event)
    Public Delegate Sub OnWaitingDelegate(sender as HTMLElement, e As Dom.Event)
  End Class

  Public Class HTMLElement_Events
    Extends HTMLElement

    ' onfullscreenchange

    Public Custom Event onfullscreenchange As Delegates.OnFullScreenChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onfullscreenchange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onfullscreenerror

    Public Custom Event onfullscreenerror As Delegates.OnFullScreenErrorDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onfullscreenerror", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onabort

    Public Custom Event onabort As Delegates.OnAbortDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onabort", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onblur

    Public Custom Event onblur As Delegates.OnBlurDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onblur", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onerror

    Public Custom Event onerror As Delegates.OnErrorDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.UIEvent))
        CType(Me, EcmaScriptObject).AddEvent("onerror", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.UIEvent)))
      End AddHandler
    End Event

    ' onfocus

    Public Custom Event onfocus As Delegates.OnFocusDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.FocusEvent))
        CType(Me, EcmaScriptObject).AddEvent("onfocus", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.FocusEvent)))
      End AddHandler
    End Event

    ' oncancel

    Public Custom Event oncancel As Delegates.OnCancelDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("oncancel", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' oncanplay

    Public Custom Event oncanplay As Delegates.OnCanplayDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("oncanplay", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' oncanplaythrough

    Public Custom Event oncanplaythrough As Delegates.OnCanplayThroughDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("oncanplaythrough", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onchange

    Public Custom Event onchange As Delegates.OnChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onchange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onclick

    Public Custom Event onclick As Delegates.OnClickDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onclick", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.MouseEvent)))
      End AddHandler
    End Event

    ' onclose

    Public Custom Event onclose As Delegates.OnCloseDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.FocusEvent))
        CType(Me, EcmaScriptObject).AddEvent("onclose", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.FocusEvent)))
      End AddHandler
    End Event

    ' oncontextmenu

    Public Custom Event oncontextmenu As Delegates.OnContextMenuDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("oncontextmenu", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.MouseEvent)))
      End AddHandler
    End Event

    ' oncuechange

    Public Custom Event oncuechange As Delegates.OnCueChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.FocusEvent))
        CType(Me, EcmaScriptObject).AddEvent("oncuechange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.FocusEvent)))
      End AddHandler
    End Event

    ' ondblclick

    Public Custom Event ondblclick As Delegates.OnDblClickDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondblclick", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.MouseEvent)))
      End AddHandler
    End Event

    ' ondrag

    Public Custom Event ondrag As Delegates.OnDragDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondrag", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.DragEvent)))
      End AddHandler
    End Event

    ' ondragend

    Public Custom Event ondragend As Delegates.OnDragEndDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondragend", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.DragEvent)))
      End AddHandler
    End Event

    ' ondragenter

    Public Custom Event ondragenter As Delegates.OnDragEnterDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondragenter", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.DragEvent)))
      End AddHandler
    End Event

    ' ondragexit

    Public Custom Event ondragexit As Delegates.OnDragExitDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondragexit", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.DragEvent)))
      End AddHandler
    End Event

    ' ondragleave

    Public Custom Event ondragleave As Delegates.OnDragLeaveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondragleave", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.DragEvent)))
      End AddHandler
    End Event

    ' ondragover

    Public Custom Event ondragover As Delegates.OnDragOverDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondragover", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.DragEvent)))
      End AddHandler
    End Event

    ' ondragstart

    Public Custom Event ondragstart As Delegates.OnDragStartDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondragstart", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.DragEvent)))
      End AddHandler
    End Event

    ' ondrop

    Public Custom Event ondrop As Delegates.OnDropDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondrop", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.DragEvent)))
      End AddHandler
    End Event

    ' ondurationchange

    Public Custom Event ondurationchange As Delegates.OnDurationChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("ondurationchange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onemptied

    Public Custom Event onemptied As Delegates.OnEmptiedDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onemptied", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onended

    Public Custom Event onended As Delegates.OnEndedDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onended", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onformdata

    Public Custom Event onformdata As Delegates.OnFormDataDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onformdata", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' ongotpointercapture

    Public Custom Event ongotpointercapture As Delegates.OnGotPointerCaptureDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("ongotpointercapture", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.PointerEvent)))
      End AddHandler
    End Event

    ' oninput

    Public Custom Event oninput As Delegates.OnInputDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("oninput", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' oninvalid

    Public Custom Event oninvalid As Delegates.OnInvalidDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("oninvalid", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onkeydown

    Public Custom Event onkeydown As Delegates.OnKeyDownDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.KeyboardEvent))
        CType(Me, EcmaScriptObject).AddEvent("onkeydown", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.KeyboardEvent)))
      End AddHandler
    End Event

    ' onkeypress

    Public Custom Event onkeypress As Delegates.OnKeyPressDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.KeyboardEvent))
        CType(Me, EcmaScriptObject).AddEvent("onkeypress", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.KeyboardEvent)))
      End AddHandler
    End Event

    ' onkeyup

    Public Custom Event onkeyup As Delegates.OnKeyUpDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.KeyboardEvent))
        CType(Me, EcmaScriptObject).AddEvent("onkeyup", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.KeyboardEvent)))
      End AddHandler
    End Event

    ' onload

    Public Custom Event onload As Delegates.OnLoadDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onload", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onloadeddata

    Public Custom Event onloadeddata As Delegates.OnLoadedDataDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onloadeddata", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onloadedmetadata

    Public Custom Event onloadedmetadata As Delegates.OnLoadedMetaDataDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onloadedmetadata", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onloadend

    Public Custom Event onloadend As Delegates.OnLoadEndDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.ProgressEvent))
        CType(Me, EcmaScriptObject).AddEvent("onloadend", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.ProgressEvent)))
      End AddHandler
    End Event

    ' onloadstart

    Public Custom Event onloadstart As Delegates.OnLoadStartDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.ProgressEvent))
        CType(Me, EcmaScriptObject).AddEvent("onloadstart", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.ProgressEvent)))
      End AddHandler
    End Event

    ' onlostpointercapture

    Public Custom Event onlostpointercapture As Delegates.OnLostPointerCaptureDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onlostpointercapture", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.PointerEvent)))
      End AddHandler
    End Event

    ' onmousedown

    Public Custom Event onmousedown As Delegates.OnMouseDownDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onmousedown", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.MouseEvent)))
      End AddHandler
    End Event

    ' onmouseenter

    Public Custom Event onmouseenter As Delegates.OnMouseEnterDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onmouseenter", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.MouseEvent)))
      End AddHandler
    End Event

    ' onmouseleave

    Public Custom Event onmouseleave As Delegates.OnMouseLeaveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onmouseleave", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.MouseEvent)))
      End AddHandler
    End Event

    ' onmousemove

    Public Custom Event onmousemove As Delegates.OnMouseMoveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onmousemove", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.MouseEvent)))
      End AddHandler
    End Event

    ' onmouseout

    Public Custom Event onmouseout As Delegates.OnMouseOutDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onmouseout", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.MouseEvent)))
      End AddHandler
    End Event

    ' onwheel

    Public Custom Event onwheel As Delegates.OnWheelDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.WheelEvent))
        CType(Me, EcmaScriptObject).AddEvent("onwheel", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.WheelEvent)))
      End AddHandler
    End Event

    ' onpause

    Public Custom Event onpause As Delegates.OnPauseDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onpause", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onplay

    Public Custom Event onplay As Delegates.OnPlayDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onplay", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onplaying

    Public Custom Event onplaying As Delegates.OnPlayingDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onplaying", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onpointerdown

    Public Custom Event onpointerdown As Delegates.OnPointerDownDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointerdown", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.PointerEvent)))
      End AddHandler
    End Event

    ' onpointermove

    Public Custom Event onpointermove As Delegates.OnPointerMoveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointermove", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.PointerEvent)))
      End AddHandler
    End Event

    ' onpointerup

    Public Custom Event onpointerup As Delegates.OnPointerUpDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointerup", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.PointerEvent)))
      End AddHandler
    End Event

    ' onpointercancel

    Public Custom Event onpointercancel As Delegates.OnPointerCancelDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointercancel", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.PointerEvent)))
      End AddHandler
    End Event

    ' onpointerover

    Public Custom Event onpointerover As Delegates.OnPointerOverDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointerover", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.PointerEvent)))
      End AddHandler
    End Event

    ' onpointerout

    Public Custom Event onpointerout As Delegates.OnPointerOutDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointerout", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.PointerEvent)))
      End AddHandler
    End Event

    ' onpointerenter

    Public Custom Event onpointerenter As Delegates.OnPointerEnterDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointerenter", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.PointerEvent)))
      End AddHandler
    End Event

    ' onpointerleave

    Public Custom Event onpointerleave As Delegates.OnPointerLeaveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointerleave", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.PointerEvent)))
      End AddHandler
    End Event

    ' onprogress

    Public Custom Event onprogress As Delegates.OnProgressDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.ProgressEvent))
        CType(Me, EcmaScriptObject).AddEvent("onprogress", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.ProgressEvent)))
      End AddHandler
    End Event

    ' onratechange

    Public Custom Event onratechange As Delegates.OnRateChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onratechange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onreset

    Public Custom Event onreset As Delegates.OnResetDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onreset", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onresize

    Public Custom Event onresize As Delegates.OnResizeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.UIEvent))
        CType(Me, EcmaScriptObject).AddEvent("onresize", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.UIEvent)))
      End AddHandler
    End Event

    ' onscroll

    Public Custom Event onscroll As Delegates.OnScrollDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onscroll", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onseeked

    Public Custom Event onseeked As Delegates.OnSeekedDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onseeked", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onseeking

    Public Custom Event onseeking As Delegates.OnSeekingDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onseeking", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onselect

    Public Custom Event onselect As Delegates.OnSelectDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.UIEvent))
        CType(Me, EcmaScriptObject).AddEvent("onselect", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.UIEvent)))
      End AddHandler
    End Event

    ' onselectstart

    Public Custom Event onselectstart As Delegates.OnSelectStartDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onselectstart", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onselectionchange

    Public Custom Event onselectionchange As Delegates.OnSelectionChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onselectionchange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onstalled

    Public Custom Event onstalled As Delegates.OnStalledDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onstalled", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onsubmit

    Public Custom Event onsubmit As Delegates.OnSubmitDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.SubmitEvent))
        CType(Me, EcmaScriptObject).AddEvent("onsubmit", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.SubmitEvent)))
      End AddHandler
    End Event

    ' onsuspend

    Public Custom Event onsuspend As Delegates.OnSuspendDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onsuspend", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' ontimeupdate

    Public Custom Event ontimeupdate As Delegates.OnTimeUpdateDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("ontimeupdate", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onvolumechange

    Public Custom Event onvolumechange As Delegates.OnVolumeChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onvolumechange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onwaiting

    Public Custom Event onwaiting As Delegates.OnWaitingDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onwaiting", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

  End Class

End Namespace