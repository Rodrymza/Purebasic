#W = 512
#H = 384
OpenWindow(0,0,0,#W,#H,"Icon",#PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)
SendMessage_(WindowID(0), #WM_SETICON, 0, LoadImage(0, "ruta al icono.ico"))

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
  EndSelect
ForEver 
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 10
; EnableXP
; HideErrorLog