;escribir funcion que reciba un texto y nos indique si es un palindromo o no

Repeat
cadena.s=InputRequester("Ingreso","Ingrese una palabra para ver si es palindromo","")
caracteres_a_eliminar.s=" .,-"

For i=1 To Len(caracteres_a_eliminar)
  cadena=RemoveString(cadena,Mid(caracteres_a_eliminar,i,1))
Next

For i=1 To Len(cadena)
  cadena_invertida.s= Mid(cadena,i,1) + cadena_invertida
Next

If cadena_invertida=cadena
  MessageRequester("Mensaje","La cadena es un palindromo")
Else
  MessageRequester("Mensaje","La cadena NO es un palindromo")
EndIf 

Until cadena="salir"
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 18
; EnableXP
; HideErrorLog