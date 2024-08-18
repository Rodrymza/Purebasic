Enumeration
  
  #WindowMain
  
EndEnumeration


Enumeration FormFont
  #Calibri16
  #Calibri18
EndEnumeration

;Carga de fuentes necesarias
LoadFont(#Calibri16,"Calibri Light", 16)
LoadFont(#Calibri18,"Calibri Light", 18)

;Variables

If ReadFile(0, "Texto.txt")    ; opens an existing file or creates one, if it does not exist yet
   While Eof(0) = 0
     texto$=texto$ + #CRLF$ + ReadString(0)
     ;Debug texto$
   Wend 
     CloseFile(0)
   
 Else
   MessageRequester("Error","No se pudo abrir el archivo")
 EndIf

;Flags ventana
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget


OpenWindow(#WindowMain, 0, 0, 640, 340, "Nombre de ventana",#FLAGS)
  
  ;Elementos de ventana (Gadgets y menus)
  TextGadget(#PB_Any, 60, 70, 260, 220, texto$)
  
  
  
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
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 20
; FirstLine = 15
; EnableXP