Enumeration
  #hora
  #boton
  #horaadquirida
  #ventanaprincipal
  #reloj
EndEnumeration

hora$=FormatDate("%hh:%ii:%ss",Date())
OpenWindow(#ventanaprincipal,0,0,260,180,"Ventana principal", #PB_Window_ScreenCentered)
AddWindowTimer(#ventanaprincipal,#reloj,1000)
TextGadget(#hora, 80, 20, 100, 25, hora$, #PB_Text_Center)
ButtonGadget(#boton, 80, 70, 100, 25, "Adquirir hora")
StringGadget(#horaadquirida, 80, 120, 100, 25, "")

Repeat
  event = WindowEvent()
  If Event = #PB_Event_Timer And EventTimer() = #reloj
    hora$=FormatDate("%hh:%ii:%ss",Date())
    SetGadgetText(#hora,hora$)
  EndIf    
  
  
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
          Case #boton
          SetGadgetText(#horaadquirida,"       " + GetGadgetText(#hora))

      EndSelect
      
  EndSelect
Until event = #PB_Event_CloseWindow


; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 13
; EnableXP
; DPIAware