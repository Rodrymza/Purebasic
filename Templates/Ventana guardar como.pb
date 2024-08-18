Enumeration
  #explorer
  #boton
EndEnumeration


OpenWindow(#PB_Any,0,0,280,190,"Ventana principal", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
ExplorerTreeGadget(#explorer, 40, 20, 200, 120, "")
ButtonGadget(#boton, 80, 150, 100, 25, "Guardar")

Repeat
  event = WindowEvent()
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #boton
          Debug GetGadgetText(#explorer)
          
      EndSelect
  EndSelect
Until event = #PB_Event_CloseWindow

     
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 5
; EnableXP
; DPIAware