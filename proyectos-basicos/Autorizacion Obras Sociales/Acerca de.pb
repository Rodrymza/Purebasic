Enumeration 
  #ventana_ayuda
  #boton_de_ayuda
  #about_ico
  #about_image
EndEnumeration

Procedure ventana_acercade() ;del menu de ayuda-acerca de
  OpenWindow(#ventana_ayuda, 0, 0, 380, 210, "", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
  SendMessage_(WindowID(#ventana_ayuda), #WM_SETICON, 0, LoadImage(#about_ico,"about.ico"))

    TextGadget(#PB_Any, 30, 60, 280, 20, "Autorizacion de Obras Sociales v1")
    TextGadget(#PB_Any, 30, 90, 160, 20, "Rodry Ramirez (c) 2024")
    TextGadget(#PB_Any, 30, 140, 160, 20, "rodrymza@gmail.com")
    ButtonGadget(#boton_de_ayuda, 150, 170, 100, 25, "Aceptar")
    ImageGadget(#about_image, 230, 32, 128, 128, LoadImage(#about_image,"medical.ico"))
    Repeat  
      event=WindowEvent()
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
  
  ventana_acercade()
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 11
; Folding = -
; EnableXP
; HideErrorLog