Procedure fibonacci(pos)
  If pos<=1
    ProcedureReturn pos
  Else
    ProcedureReturn fibonacci(pos-1)+fibonacci(pos-2)
  EndIf 
  
EndProcedure

For i=0 To 20
  Debug fibonacci(i)
Next

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 2
; Folding = -
; EnableXP