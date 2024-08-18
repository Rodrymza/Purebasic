;Calcular el perímetro y área de un rectángulo dada su base y su altura.

OpenConsole()

Define.d base,altura,perimetro

Repeat
  PrintN("Bievenido, vamos a calcular el perimetro de un rectangulo")
  PrintN("Ingrese la base del rectangulo")
  base=ValD(Input())
  PrintN("Ingrese la altura del rectangulo")
  altura=ValD(Input())

  perimetro=(base*2)+(altura*2)
  
  PrintN("El perimetro del rectangulo es " + perimetro )
  If altura=base
    PrintN("El rectangulo es un cuadrado")
  EndIf
  

 Until perimetro=0
; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 19
; EnableXP