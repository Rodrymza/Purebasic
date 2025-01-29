minusculas.s = "abcdefghijklmnopqrstuvwxyz"
mayusculas.s = UCase(minusculas)
simbolos.s = "!@#$%~&*()_+-=[]{}|;:',.<>?/"
numeros.s = "0123456789"

con_minusculas = 1
con_mayusculas = 1
con_simbolos = 0
con_numeros = 1
long_min = 8
long_max = 16
long_final = Random(long_max,long_min)
cadenafinal.s = ""

If con_minusculas
  cadenafinal + minusculas
EndIf 

If con_mayusculas
  cadenafinal + mayusculas
EndIf 

If con_numeros
  cadenafinal + numeros
EndIf 

If con_simbolos
  cadenafinal + simbolos
EndIf

For i=1 To 12
  password.s + Mid(cadenafinal,Random(Len(cadenafinal)),1)
Next
Debug password
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 1
; EnableXP
; HideErrorLog