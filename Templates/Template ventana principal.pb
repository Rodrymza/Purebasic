Enumeration
  
  #VentanaPrincipal
  
EndEnumeration

;Fuentes
Enumeration FormFont
  #Calibri16
  #Calibri18
EndEnumeration

;Carga de fuentes necesarias
LoadFont(#Calibri16,"Calibri Light", 16)
LoadFont(#Calibri18,"Calibri Light", 18)

;Variables


;Funciones
Procedure
  
EndProcedure


;Flags ventana
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget


OpenWindow(#VentanaPrincipal, 0, 0, 640, 340, "Nombre de ventana",#FLAGS)

;Elementos de ventana (Gadgets y menus)




Repeat 
  Event.l= WindowEvent()    ;esta linea capta los eventos que pasan en la ventana
  Select Event
      
    Case #PB_Event_Menu
      Select EventMenu()
          
          
      EndSelect
    Case  #PB_Event_Gadget
      Select EventGadget()
          
          
      EndSelect
  EndSelect
Until Event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 51
; FirstLine = 18
; Folding = -
; EnableXP