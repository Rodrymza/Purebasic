; Interface (2)
; Programa de ejemplo para entender conceptos básicos
; para compilar use F5 o vaya al menu Compiler/Compile-Run

Enumeration
   #WIN_MAIN
   #BUTTON_INTERACT
   #BUTTON_CLOSE
EndEnumeration
 
Global Quit.b = #False
 
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered

   If OpenWindow(#WIN_MAIN, 0, 0, 300, 200, "Interacción", #FLAGS)
       If CreateGadgetList(WindowID(#WIN_MAIN))
      
          ButtonGadget(#BUTTON_INTERACT, 10, 170, 100, 20, "Click aqui")
          ButtonGadget(#BUTTON_CLOSE, 190, 170, 100, 20, "Cerrar")
       
          Repeat
             Event.l = WaitWindowEvent()
       
             Select Event
                Case #PB_Event_Gadget
                   Select EventGadget()
                      Case #BUTTON_INTERACT
                         Debug "El botón CLICK AQUI fue presionado."
                       Case #BUTTON_CLOSE
                         Debug "El botón CERRAR fue presionado."
                         ;Quit = #True
                   EndSelect
             EndSelect
          Until Event = #PB_Event_CloseWindow Or Quit = #True
        EndIf
      EndIf
      
End
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 30
; FirstLine = 19
; EnableXP