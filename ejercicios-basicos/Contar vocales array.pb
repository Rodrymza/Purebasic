;funcion que reciba un cadena de texto y retorne la vocal que mas veces se repita
;tener en cuenta vocales acentuadas y con dieresis

Procedure vocal_mas_repetida(string.s)
  
  Dim vocales.s(4)
  Dim cantidad_vocales(4)
  vocales(0) = "a" :  vocales(1) = "e" :  vocales(2) = "i" :  vocales(3) = "o" :  vocales(4) = "u" 
  
  For i = 1 To Len(string)
    letra.s = Mid(string,i,1)
    Select letra
      Case "a", "á", "ä"
        cantidad_vocales(0) + 1
      Case "e", "é", "ë"
        cantidad_vocales(1) + 1
      Case "i", "í", "ï"
        cantidad_vocales(2) + 1
      Case "o", "ö", "ó"
        cantidad_vocales(3) + 1
      Case "u", "ú", "ü"
        cantidad_vocales(4) + 1
    EndSelect
  Next
  mayor=0
  For i=0 To ArraySize(vocales())
    If cantidad_vocales(i)>mayor
      mayor=cantidad_vocales(i)
      indice_mayor=i
    ElseIf cantidad_vocales(i)>0 And cantidad_vocales(i) = mayor
      Debug "hay vocales en el mismo numero"
    EndIf
  Next
  Debug "Vocal mas repetida: ***" + vocales(indice_mayor) + "*** veces repetida: " + cantidad_vocales(indice_mayor)
 
EndProcedure


vocal_mas_repetida("Rodrigo")


; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 38
; Folding = -
; EnableXP
; HideErrorLog