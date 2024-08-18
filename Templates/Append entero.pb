Procedure append(Array lista(1),elemento)
  
  ReDim lista(ArraySize(lista())+1)
  lista(ArraySize(lista()))=elemento
  
EndProcedure

Dim num(1)
num(0)=0
num(1)=1
append(num(),2)

For i=0 To 2
  Debug num(i)
Next

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 9
; Folding = -
; EnableXP