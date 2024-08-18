Procedure ventana_ayuda() ;del menu de ayuda-acerca de
  
   
  OpenWindow(#ventana_ayuda, 0, 0, 310, 210, "", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
    TextGadget(#PB_Any, 30, 20, 160, 20, "Fichero simple v1.0")
    TextGadget(#PB_Any, 30, 50, 160, 20, "Rodry Ramirez (c) 2024")
    TextGadget(#PB_Any, 30, 80, 160, 20, "rodrymza@gmail.com")
    TextGadget(#PB_Any, 30, 110, 190, 20, "Curso Programacion Profesional")
    TextGadget(#PB_Any, 30, 140, 190, 20, "Profesor: Ricardo Ponce")
    ButtonGadget(#boton_de_ayuda, 110, 170, 100, 25, "Aceptar")
    
    Repeat  
      event.l= WindowEvent()
      Select Event
        Case #PB_Event_CloseWindow
          CloseWindow(#ventana_ayuda)
        Case #PB_Event_Gadget
          Select EventGadget()
            Case #boton_de_ayuda
              quit=#True
              CloseWindow(#ventana_ayuda)
          EndSelect
      EndSelect
      
    Until event= #PB_Event_CloseWindow Or quit=#True
  
  EndProcedure
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 20
; Folding = -
; EnableXP
; DPIAware