OpenConsole("Tablas de multiplicar")
EnableGraphicalConsole(1)

Define.d num, resultado
Define.i i
num=1
Dim lista.d(10)

Enumeration
   #WIN_MAIN
   #BUTTON_0
   #BUTTON_1
   #BUTTON_2
   #BUTTON_3
   #BUTTON_4
   #BUTTON_5
   #BUTTON_6
   #BUTTON_7
 EndEnumeration

 #FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered
 
 Procedure AbrirVentana()
  Window_1 = OpenWindow(#PB_Any, 0, 0, 300, 400, "Escribir dato a arreglo", #FLAGS)
  String_0 = StringGadget(#PB_Any, 70, 80, 190, 70, "")
  Text_1 = TextGadget(#PB_Any, 110, 40, 100, 25, "Ingrese un texto")
  
EndProcedure

While num>0
  PrintN("Ingresa un numero para ver su tabla de multiplicar")
  num=Val(Input())
  
  ConsoleLocate(30,10)
  PrintN("Tabla del " + Str(num) + ":")
  
  For i=1 To 10
    resultado=i*num
    ConsoleLocate(60,i*2)
    lista(i)=resultado
    PrintN( Str(num) + "x" + Str(i) + "= " + Str(resultado)  )
    
  Next
  Abrirventana()
  
  For i=1 To 10
    PrintN( Str(lista(i)) )
  Next
  
Wend


Input()
; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 27
; Folding = -
; EnableXP