;Intentando borrar un archivo

Enumeration
  
  #WindowMain
  #Botonguardar
  #Botonborrar
  #Archivo
  #String
  
EndEnumeration

nombrearchivo$="archivo.txt"

Enumeration FormFont
  #Calibri16
  #Calibri18
EndEnumeration

;Carga de fuentes necesarias
LoadFont(#Calibri16,"Calibri Light", 16)
LoadFont(#Calibri18,"Calibri Light", 18)

;Variables


;Flags ventana
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget


OpenWindow(#WindowMain, 0, 0, 640, 340, "Nombre de ventana",#FLAGS)
  
  ;Elementos de ventana (Gadgets y menus)
  ButtonGadget(#Botonguardar, 80, 170, 160, 50, "Guardar")
  ButtonGadget(#Botonborrar, 270, 170, 160, 50, "Borrar")
  StringGadget(#String, 150, 90, 220, 40, "")
  
  
  
  Repeat 
    Event.l= WindowEvent()    ;esta linea capta los eventos que pasan en la ventana
    Select Event
        
      Case #PB_Event_Menu
        Select EventMenu()
            
            
            
            
            
            
            
            
        EndSelect
      Case  #PB_Event_Gadget
        Select EventGadget()
          Case #Botonguardar
            text$=GetGadgetText(#String)
            OpenFile(#Archivo,nombrearchivo$)
            FileSeek(#Archivo,Lof(#Archivo))
            WriteStringN(#Archivo,text$)
            CloseFile(#Archivo)
            
            
          Case #Botonborrar
            a.l=DeleteFile(nombrearchivo$)
            If a=0
              MessageRequester("","No se pudo borrar el archivo")
            EndIf
            
            
            
        EndSelect
    EndSelect
    
    
  Until Event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 59
; FirstLine = 42
; EnableXP