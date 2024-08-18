Procedure$ formatear_largo(palabra$,largo)
  
  If Len(palabra$)<largo
    palabra_form$=palabra$ + Space(largo-Len(palabra$))
  EndIf
  ProcedureReturn palabra_form$
  
EndProcedure
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 7
; Folding = -
; EnableXP