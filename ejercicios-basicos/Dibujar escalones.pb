;escalera
; con simbolos __|
OpenConsole()
PrintN("Ingrese la cantidad de escalones")
escalones = 0
Repeat  
  escalones = Val(Input())
  dibujo.s=""
  
  If escalones<0
    For i = 1 To -escalones
      dibujo = Space(Len(dibujo)) + "|__"
      PrintN(dibujo)
    Next
    
  ElseIf escalones>0
    largo = (escalones*3)
    dibujo = "__"
    
    While largo>1
      dibujo = Space(largo-3) + "__|"
      PrintN(dibujo)
      largo - 3
    Wend  
  Else
    Print("Ingresaste el numero 0, saliendo del programa")
    
  EndIf
Until escalones = 0
Input()

CloseConsole()
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 14
; EnableXP
; HideErrorLog