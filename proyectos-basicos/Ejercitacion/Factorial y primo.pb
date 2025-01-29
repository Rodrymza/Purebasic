Procedure factorial(num)
  r=1
  For i=1 To num
    r=i*r
  Next
  ProcedureReturn r
EndProcedure

Procedure.s esprimo(num)
  
  For i=1 To num
    If num%i=0
      divisores=divisores+1
    EndIf
  Next
  
  If divisores<=2
    ProcedureReturn "Es primo"
  Else
    ProcedureReturn "No es primo"
  EndIf 
  
EndProcedure

For i=1 To 10
  Debug "Factorial de " + i + " = " + factorial(i) + " -- " + esprimo(i)
Next

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 25
; Folding = -
; EnableXP
; DPIAware