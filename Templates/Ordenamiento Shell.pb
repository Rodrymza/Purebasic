
Procedure ordenamientoshell(Array vector$(1))
;ordenamiento  shell
salto.i=ArraySize(vector$())
Debug salto
While salto>1
  salto=salto/2
  Repeat
    cambios=#False 
    For i=0 To ArraySize(vector$()) - salto
      j=i+salto
      If vector$(j)<vector$(i)
        Swap vector$(j), vector$(i)
        cambios=#True
      EndIf 
    Next
  Until cambios=#False  
Wend  
EndProcedure

Dim nombres.s(4)

nombres(0)= "Jesus" : nombres(1)= "Francisco" : nombres(2)= "Martin" : nombres(3)= "Aldana" : nombres(4)= "Roberto" 
ordenamientoshell(nombres())
For i=0 To ArraySize(nombres())
  Debug nombres(i)
Next


; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 15
; Folding = -
; EnableXP