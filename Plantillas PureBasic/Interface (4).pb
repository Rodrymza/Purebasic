; Interface (4)
; Programa de ejemplo para entender conceptos básicos
; para compilar use F5 o vaya al menu Compiler/Compile-Run

Enumeration
#WIN_MAIN
#TEXT_INPUT
#STRING_INPUT
#LIST_INPUT
#BUTTON_INTERACT
#BUTTON_CLOSE
EndEnumeration

Global Quit.b = #False

#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered ;combinacion OR para encadenar propiedades

If OpenWindow(#WIN_MAIN, 0, 0, 300, 200, "Interacción", #FLAGS)
      If CreateGadgetList(WindowID(#WIN_MAIN))
         TextGadget(#TEXT_INPUT, 10, 10, 280, 20, "Ingrese texto aqui")   
         StringGadget(#STRING_INPUT, 10, 30, 280, 20, "aqui...")
         ListViewGadget(#LIST_INPUT, 10, 60, 280, 100)
         ButtonGadget(#BUTTON_INTERACT, 10, 170, 120, 20, "Agregar al Listview")
         ButtonGadget(#BUTTON_CLOSE, 190, 170, 100, 20, "Cerrar ventana")
         
         SetActiveGadget(#STRING_INPUT) ;focus del programa
         
         Repeat
            Event.l = WaitWindowEvent()
            ;desactive Debug Event para ver lo que sucede
            Debug Event ; ventana debug para ver eventos encadenados al programa
            
            Select Event 
               Case #PB_Event_Gadget
                  Select EventGadget()
                     Case #BUTTON_INTERACT
                        AddGadgetItem(#LIST_INPUT, -1, GetGadgetText(#STRING_INPUT))
                        SetGadgetText(#STRING_INPUT, "")
                        SetActiveGadget(#STRING_INPUT)
                     Case #BUTTON_CLOSE
                        Quit = #True
                  EndSelect
            EndSelect
         Until Event = #PB_Event_CloseWindow Or Quit = #True
       
      EndIf
EndIf
 
End
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 15
; EnableXP