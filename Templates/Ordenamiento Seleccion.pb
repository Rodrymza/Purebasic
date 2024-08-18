
Procedure ordenar(Array arr(1))
For i=0 To ArraySize(arr())-1
  For j=i To ArraySize(arr())-1
    If arr(i)>arr(j)
      Swap arr(i), arr(j)
    EndIf
  Next
Next
EndProcedure

Dim lista(20)
For i=0 To 20
  lista(i)=Random(30)
Next

ordenar(lista())

For i=0 To ArraySize(lista())
  Debug lista(i)
Next





; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 11
; Folding = -
; EnableXP
; DPIAware