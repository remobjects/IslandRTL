Namespace Global.RemObjects.Elements.WebAssembly

  //use SetEvent to wire an HTML / Javascript event to a method
  //use ClearEvent to unwire it.

  //For Mercury Only: You only need this for dynamic wired events. Static wired events can be handled using the Handles clause on the methods

  Public Module WasmEvents
    Public window As Window = Browser.GetWindowObject
    Public document as Document = window.document

    Dim NextId As ULong = 0
    //event system
    Public delegate Sub EventDelegate(sender as HTMLElement, e As Dynamic)

    Private EventIds As New Dictionary(Of String, EventDelegate)
    Private EventSource As New Dictionary(Of String, HTMLElement)

    Public Function GetEventDelegate(element As HTMLElement, EventName As String) As EventDelegate
      dim id As String = element.getAttribute(EventName)
      If assigned(id) then
        return EventIds(id)
      Else
        Return nothing
      End If
    End Function

    Public Sub SetEvent(element As HTMLElement, EventName As String, del As EventDelegate)
      If Not assigned(element) Then
        Throw New ArgumentException("Element cannot be nil")
      End If
      ClearEvent(element, EventName)
      If del IsNot Nothing then
        Dim Id As String = NextId.ToString
        NextId += 1
        EventIds.Add(Id, del)
        EventSource.Add(Id, element)
        element.setAttribute(EventName.ToLower, $"WasmEvent('{Id}');")
      End If
    End Sub

    Public Sub ClearEvent(element As HTMLElement, EventName As String)
      If Not assigned(element) Then
        Throw New ArgumentException("Element cannot be nil")
      End If
      dim id As String = element.getAttribute(EventName.ToLower)
      If assigned(id) then
        EventIds.Remove(id)
        EventSource.Remove(id)
        element.setAttribute(EventName.ToLower, "")
      End If
    End Sub

    Public Function GetEventDelegate(Id As String) As EventDelegate
      Return EventIds(Id)
    End Function

    Public Function GetEventSource(Id As String) As HTMLElement
      Return EventSource(Id)
    End Function
  End Module

End Namespace