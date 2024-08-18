NewList numeros()

For i=0 To 9
  AddElement(numeros())
  numeros()=Random(20)
Next
Dim lista(ListSize(numeros()))
i=0
ForEach numeros()
  lista(i)=numeros()
  Debug lista(i)
  i=i+1
Next
Debug "ordenacion"
SortArray(lista(),#PB_Sort_Descending)
For i=0 To ArraySize(lista())
  Debug lista(i)
Next

  

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 20
; EnableXP
; DPIAware