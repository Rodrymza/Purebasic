
Repeat
  palabra.s=InputRequester("Ingreso de frase","Ingrese frase a analizar (salir para terminar)","")
  If Not palabra="salir"
    palabra=Trim(palabra) + " "
  EndIf
  
  cont=0
  For i=1 To Len(palabra)
    If Mid(palabra,i,1) = " "
      cont+1
      
      While Mid(palabra,i+1,1) = " "
        i+1
      Wend
      
    EndIf
  Next
  If palabra=" " Or palabra=""
    cont=0
  EndIf   
  
  If palabra="salir"
    MessageRequester("Salir","Salida del programa", #PB_MessageRequester_Ok)
  Else
    MessageRequester("Palabras contadas","Ingresaste " + cont + " palabras", #PB_MessageRequester_Info)
  EndIf 
  
Until palabra="salir"
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 23
; EnableXP
; HideErrorLog