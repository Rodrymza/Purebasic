Procedure BusquedaBinaria(busqueda$, Array lista$(1))
   Primero.i = 0
   Ultimo.i= ArraySize(lista$()) - 1 
   Central.i = 0  ; Verdadero o SI
   Encontrado.i = #False ;Falso o NO Encontrado
   
   While Not Encontrado And Primero <= Ultimo
     
     Central = Int((Primero + Ultimo) / 2) 
     
     If LCase(busqueda$) = LCase(lista$(Central)) 
       
       Encontrado = #True
       posicion=central
     Else
       
       If LCase(lista$(Central)) >   LCase(busqueda$)
         Ultimo =  Central - 1
       Else 
         Primero = Central + 1
       EndIf
       
     EndIf  
     
   Wend  
   
   If Encontrado = #True
     MessageRequester("Busqueda exitosa","Elemento encontrado en la posicion " + Str(posicion))
     
   Else
     MessageRequester("Errror","No se encontro el elemento buscado")
   EndIf

EndProcedure

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 16
; Folding = -
; EnableXP