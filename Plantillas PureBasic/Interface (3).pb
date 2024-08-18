; Interface (3)
; Programa de ejemplo para entender conceptos básicos
; para compilar use F5 o vaya al menu Compiler/Compile-Run

Enumeration
   #WIN_MAIN
   #TEXT_INPUT
   #STRING_INPUT
   #BUTTON_INTERACT
   #BUTTON_CLOSE
EndEnumeration
 
Global Quit.b = #False
 
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered
 
   If OpenWindow(#WIN_MAIN, 0, 0, 300, 200, "Ventana de interacción", #FLAGS)
      If CreateGadgetList(WindowID(#WIN_MAIN))
         TextGadget(#TEXT_INPUT, 10, 10, 280, 20, "Ingrese texto aqui:")
         StringGadget(#STRING_INPUT, 10, 30, 280, 20, "")
         ButtonGadget(#BUTTON_INTERACT, 10, 170, 120, 20, "Texto ingresado")
         ButtonGadget(#BUTTON_CLOSE, 190, 170, 100, 20, "Cerrar ventana")
         
         SetActiveGadget(#STRING_INPUT)
         
         Repeat
            Event.l = WaitWindowEvent()
            Select Event ;captura de eventos----------------
               
               Case #PB_Event_Gadget
                 
                  Select EventGadget() ;eventos de gadgets---
                     Case #BUTTON_INTERACT
                        Debug GetGadgetText(#STRING_INPUT) ;extrae el texto ingresado
                     Case #BUTTON_CLOSE
                        Quit = #True
                  EndSelect ;fin eventos de gadgets ---------
                 
             EndSelect   ;fin captura de eventos-------------
             
         Until Event = #PB_Event_CloseWindow Or Quit = #True
          
      EndIf ; created gadget list
   EndIf ;openwindow

End
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 33
; EnableXP