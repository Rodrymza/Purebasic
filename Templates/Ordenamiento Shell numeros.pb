Procedure ordenamientoshell(Array arr(1))
;ordenamiento  shell
salto.i=ArraySize(arr())
Debug salto
While salto>1
  salto=salto/2
  Repeat
    cambios=#False 
    For i=0 To ArraySize(arr()) - salto
      j=i+salto
      If arr(j)<arr(i)
        Swap arr(j), arr(i)
        cambios=#True
      EndIf 
    Next
  Until cambios=#False  
Wend  
EndProcedure

Dim lista(20)

For i=0 To ArraySize(lista())
  lista(i)=Random(30)
  Debug lista(i)
Next

ordenamientoshell(lista())

For i=0 To ArraySize(lista())
  Debug lista(i)
Next

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 31
; Folding = -
; EnableXP