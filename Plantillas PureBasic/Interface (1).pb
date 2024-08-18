; Interface (1)
; Programa de ejemplo para entender conceptos básicos
; para compilar use F5 o vaya al menu Compiler/Compile-Run

#WINDOW_MAIN = 1 ; el simbolo # indica que es una constante
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered ;combinacion OR para encadenar propiedades

   If OpenWindow(#WINDOW_MAIN, 0, 0, 300, 200, "Hello World", #FLAGS)
      Repeat
         Event.l = WaitWindowEvent()
         ;desactive Debug Event para ver lo que sucede
         Debug Event ; ventana debug para ver eventos encadenados al programa
      Until Event = #PB_Event_CloseWindow
   EndIf

End
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 15
; EnableXP