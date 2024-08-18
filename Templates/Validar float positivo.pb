Procedure ValidarFloat(entrada$)
  Protected i,j
  r=#True
  i=1
  validos$=".1234567890"
  Debug i
  For i=1 To Len(entrada$)
    For j=1 To Len(validos$)
      If Mid(entrada$,i,1)=Mid(validos$,j,1)
        cont=cont+1
      EndIf 
    Next
    If Mid(entrada$,i,1)="."
      coma=coma+1
    EndIf 
  Next
  
  If cont<>Len(entrada$) Or coma>1
    r=#False
  EndIf
  ProcedureReturn r
EndProcedure

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 22
; Folding = -
; EnableXP
; DPIAware