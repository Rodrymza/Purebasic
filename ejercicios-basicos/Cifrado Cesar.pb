;Cifrado cesar
;Crear programa que realize el cofrsdo cesar de un codigo y lo imprima
;Tammbien debe ser capaz de descifrarlos cuando asi se lo indiquemos



Procedure.s cifrado(frase_original.s, salto=2, cifrado=0)
  If cifrado = 1
    salto = -(salto)
  EndIf 
  
  abecedario.s = "abcdefghijklmnñopqrstuvwxyz"
  For i = 1 To Len(frase_original)

    caracter.s = LCase(Mid(frase_original, i, 1))
    If caracter = " "
      frase_encriptada.s + " "
    Else 
      indice = FindString(abecedario, caracter)
      If indice + salto <= Len(abecedario)
        frase_encriptada + Mid(abecedario,indice + salto, 1)
      ElseIf indice + salto < 1
        frase_encriptada + Mid(abecedario, (indice + salto + Len(abecedario)), 1)
      Else
        frase_encriptada + Mid(abecedario, (indice + salto - Len(abecedario)), 1)
      EndIf
    EndIf 
    If cifrado = 1 
      salto - 1
    Else
      salto + 1
    EndIf 
    
  Next
  ProcedureReturn frase_encriptada
EndProcedure

salto = 5
cifrado.s=cifrado("rodrigo",salto)
Debug cifrado 

descifrado.s = cifrado(cifrado,salto,1)
Debug descifrado  

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 37
; Folding = -
; EnableXP
; HideErrorLog