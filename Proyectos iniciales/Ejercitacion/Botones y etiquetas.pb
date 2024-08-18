Enumeration 
  #etiqueta
  #texto_usuario
  #mostrar
  #cambiar
EndEnumeration

OpenWindow(#PB_Any, 0, 0, 320, 140, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
TextGadget(#etiqueta, 50, 20, 220, 25, "Texto a cambiar", #PB_Text_Center)
StringGadget(#texto_usuario, 50, 50, 220, 25, "")
ButtonGadget(#mostrar, 50, 90, 100, 25, "Mostrar texto")
ButtonGadget(#cambiar, 170, 90, 100, 25, "Cambiar etiqueta")

Repeat 
  event= WindowEvent()
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #mostrar
          MessageRequester("Texto","El texto a colocar sera: " + GetGadgetText(#texto_usuario))
          
        Case #cambiar
          SetGadgetText(#etiqueta,GetGadgetText(#texto_usuario))
          
      EndSelect
  EndSelect
  Until event=#PB_Event_CloseWindow
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 19
; EnableXP
; DPIAware