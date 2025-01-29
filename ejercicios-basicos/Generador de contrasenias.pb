;Generador de contraseñas
;permitir elegir si debe tener mayusculas, minusculas, simbolos o no

minusculas.s = "abcdefghijklmnopqrstuvwxyz"
mayusculas.s = UCase(minusculas)
simbolos.s = "!@#$%~&*()_+-=[]{}|;:',.<>?/"
numeros.s = "0123456789"

cadenafinal.s = ""

;distribucion de caracteres del pasword en porcentajes

porcentaje_minusculas.f = 0.3
porcentaje_mayusculas.f = 0.2
porcentaje_numeros.f = 0.35
porcentaje_simbolos.f = 0.15

long_password = Random(long_max, long_min)
Debug "longitud total " +  long_password

cantidad_minusculas = long_password * porcentaje_minusculas
cantidad_mayusculas = long_password * porcentaje_mayusculas
cantidad_numeros = long_password * porcentaje_numeros
cantidad_simbolos = long_password * porcentaje_simbolos

Debug cantidad_minusculas
Debug cantidad_mayusculas
Debug cantidad_numeros
Debug cantidad_simbolos

For i = 1 To cantidad_minusculas
  cadenafinal + Mid(minusculas, Random(Len(minusculas),1), 1)
Next

For i = 1 To cantidad_mayusculas
  cadenafinal + Mid(mayusculas, Random(Len(mayusculas),1), 1)
Next

For i = 1 To cantidad_numeros
  cadenafinal + Mid(numeros, Random(Len(numeros),1), 1)
Next

For i = 1 To cantidad_simbolos
  cadenafinal + Mid(simbolos, Random(Len(simbolos),1), 1)
Next
Debug cadenafinal

NewList lista_cadena.s()
For i = 1 To Len(cadenafinal)
  AddElement(lista_cadena()) : lista_cadena() = Mid(cadenafinal,i,1)
Next

RandomizeList(lista_cadena())

password.s=""
FirstElement(lista_cadena())
For i = 1 To ListSize(lista_cadena())
  password + lista_cadena()
  NextElement(lista_cadena())
Next

Debug password
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 9
; EnableXP
; HideErrorLog