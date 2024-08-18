OpenConsole()
EnableGraphicalConsole(1)   ;hay que habilitar la consola en modo grafico para que se pueda limpiar la pantalla con el comando Clearconsole

For num=0 To 20
  If num%2=0
    
    PrintN( Str(num) + " Este numero es par ")
    Delay(500)
    ClearConsole()
  EndIf
  num=num+1
  
Next
Input()


; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 2
; EnableXP