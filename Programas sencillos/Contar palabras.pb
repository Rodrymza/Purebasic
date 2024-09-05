palabra.s=""

Procedure.s eliminar_espacios(string.s)
  string.s = Trim((string))
  While FindString(string, "  ")>0
   string = ReplaceString(string, "  ", " ")
  Wend 
  ProcedureReturn string
EndProcedure

Repeat
  palabra=eliminar_espacios(InputRequester("Ingreso de frase","Ingrese frase a analizar (salir para terminar)",""))
  Debug palabra
  cont=1      ;otra opcion es agregar un espacio al final de la cadena para que sume tambien la ultima palabra
  For i=1 To Len(palabra)
    If Mid(palabra,i,1) = " "
      cont+1
    EndIf
  Next
  If palabra=" " Or palabra=""
    cont=0
  EndIf   
  
  MessageRequester("Palabras contadas","Ingresaste " + cont + " palabras", #PB_MessageRequester_Info)
  
Until palabra="salir"




; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 11
; Folding = -
; EnableXP
; HideErrorLog