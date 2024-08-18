Enumeration
  #Principal
  #Nombre
  #Apellido
  #DNI
  #Save
EndEnumeration

#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered

grabar$=""

If OpenWindow(#Principal, 0, 0, 310, 250, "Datos",#FLAGS)
  
  StringGadget(#Nombre, 20, 20, 260, 40, "Nombres")
  StringGadget(#Apellido, 20, 70, 260, 40, "Apellido")
  StringGadget(#DNI, 20, 120, 260, 40, "DNI")
  ButtonGadget(#Save, 120, 180, 150, 45, "Grabar Datos")
  Repeat
    
   Event.l=WaitWindowEvent()
  
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Save
            If OpenFile(1,"Datos.txt")
              grabar$=GetGadgetText(#Nombre) + " " + GetGadgetText(#Apellido) + " DNI: " + GetGadgetText(#DNI)
              FileSeek(1, Lof(1))       ;Esta linea sirve para ir actualizando el archivo, sino solo se sobrescribiria 
              WriteStringN(1, grabar$)  ;Esta linea crea el archivo
              
              CloseFile(1)
              
              MessageRequester("Exito","Se grabaron los datos correctamente")
            Else
              MessageRequester("Error","No se pudieron grabar los datos")
              
            EndIf
            
        EndSelect       
   
    EndSelect
  Until Event = #PB_Event_CloseWindow 
EndIf

; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 38
; FirstLine = 11
; EnableXP
; Executable = Grabar datos en txt.exe