Procedure GenerarCodigoUnico(cont,largo)
  code.s=Str(cont)
  For i=Len(code) To largo-1
    code=Str(Random(9))+code
  Next
  Debug code
EndProcedure


largo=7
For i=0 To 10
  cont=cont+1
  GenerarCodigoUnico(cont,largo)
Next


; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 9
; Folding = -
; EnableXP