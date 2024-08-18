
Procedure ventana_secundaria()
  
Propiedades.i = #ventana_secundaria | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget

OpenWindow(#PB_Any, 0, 0, 640, 340, "Nombre de ventana",Propiedades)
  
  ;Elementos de ventana (Gadgets y menus)
  
  Repeat 
    Event.l= WindowEvent()    ;esta linea capta los eventos que pasan en la ventana
    Select Event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_secundaria)
    
      Case #PB_Event_Menu
        Select EventMenu()
            
            
        EndSelect
      Case  #PB_Event_Gadget
        Select EventGadget()
            
            

        EndSelect
    EndSelect
    
    
  Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 6
; Folding = -
; EnableXP