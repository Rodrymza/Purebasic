Procedure.s capitalize(text.s)
  ProcedureReturn UCase(Mid(text,1,1))+LCase(Mid(text,2,Len(text)))
EndProcedure

Debug capitalize("hola")
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; Folding = -
; EnableXP
; HideErrorLog