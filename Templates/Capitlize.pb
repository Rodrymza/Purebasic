Procedure.s capitalize(text.s)
  ProcedureReturn UCase(Mid(text,1,1))+LCase(Mid(text,2,Len(text)))
EndProcedure

Debug capitalize("hola gente como va")
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 4
; Folding = -
; EnableXP
; HideErrorLog