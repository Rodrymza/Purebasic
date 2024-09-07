;list library for Purebasic
;Rodry Ramirez(c) 2024

Procedure.s appendString(List list_param.s(), element.s)
  AddElement(list_param())
  list_param() = element 
EndProcedure

Procedure.f appendFloat(List list_param.f(), element.f)
  AddElement(list_param())
  list_param() = element 
EndProcedure

Procedure.i appendInt(List list_param.i(), element.i)
  AddElement(list_param())
  list_param() = element 
EndProcedure

Procedure.s popString(List list_param.s())
  LastElement(list_param())
  element.s=list_param()
  DeleteElement(list_param())
  ProcedureReturn element
EndProcedure

Procedure.f popFloat(List list_param.f())
  LastElement(list_param())
  element.f=list_param()
  DeleteElement(list_param())
  ProcedureReturn element
EndProcedure

Procedure.i popInt(List list_param.i())
  LastElement(list_param())
  element.i=list_param()
  DeleteElement(list_param())
  ProcedureReturn element
EndProcedure

Procedure removeListString(List list_param.s(), index = -1)
  If index=-1
    LastElement(list_param())
    DeleteElement(list_param())
  Else
    If index<ListSize(list_param())
      SelectElement(list_param(), index)
      DeleteElement(list_param())
    Else
      MessageRequester("Error","Index out of range",#PB_MessageRequester_Error)
    EndIf 
  EndIf 
EndProcedure

Procedure removeListFloat(List list_param.f(), index = -1)
  If index=-1
    LastElement(list_param())
    DeleteElement(list_param())
  Else
    If index<ListSize(list_param())
      SelectElement(list_param(), index)
      DeleteElement(list_param())
    Else
      MessageRequester("Error","Index out of range",#PB_MessageRequester_Error)
    EndIf 
  EndIf 
EndProcedure

Procedure removeListInt(List list_param.i(), index = -1)
  If index=-1
    LastElement(list_param())
    DeleteElement(list_param())
  Else
    If index<ListSize(list_param())
      SelectElement(list_param(), index)
        DeleteElement(list_param())
    Else
      MessageRequester("Error","Index out of range",#PB_MessageRequester_Error)
    EndIf 
  EndIf 
EndProcedure

Procedure insertStringElement(List list_param.s(), element.s, index)
  If index<ListSize(list_param())
    SelectElement(list_param(), index)
    InsertElement(list_param())
    list_param() = element
  Else
    MessageRequester("Error","Index out of range", #PB_MessageRequester_Error)
  EndIf 
EndProcedure

Procedure insertFloatElement(List list_param.f(), element.f, index)
  If index<ListSize(list_param())
    SelectElement(list_param(), index)
    InsertElement(list_param())
    list_param() = element
  Else
    MessageRequester("Error","Index out of range", #PB_MessageRequester_Error)
  EndIf 
EndProcedure

Procedure insertIntElement(List list_param.i(), element.i, index)
  If index<ListSize(list_param())
    SelectElement(list_param(), index)
    InsertElement(list_param())
    list_param() = element
  Else
    MessageRequester("Error","Index out of range", #PB_MessageRequester_Error)
  EndIf 
EndProcedure

Procedure extendStringList(List origin_list.s(), List destination_list.s())
  ForEach origin_list()
    AddElement(destination_list())
    destination_list()=origin_list()
  Next
EndProcedure

Procedure extendFloatList(List origin_list.f(), List destination_list.f())
  ForEach origin_list()
    AddElement(destination_list())
    destination_list()=origin_list()
  Next
EndProcedure

Procedure extendIntList(List origin_list.i(), List destination_list.i())
  ForEach origin_list()
    AddElement(destination_list())
    destination_list()=origin_list()
  Next
EndProcedure

Procedure invertStringList(List list_param.s())
  NewList aux_list.s()
  AddElement(aux_list())
  ForEach list_param()
    insertStringElement(aux_list(),list_param(), 0)
  Next
  ForEach aux_list()
    SplitList(aux_list(), list_param())
  Next
EndProcedure

Procedure invertFloatList(List list_param.f())
  NewList aux_list.f()
  AddElement(aux_list())
  ForEach list_param()
    insertStringElement(aux_list(),list_param(), 0)
  Next
  ForEach aux_list()
    SplitList(aux_list(), list_param())
  Next
EndProcedure

Procedure invertIntList(List list_param.i())
  NewList aux_list.i()
  AddElement(aux_list())
  ForEach list_param()
    insertStringElement(aux_list(),list_param(), 0)
  Next
  ForEach aux_list()
    SplitList(aux_list(), list_param())
  Next
EndProcedure

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 141
; FirstLine = 19
; Folding = AA5-
; EnableXP
; HideErrorLog