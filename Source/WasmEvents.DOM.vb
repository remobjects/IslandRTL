Namespace Global.RemObjects.Elements.WebAssembly.DOM

  Public Class HTMLElement_Events
    Extends HTMLElement

    ' onfullscreenchange

    Public Delegate Sub OnFullScreenChangeDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onfullscreenchange As OnFullScreenChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onfullscreenchange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onfullscreenerror

    Public Delegate Sub OnFullScreenErrorDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onfullscreenerror As OnFullScreenErrorDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onfullscreenerror", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onabort

    Public Delegate Sub OnAbortDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onabort As OnAbortDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onabort", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onblur

    Public Delegate Sub OnBlurDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onblur As OnBlurDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onblur", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onerror

    Public Delegate Sub OnErrorDelegate(sender as HTMLElement, e As UIEvent)

    Public Custom Event onerror As OnErrorDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As UIEvent))
        CType(Me, EcmaScriptObject).AddEvent("onerror", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), UIEvent)))
      End AddHandler
    End Event

    ' onfocus

    Public Delegate Sub OnFocusDelegate(sender as HTMLElement, e As FocusEvent)

    Public Custom Event onfocus As OnFocusDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As FocusEvent))
        CType(Me, EcmaScriptObject).AddEvent("onfocus", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), FocusEvent)))
      End AddHandler
    End Event

    ' oncancel

    Public Delegate Sub OnCancelDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event oncancel As OnCancelDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("oncancel", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' oncanplay

    Public Delegate Sub OnCanplayDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event oncanplay As OnCanplayDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("oncanplay", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' oncanplaythrough

    Public Delegate Sub OnCanplayThroughDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event oncanplaythrough As OnCanplayThroughDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("oncanplaythrough", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onchange

    Public Delegate Sub OnChangeDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onchange As OnChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onchange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onclick

    Public Delegate Sub OnClickDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onclick As OnClickDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onclick", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onclose

    Public Delegate Sub OnCloseDelegate(sender as HTMLElement, e As FocusEvent)

    Public Custom Event onclose As OnCloseDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As FocusEvent))
        CType(Me, EcmaScriptObject).AddEvent("onclose", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), FocusEvent)))
      End AddHandler
    End Event

    ' oncontextmenu

    Public Delegate Sub OnContextMenuDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event oncontextmenu As OnContextMenuDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("oncontextmenu", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' oncuechange

    Public Delegate Sub OnCueChangeDelegate(sender as HTMLElement, e As FocusEvent)

    Public Custom Event oncuechange As OnCueChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As FocusEvent))
        CType(Me, EcmaScriptObject).AddEvent("oncuechange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), FocusEvent)))
      End AddHandler
    End Event

    ' ondblclick

    Public Delegate Sub OnDblClickDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event ondblclick As OnDblClickDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondblclick", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' ondrag

    Public Delegate Sub OnDragDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event ondrag As OnDragDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondrag", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' ondragend

    Public Delegate Sub OnDragEndDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event ondragend As OnDragEndDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondragend", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' ondragenter

    Public Delegate Sub OnDragEnterDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event ondragenter As OnDragEnterDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondragenter", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' ondragexit

    Public Delegate Sub OnDragExitDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event ondragexit As OnDragExitDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondragexit", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' ondragleave

    Public Delegate Sub OnDragLeaveDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event ondragleave As OnDragLeaveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondragleave", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' ondragover

    Public Delegate Sub OnDragOverDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event ondragover As OnDragOverDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondragover", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' ondragstart

    Public Delegate Sub OnDragStartDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event ondragstart As OnDragStartDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondragstart", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' ondrop

    Public Delegate Sub OnDropDelegate(sender as HTMLElement, e As DragEvent)

    Public Custom Event ondrop As OnDropDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As DragEvent))
        CType(Me, EcmaScriptObject).AddEvent("ondrop", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), DragEvent)))
      End AddHandler
    End Event

    ' ondurationchange

    Public Delegate Sub OnDurationChangeDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event ondurationchange As OnDurationChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("ondurationchange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onemptied

    Public Delegate Sub OnEmptiedDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onemptied As OnEmptiedDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onemptied", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onended

    Public Delegate Sub OnEndedDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onended As OnEndedDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onended", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onformdata

    Public Delegate Sub OnFormDataDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onformdata As OnFormDataDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onformdata", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' ongotpointercapture

    Public Delegate Sub OnGotPointerCaptureDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event ongotpointercapture As OnGotPointerCaptureDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("ongotpointercapture", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' oninput

    Public Delegate Sub OnInputDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event oninput As OnInputDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("oninput", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' oninvalid

    Public Delegate Sub OnInvalidDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event oninvalid As OnInvalidDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("oninvalid", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onkeydown

    Public Delegate Sub OnKeyDownDelegate(sender as HTMLElement, e As KeyboardEvent)

    Public Custom Event onkeydown As OnKeyDownDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As KeyboardEvent))
        CType(Me, EcmaScriptObject).AddEvent("onkeydown", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), KeyboardEvent)))
      End AddHandler
    End Event

    ' onkeypress

    Public Delegate Sub OnKeyPressDelegate(sender as HTMLElement, e As KeyboardEvent)

    Public Custom Event onkeypress As OnKeyPressDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As KeyboardEvent))
        CType(Me, EcmaScriptObject).AddEvent("onkeypress", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), KeyboardEvent)))
      End AddHandler
    End Event

    ' onkeyup

    Public Delegate Sub OnKeyUpDelegate(sender as HTMLElement, e As KeyboardEvent)

    Public Custom Event onkeyup As OnKeyUpDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As KeyboardEvent))
        CType(Me, EcmaScriptObject).AddEvent("onkeyup", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), KeyboardEvent)))
      End AddHandler
    End Event

    ' onload

    Public Delegate Sub OnLoadDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onload As OnLoadDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onload", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onloadeddata

    Public Delegate Sub OnLoadedDataDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onloadeddata As OnLoadedDataDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onloadeddata", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onloadedmetadata

    Public Delegate Sub OnLoadedMetaDataDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onloadedmetadata As OnLoadedMetaDataDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onloadedmetadata", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onloadend

    Public Delegate Sub OnLoadEndDelegate(sender as HTMLElement, e As ProgressEvent)

    Public Custom Event onloadend As OnLoadEndDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As ProgressEvent))
        CType(Me, EcmaScriptObject).AddEvent("onloadend", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), ProgressEvent)))
      End AddHandler
    End Event

    ' onloadstart

    Public Delegate Sub OnLoadStartDelegate(sender as HTMLElement, e As ProgressEvent)

    Public Custom Event onloadstart As OnLoadStartDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As ProgressEvent))
        CType(Me, EcmaScriptObject).AddEvent("onloadstart", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), ProgressEvent)))
      End AddHandler
    End Event

    ' onlostpointercapture

    Public Delegate Sub OnLostPointerCaptureDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onlostpointercapture As OnLostPointerCaptureDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onlostpointercapture", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onmousedown

    Public Delegate Sub OnMouseDownDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onmousedown As OnMouseDownDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onmousedown", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onmouseenter

    Public Delegate Sub OnMouseEnterDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onmouseenter As OnMouseEnterDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onmouseenter", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onmouseleave

    Public Delegate Sub OnMouseLeaveDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onmouseleave As OnMouseLeaveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onmouseleave", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onmousemove

    Public Delegate Sub OnMouseMoveDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onmousemove As OnMouseMoveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onmousemove", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onmouseout

    Public Delegate Sub OnMouseOutDelegate(sender as HTMLElement, e As MouseEvent)

    Public Custom Event onmouseout As OnMouseOutDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As MouseEvent))
        CType(Me, EcmaScriptObject).AddEvent("onmouseout", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), MouseEvent)))
      End AddHandler
    End Event

    ' onwheel

    Public Delegate Sub OnWheelDelegate(sender as HTMLElement, e As WheelEvent)

    Public Custom Event onwheel As OnWheelDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As WheelEvent))
        CType(Me, EcmaScriptObject).AddEvent("onwheel", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), WheelEvent)))
      End AddHandler
    End Event

    ' onpause

    Public Delegate Sub OnPauseDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onpause As OnPauseDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onpause", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onplay

    Public Delegate Sub OnPlayDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onplay As OnPlayDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onplay", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onplaying

    Public Delegate Sub OnPlayingDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onplaying As OnPlayingDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onplaying", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onpointerdown

    Public Delegate Sub OnPointerDownDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onpointerdown As OnPointerDownDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointerdown", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onpointermove

    Public Delegate Sub OnPointerMoveDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onpointermove As OnPointerMoveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointermove", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onpointerup

    Public Delegate Sub OnPointerUpDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onpointerup As OnPointerUpDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointerup", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onpointercancel

    Public Delegate Sub OnPointerCancelDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onpointercancel As OnPointerCancelDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointercancel", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onpointerover

    Public Delegate Sub OnPointerOverDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onpointerover As OnPointerOverDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointerover", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onpointerout

    Public Delegate Sub OnPointerOutDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onpointerout As OnPointerOutDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointerout", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onpointerenter

    Public Delegate Sub OnPointerEnterDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onpointerenter As OnPointerEnterDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointerenter", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onpointerleave

    Public Delegate Sub OnPointerLeaveDelegate(sender as HTMLElement, e As PointerEvent)

    Public Custom Event onpointerleave As OnPointerLeaveDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As PointerEvent))
        CType(Me, EcmaScriptObject).AddEvent("onpointerleave", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), PointerEvent)))
      End AddHandler
    End Event

    ' onprogress

    Public Delegate Sub OnProgressDelegate(sender as HTMLElement, e As ProgressEvent)

    Public Custom Event onprogress As OnProgressDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As ProgressEvent))
        CType(Me, EcmaScriptObject).AddEvent("onprogress", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), ProgressEvent)))
      End AddHandler
    End Event

    ' onratechange

    Public Delegate Sub OnRateChangeDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onratechange As OnRateChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onratechange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onreset

    Public Delegate Sub OnResetDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onreset As OnResetDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onreset", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onresize

    Public Delegate Sub OnResizeDelegate(sender as HTMLElement, e As UIEvent)

    Public Custom Event onresize As OnResizeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As UIEvent))
        CType(Me, EcmaScriptObject).AddEvent("onresize", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), UIEvent)))
      End AddHandler
    End Event

    ' onscroll

    Public Delegate Sub OnScrollDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onscroll As OnScrollDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onscroll", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onseeked

    Public Delegate Sub OnSeekedDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onseeked As OnSeekedDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onseeked", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onseeking

    Public Delegate Sub OnSeekingDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onseeking As OnSeekingDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onseeking", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onselect

    Public Delegate Sub OnSelectDelegate(sender as HTMLElement, e As UIEvent)

    Public Custom Event onselect As OnSelectDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As UIEvent))
        CType(Me, EcmaScriptObject).AddEvent("onselect", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), UIEvent)))
      End AddHandler
    End Event

    ' onselectstart

    Public Delegate Sub OnSelectStartDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onselectstart As OnSelectStartDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onselectstart", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onselectionchange

    Public Delegate Sub OnSelectionChangeDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onselectionchange As OnSelectionChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onselectionchange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onstalled

    Public Delegate Sub OnStalledDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onstalled As OnStalledDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onstalled", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onsubmit

    Public Delegate Sub OnSubmitDelegate(sender as HTMLElement, e As SubmitEvent)

    Public Custom Event onsubmit As OnSubmitDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As SubmitEvent))
        CType(Me, EcmaScriptObject).AddEvent("onsubmit", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), SubmitEvent)))
      End AddHandler
    End Event

    ' onsuspend

    Public Delegate Sub OnSuspendDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onsuspend As OnSuspendDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onsuspend", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' ontimeupdate

    Public Delegate Sub OnTimeUpdateDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event ontimeupdate As OnTimeUpdateDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("ontimeupdate", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onvolumechange

    Public Delegate Sub OnVolumeChangeDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onvolumechange As OnVolumeChangeDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onvolumechange", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

    ' onwaiting

    Public Delegate Sub OnWaitingDelegate(sender as HTMLElement, e As Dom.Event)

    Public Custom Event onwaiting As OnWaitingDelegate
      AddHandler(Value As Sub(sender as HTMLElement, e As Dom.Event))
        CType(Me, EcmaScriptObject).AddEvent("onwaiting", Sub(e As EcmaScriptObject) RaiseEvent Value(Me, CType(e(0), Dom.Event)))
      End AddHandler
    End Event

  End Class

End Namespace