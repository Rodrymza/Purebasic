NewList nombres$()

OpenConsole()
EnableGraphicalConsole(1)
For i=0 To 2
  PrintN("Ingresa un nombre")
  name$=Input()
  InsertElement(nombres$())       ;addelement coloca un elemento al final despues del elemento actual, insertelement lo coloca antes
  nombres$()=name$
  ClearConsole()
Next

ForEach nombres$()
  PrintN(nombres$())
Next

Input()
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 7
; EnableXP