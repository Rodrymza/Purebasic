;Verificar si un palabra es un anagrama de otra

palabra.s="amor"
palabrados.s="roma"

Procedure.s Listar_elemento(string.s, List lista_palabra.s())
  For i=1 To Len(string)
    AddElement(lista_palabra())
    lista_palabra()=Mid(string,i,1)
  Next
  SortList(lista_palabra(), #PB_Sort_Ascending)
  EndProcedure

Procedure is_anagram(string1.s, string2.s)
  NewList String1_list.s()
  NewList String2_list.s()
  
  Listar_elemento(string1, String1_list())
  Listar_elemento(string2, String2_list())
  
  string1=""
  string2=""
  ForEach String2_list()
    string2=string2 + String2_list()
  Next
  
  ForEach String1_list()
    string1=string1 + String1_list()
  Next
  
  
  If string1 = string2
    Debug "es un anagrama"
  Else
    Debug "no es un anagrama"
  EndIf
  
EndProcedure


is_anagram(palabra, palabrados)


; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; Folding = -
; EnableXP
; HideErrorLog