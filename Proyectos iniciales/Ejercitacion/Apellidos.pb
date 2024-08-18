Enumeration
  #lista_apellidos
  #boton_abrir
  #boton_ordenar
  #boton_guardar
  #boton_guardarComo
  #boton_agregar
  #apellidos_archivo
  #explorador
  #ventanaguardar
  #archivoNuevo
EndEnumeration

archivo.s="Apellidos.txt"
Dim apellidos.s(0)
n=0

Procedure.s guardar_como()
  OpenWindow(#ventanaguardar, 0, 0, 310, 200, "Guardar Como", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ExplorerTreeGadget(#explorador, 10, 10, 290, 180, "")
  Repeat  
    event = WindowEvent()
    If event= #PB_Event_Gadget And EventGadget() = #explorador And EventType()=#PB_EventType_LeftDoubleClick
      Debug GetGadgetText(#explorador)
      ProcedureReturn GetGadgetText(#explorador)
    EndIf
    If event= #PB_Event_CloseWindow : CloseWindow(#ventanaguardar) : EndIf
  Until event=#explorador Or event = #PB_Event_CloseWindow
  
EndProcedure


OpenWindow(#PB_Any, 0, 0, 290, 330, "Lista Apellidos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
ListViewGadget(#lista_apellidos, 20, 10, 240, 190)
  ButtonGadget(#boton_abrir, 30, 210, 100, 25, "Abrir archivo")
  ButtonGadget(#boton_ordenar, 150, 210, 100, 25, "Ordenar")
  ButtonGadget(#boton_guardar, 30, 250, 100, 25, "Guardar")
  ButtonGadget(#boton_guardarComo, 150, 250, 100, 25, "Guardar como")
  ButtonGadget(#boton_agregar, 90, 290, 100, 25, "Agregar")
  
  Repeat
    event = WindowEvent()
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #boton_abrir
            ReadFile(#apellidos_archivo,archivo)
            While Eof(#apellidos_archivo)=#False
              apellidos(n)=ReadString(#apellidos_archivo)
              AddGadgetItem(#lista_apellidos,-1,apellidos(n))
              n=n+1
              ReDim apellidos(n)
            Wend
            ReDim apellidos(n-1)
            
          Case #boton_agregar
            ReDim apellidos(ArraySize(apellidos()) + 1)
            
            apellidos(ArraySize(apellidos())) = InputRequester("Nuevo apellido","Ingrese apellido a agregar","")
            AddGadgetItem(#lista_apellidos,-1,apellidos(ArraySize(apellidos())))
            OpenFile(#apellidos_archivo,archivo)
            FileSeek(#apellidos_archivo,Lof(#apellidos_archivo))
            WriteStringN(#apellidos_archivo,apellidos(ArraySize(apellidos())))
            CloseFile(#apellidos_archivo)
            
          Case #boton_ordenar
            SortArray(apellidos(),#PB_Sort_Ascending)
            ClearGadgetItems(#lista_apellidos)
            For i=0 To ArraySize(apellidos())
              AddGadgetItem(#lista_apellidos,-1,apellidos(i))
            Next
            
          Case #boton_guardarComo
            guardar.s=guardar_como()
            If guardar<>""
              CreateFile(#archivoNuevo,guardar + InputRequester("Guardando","Ingrese nombre del archivo","") + ".txt")
              For i=0 To ArraySize(apellidos())
                WriteStringN(#archivoNuevo,apellidos(i))
              Next
              MessageRequester("Guardado exitoso","Se guardo el archivo en la direccion " + guardar)
              CloseFile(#archivoNuevo)
            Else
              MessageRequester("Error","No selecciono donde guardar el archivo")
            EndIf
            
          Case #boton_guardar
            If OpenFile(#apellidos_archivo,"Modificado " + archivo)
              For i=0 To ArraySize(apellidos())
                WriteStringN(#apellidos_archivo,apellidos(i))  
              Next
              CloseFile(#apellidos_archivo)
              MessageRequester("Exito","Archivo guardado exitosamente")
            EndIf 
              
        EndSelect
    EndSelect
  Until event = #PB_Event_CloseWindow
  
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 86
; FirstLine = 37
; Folding = -
; EnableXP
; DPIAware