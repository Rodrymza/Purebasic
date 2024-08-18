
Procedure$ title(palabra$)
  i.l=2
  r$=UCase(Mid(palabra$,1,1))
  While i<= Len(palabra$)
    If Mid(palabra$,i,1)=" "
      r$=r$+ UCase(Mid(palabra$,i,2))
      i=i+2
    Else
      r$=r$+LCase(Mid(palabra$,i,1))
      i=i+1
    EndIf
  Wend
  ProcedureReturn r$
EndProcedure

Procedure deletrear(palabra$)
  
  For i=1 To Len(palabra$)
    PrintN(Mid(palabra$,i,1))
  Next
  
EndProcedure




OpenConsole()
PrintN("Ingrese una palabra")
nombre$=Input()

nombre$=title(nombre$)

PrintN(nombre$)
Input()
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 33
; FirstLine = 1
; Folding = -
; EnableXP