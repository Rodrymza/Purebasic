;*
 ;* Crea un programa se encargue de transformar un número
 ;* decimal a binario sin utilizar funciones propias del lenguaje que lo hagan directamente.
 ;*/
 
 num = 234
 binario.s = ""
 While num>0
   If Len(binario) = 4
     binario = " " + binario
   EndIf 
   
   binario = Str(num%2) + binario
   num/2
 Wend 
 
 Debug binario
 
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; EnableXP
; HideErrorLog