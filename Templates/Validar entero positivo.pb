Procedure validarInt(entrada$)
  Protected i
  r=#True
  For i=1 To Len(entrada$)
    If Mid(entrada$,i,1)<"0" Or Mid(entrada$,i,1)>"9"
      r=#False 
    EndIf
  Next
  ProcedureReturn r
EndProcedure


numero.s="A"

If Not validarInt(numero)
  Debug "es falso"
EndIf

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 14
; Folding = -
; EnableXP
; DPIAware