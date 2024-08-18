Procedure busquedaBinaria(Array lista.l(1),busqueda.l)
  minimo=0
  maximo=ArraySize(lista())
  While minimo<=maximo
    mitad=(minimo+maximo)/2
    If lista(mitad)=busqueda
      ProcedureReturn mitad
    ElseIf lista(mitad)<busqueda
      minimo=mitad+1
    Else
      maximo=mitad-1
    EndIf
  Wend
  ProcedureReturn -1
EndProcedure

  
OpenConsole()
PrintN("Ingresa longitud del array")
tamanio=Val(Input())
  Dim numeros.l(tamanio)
  For i=0 To ArraySize(numeros())
    numeros(i)=i
  Next
  PrintN("Ingresa numero a buscar")
  buscar.l=Val(Input())
  Debug busquedaBinaria(numeros(),buscar)
  
  



; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 11
; Folding = -
; EnableXP