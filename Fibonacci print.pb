num1=0
num2=1

While num2<1600
  numeros.s=numeros + Str(num1) + " " + Str(num2) + " "
  num1=num1+num2 
  num2=num1+num2
Wend
Debug numeros

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 4
; EnableXP