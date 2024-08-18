Procedure.i Partition(Array lista.l(1), minimo.i, maximo.i)
  pivot = lista(maximo)
  i = minimo - 1

  For j = minimo To maximo - 1
    If lista(j) <= pivot
      i + 1
      Swap lista(i), lista(j)
    EndIf
  Next j

  Swap lista(i + 1), lista(maximo)
  ProcedureReturn i + 1
EndProcedure

Procedure QuickSort(Array lista.l(1), minimo.i, maximo.i)
  If minimo < maximo
    pi = Partition(lista(), minimo, maximo)

    QuickSort(lista(), minimo, pi - 1)
    QuickSort(lista(), pi + 1, maximo)
  EndIf
EndProcedure

Dim numeros.l(50)  ; Cambiado a 19 para tener 20 elementos
For i = 0 To ArraySize(numeros()) - 1
  numeros(i) = Random(100)  ; Llenar el array con valores aleatorios
Next

Debug "Antes de ordenar:"
For i = 0 To ArraySize(numeros()) - 1
  Debug numeros(i)
Next

QuickSort(numeros(), 0, ArraySize(numeros()) - 1)

Debug "Después de ordenar:"
For i = 0 To ArraySize(numeros()) - 1
  Debug numeros(i)
Next
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 24
; Folding = -
; EnableXP