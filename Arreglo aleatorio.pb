


OpenConsole()
EnableGraphicalConsole(1)

Define.i tamanio

tamanio=Val(Input())

Dim lista.d(tamanio)

For i=0 To tamanio
  lista(i)=Random(100,0)
  PrintN("Lista " + Str(i) + " " + StrD(lista.d(i)))
Next



; For i=0 To tamanio
; 
;   PrintN("Lista " + Str(i) + " " + StrD(lista.d(i)))
;   Next
Input()
; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 19
; EnableXP