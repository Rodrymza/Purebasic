
If ReadFile(0, "Ruta de archivo")    ;constante y ruta de archivo
   While Eof(0) = 0                 ;Leer todas las lineas
     texto$=texto$ + #CRLF$ + ReadString(0) ;Leer y agregar todas las lineas a variable
     ;Debug texto$
   Wend 
     CloseFile(0)
   
 Else
   MessageRequester("Error","No se pudo abrir el archivo")  ;Mensaje de error en caso de no encontrar archivo
 EndIf
 
  

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 9
; EnableXP