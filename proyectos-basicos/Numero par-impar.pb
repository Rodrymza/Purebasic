Enumeration
  
  #ventanaprincipal
  #titulo
  #numero
  #boton_adquirir
  #lista_resultados
  
EndEnumeration


Enumeration FormFont
  #Font_Window_1_0
EndEnumeration

LoadFont(#Font_Window_1_0,"Segoe Print", 14)

;Variables
Define.i numero

;Flags ventana
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget


OpenWindow(#ventanaprincipal, 0, 0, 500, 300, "Nombre de ventana",#FLAGS)
  
  ;Elementos de ventana (Gadgets y menus)
  TextGadget(#titulo, 50, 30, 210, 40, "Ingresa un numero")
  SetGadgetFont(#titulo, FontID(#Font_Window_1_0))
  StringGadget(#numero, 270, 30, 160, 35, "")
  SetGadgetFont(#numero, FontID(#Font_Window_1_0))
  ButtonGadget(#boton_adquirir, 280, 70, 150, 30, "Adquirir")
  ListViewGadget(#lista_resultados, 70, 120, 360, 120)
  SetGadgetFont(#lista_resultados, FontID(#Font_Window_1_0))
  
  
  
  Repeat 
    Event.l= WindowEvent()    ;esta linea capta los eventos que pasan en la ventana
    Select Event
        
      Case #PB_Event_Menu
        Select EventMenu()
            
            
            
            
            
            
            
            
        EndSelect
      Case  #PB_Event_Gadget
        Select EventGadget()
          Case #boton_adquirir
            ClearGadgetItems(#lista_resultados)
            numero=Val(GetGadgetText(#numero))
            If Mod(numero,2)=0
              AddGadgetItem(#lista_resultados,-1,"-El numero es par")
            Else
              AddGadgetItem(#lista_resultados,-1,"-El numero es impar")
            EndIf 
            
            
            
            
        EndSelect
    EndSelect
    
    
  Until Event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 55
; FirstLine = 32
; EnableXP