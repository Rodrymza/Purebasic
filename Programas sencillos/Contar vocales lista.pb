;funcion que reciba un cadena de texto y retorne la vocal que mas veces se repita
;tener en cuenta vocales acentuadas y con dieresis

Procedure repetidas(string.s)
  Structure info
    letra.s
    cantidad.l
  EndStructure
  
  NewList vocales.info()
  AddElement(vocales()) : vocales()\letra = "a" :   AddElement(vocales()) : vocales()\letra = "e"
  AddElement(vocales()) : vocales()\letra = "i" :   AddElement(vocales()) : vocales()\letra = "o" :   AddElement(vocales()) : vocales()\letra = "u"
  ForEach vocales() : Debug Str(ListIndex(vocales())) + " " + vocales()\letra : Next
  For i = 1 To Len(string)
    letra.s = Mid(string,i,1)
    
    Select letra
      Case "a", "á", "ä"
        SelectElement(vocales(),0) : vocales()\cantidad + 1
      Case "e", "é", "ë"
        SelectElement(vocales(),1) : vocales()\cantidad + 1
      Case "i", "í", "ï"
        SelectElement(vocales(),2) : vocales()\cantidad + 1
      Case "o", "ö", "ó"
        SelectElement(vocales(),3) : vocales()\cantidad + 1
      Case "u", "ú", "ü"
        SelectElement(vocales(),4) : vocales()\cantidad + 1
    EndSelect
  Next
  SortStructuredList(vocales(),#PB_Sort_Descending,OffsetOf(info\cantidad),TypeOf(info\cantidad))
  FirstElement(vocales())
  Debug "Vocal mas repetida: ***" + vocales()\letra + "*** veces repetida: " + vocales()\cantidad
 
EndProcedure


repetidas("Rodrigo")


; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP
; HideErrorLog