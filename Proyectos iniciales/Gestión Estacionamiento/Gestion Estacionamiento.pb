Enumeration
  #horaActual
  #boton
  #horaadquirida
  #ventanaprincipal
  #reloj
  #fecha
  #boton_ingreso
  #boton_egreso
  #recaudacion
  #lista_vehiculos
  #busqueda
  #ingreso
  #patente
  #descripcion
  #boton_aceptar
  #actualizar
  #boton_busqueda
  #exportar
  #archivo_ventas
  #archivo_valores
  #guardarActual
  #ventana_valores
  #texto_hora
  #texto_4hs
  #texto_8hs
  #boton_configuracion
  #actualizar_valores
  #borrar_ventas
  #lista_ventas
  #ventas_guardadas
  #ventana_ventas
  #lista_en_ventas
EndEnumeration

Global NewList ventas.s()

;variables
hora$=FormatDate("%hh:%ii:%ss",Date())
fecha$=FormatDate("%dd/%mm/%yyyy",Date())
ficheroVentas$="Ventas.txt"
Global ficheroGuardado$="Guardado.txt" : Global ficheroguardadoventas$="Ventas_guardadas.txt"
Global valorhora=700 : Global valor4horas=2500 :Global valor8horas=4500 : Global posicion=0 : Global  totalrecaudado.l=0
Global Dim vehiculos.s(29,1)
For i=0 To ArraySize(vehiculos(),1)
  vehiculos(i,0)= "Plaza vacia"
  vehiculos(i,1) = ""
Next

;vehiculos(0,0) = "AA888FD - Renault"
;vehiculos(0,1) = "22:30"

;funciones

Procedure actualizarlista()
  ClearGadgetItems(#lista_vehiculos)
  For i=0 To ArraySize(vehiculos())
    AddGadgetItem(#lista_vehiculos, i,Str(i+1) + Chr(10) + vehiculos(i,0) + Chr(10) + vehiculos(i,1) )
  Next 
    SetGadgetText(#recaudacion,"Total recaudacion $ " + Str(totalrecaudado))
EndProcedure

Procedure.s ventanaIngreso()
  quit=#False
  OpenWindow(#ingreso,0,0,290,170, "Ingreso de vehiculo" ,#PB_Window_ScreenCentered | #PB_Window_SystemMenu )
  
  TextGadget(#PB_Any, 40, 20, 110, 25, "Ingrese vehiculo:")
  TextGadget(#PB_Any, 60, 60, 60, 25, "Patente:")
  TextGadget(#PB_Any, 45, 90, 70, 25, "Descripcion:")
  StringGadget(#patente, 120, 55, 120, 25, "")
  StringGadget(#descripcion, 120, 85, 120, 25, "")
  ButtonGadget(#boton_aceptar, 80, 130, 130, 25, "Aceptar")
  
  Repeat  
    event=WindowEvent()
    Select Event
      Case #PB_Event_CloseWindow
        CloseWindow(#ingreso)
        quit=#True
      Case #PB_Event_Gadget
        Select EventGadget()
            
          Case  #boton_aceptar
            If GetGadgetText(#patente)<>"" And GetGadgetText(#descripcion)<>""
              texto$=GetGadgetText(#patente) + " - " + GetGadgetText(#descripcion)
              quit=#True
              CloseWindow(#ingreso)
            Else
              MessageRequester("Error","No completo los campos")
            EndIf
        EndSelect
    EndSelect

Until event = #PB_Event_CloseWindow Or quit=#True

ProcedureReturn texto$

EndProcedure

Procedure Buscararrayvacio()
  
  For i=0 To ArraySize(vehiculos(),1)
    If vehiculos(i,1)=""
      posicion=i
      Break 
    EndIf
  Next
  ProcedureReturn posicion
EndProcedure

Procedure buscarArray(Array vector$(2), busqueda$)
  
  For j=0 To ArraySize(vector$())
    
    For i=1 To Len(vector$(j,0))-(Len(busqueda$)-1)
      If Mid(vector$(j,0),I,Len(busqueda$))=busqueda$
        AddGadgetItem(#lista_vehiculos, i,Str(j+1) + Chr(10) + vehiculos(j,0) + Chr(10) + vehiculos(j,1) )
      EndIf 
    Next
  Next
  
  
EndProcedure

Procedure.f horaAseg(hora$)
  
  resultado.f=(Val(Mid(hora$,1,2)))+(Val(Mid(hora$,4,5))/60)
  
  ProcedureReturn resultado
EndProcedure

Procedure calcularCobro(turno)
  If turno<=3
    total=valorhora*turno
  ElseIf turno>=4 And turno<8
    total=valor4horas + valorhora * (turno-4)
  Else
    total=valor8horas
  EndIf 
  ProcedureReturn total
EndProcedure

Procedure guardarValores()
  CreateFile(#archivo_valores,ficheroGuardado$)
    For i=0 To ArraySize(vehiculos(),1)
      If vehiculos(i,1)<>""
        WriteStringN(#archivo_valores,vehiculos(i,0) + "," + vehiculos(i,1))
      EndIf 
    Next
    CloseFile(#archivo_valores)
    CreateFile(#ventas_guardadas,ficheroguardadoventas$) 
    ForEach ventas()
      WriteStringN(#ventas_guardadas,ventas())
    Next
    CloseFile(#ventas_guardadas)
EndProcedure

Procedure leerArchivo()
  If ReadFile(#archivo_valores,ficheroGuardado$)
    n=0
    While Eof(#archivo_valores)=0
      linea$=ReadString(#archivo_valores)
      vehiculos(n,0)=StringField(linea$,1,",")
      vehiculos(n,1)=StringField(linea$,2,",")
      n=n+1
    Wend
  Else
    MessageRequester("Atencion","No se encontro sesion previa")
  EndIf 
  
 If ReadFile(#ventas_guardadas,ficheroguardadoventas$)
   While Eof(#ventas_guardadas)=0
     linea$=ReadString(#ventas_guardadas)
     AddElement(ventas())
     ventas()=linea$
      totalrecaudado = totalrecaudado  + Val(StringField(linea$,2,"$"))
    Wend
  EndIf
  
EndProcedure

Procedure ventana_valores()
  
  OpenWindow(#ventana_valores,0,0,380,280,"Actualizacion de valores", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
  TextGadget(#PB_Any, 110, 20, 160, 30, "Actualizar valores", #PB_Text_Center)
  TextGadget(#PB_Any, 30, 80, 120, 30, "Valor por hora $", #PB_Text_Center)
  ButtonGadget(#boton_configuracion, 130, 220, 100, 25, "Guardar")
  TextGadget(#PB_Any, 30, 120, 120, 30, "Valor Turno 4hs $", #PB_Text_Center)
  TextGadget(#PB_Any, 30, 160, 120, 30, "Valor Turno 8hs $", #PB_Text_Center)
  StringGadget(#texto_hora, 160, 75, 100, 25, Str(valorhora))
  StringGadget(#texto_4hs, 160, 115, 100, 25, Str(valor4horas))
  StringGadget(#texto_8hs, 160, 155, 100, 25, Str(valor8horas))
  
  Repeat
    event = WaitWindowEvent()
    If event = #PB_Event_CloseWindow
      CloseWindow(#ventana_valores)
    EndIf 
    If event = #PB_Event_Gadget And EventGadget() = #boton_configuracion
      If GetGadgetText(#texto_hora)<>"" And GetGadgetText(#texto_4hs)<>"" And GetGadgetText(#texto_8hs)<>""
        valorhora=Val(GetGadgetText(#texto_hora)) : valor4horas = Val(GetGadgetText(#texto_4hs)) : valor8horas = Val(GetGadgetText(#texto_8hs))
        MessageRequester("Atencion","Valores actualizados correctamente", #PB_MessageRequester_Info)
      Else
        MessageRequester("Error","Falta completar campos", #PB_MessageRequester_Error)
      EndIf
    EndIf
  Until event = #PB_Event_CloseWindow
EndProcedure

Procedure ventana_ventas(List lista.s(),total)
  OpenWindow(#ventana_ventas, 850, 200, 370, 400, "Lista de Clientes/Provedores", #PB_Window_SystemMenu)
  ListIconGadget(#lista_en_ventas, 30, 50, 320, 330,"Ventas del dia", 290, #PB_ListIcon_FullRowSelect)
  TextGadget(#PB_Any, 30, 10, 320, 25, "Lista de Ventas", #PB_Text_Center)
  valor=-1
  ForEach lista()
    AddGadgetItem(#lista_en_ventas,-1,lista())
    total=total+Val(Mid(lista(),-4))
  Next
  AddGadgetItem(#lista_en_ventas,-1, "")
  AddGadgetItem(#lista_en_ventas,-1, "Total vendido $" + Str(total))
  Repeat
    event= WindowEvent()
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
            
        EndSelect
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_ventas)
        
    EndSelect
  Until event = #PB_Event_CloseWindow
EndProcedure


OpenWindow(#ventanaprincipal,0,0,410,420,"Gestion Playa Estacionamiento", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
AddWindowTimer(#ventanaprincipal,#reloj,1000)
CreateMenu(#PB_Any,WindowID(#ventanaprincipal))
MenuTitle("Archivo")
MenuItem(#actualizar,"Actualizar")
MenuItem(#exportar,"Exportar ventas")
MenuItem(#guardarActual,"Guardar Gestion Actual")
MenuTitle("Configuracion")
MenuItem(#actualizar_valores,"Actualizar valores")
MenuItem(#borrar_ventas,"Borrar ventas del dia")
MenuItem(#lista_ventas,"Ver lista de ventas")
TextGadget(#horaActual, 280, 20, 100, 25, hora$, #PB_Text_Center)
TextGadget(#fecha, 40, 20, 100, 25, fecha$)
ListIconGadget(#lista_vehiculos, 30, 150, 350, 220,"Pos", 40, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect )
AddGadgetColumn(#lista_vehiculos,1,"Vehiculo",130)
AddGadgetColumn(#lista_vehiculos,2,"Hora ingreso",100)
StringGadget(#busqueda, 220, 110, 150, 25, "")
ButtonGadget(#boton_busqueda, 110, 110, 100, 25, "Buscar vehiculo:")
ButtonGadget(#boton_ingreso, 80, 60, 100, 30, "Ingreso Vehiculo")
ButtonGadget(#boton_egreso, 210, 60, 100, 30, "Egreso Vehiculo")
TextGadget(#recaudacion, 210, 380, 140, 25, "Total recaudacion $ " + Str(totalrecaudado))

leerArchivo()
actualizarlista()

Repeat
  event = WindowEvent()
  If Event = #PB_Event_Timer And EventTimer() = #reloj
    hora$=FormatDate("%hh:%ii:%ss",Date())
    SetGadgetText(#horaActual,hora$)
  EndIf    
  
  
  Select event
      
    Case #PB_Event_CloseWindow
      guardarValores()
      MessageRequester("Atencion","Archivo de sesion guardado",#PB_MessageRequester_Info)
      CloseWindow(#ventanaprincipal)
      
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #boton_ingreso
          posicion=Buscararrayvacio()
          asignacion$=ventanaIngreso()
          If asignacion$<>""
            vehiculos(posicion,0) = UCase(asignacion$)
            vehiculos(posicion,1) = GetGadgetText(#horaActual)
            actualizarlista()
          EndIf 
          
        Case #boton_egreso
          plaza.i=Val(GetGadgetText(#lista_vehiculos))-1
          If plaza.i<>-1
            result = MessageRequester("Atencion","Vehiculo seleccionado: " + vehiculos(plaza,0),#PB_MessageRequester_YesNo)
            If result = #PB_MessageRequester_Yes
              horasalida$=GetGadgetText(#horaActual)
              totalturno= Round(horaAseg(horasalida$)-horaAseg(vehiculos(plaza,1)),#PB_Round_Up)
              Debug "salida " +  Round(horaAseg(horasalida$),#PB_Round_Up)
              Debug "entrada " + Round(horaAseg(vehiculos(plaza,1)),#PB_Round_Down)
              If totalturno<0
                totalturno=totalturno+25
              EndIf
              
              preciofinal=calcularCobro(totalturno)
              MessageRequester("Importe","Importe a cobrar $" + Str(preciofinal))
              AddElement(ventas())
              ventas()="Hora: " + horasalida$ + " -  $" + Str(preciofinal)
              totalrecaudado=totalrecaudado+preciofinal
            
              vehiculos(plaza,0)="Plaza vacia"
              vehiculos(plaza,1)=""
              actualizarlista()
              
            Else
              MessageRequester("Atencion","Seleccione el vehiculo correcto")
            EndIf
          Else
            MessageRequester("Atencion","No seleccionaste ningun vehiculo")
          EndIf

        Case #boton_busqueda
          ClearGadgetItems(#lista_vehiculos)
          buscarArray(vehiculos(),UCase(GetGadgetText(#busqueda)))
          
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #actualizar
          ClearGadgetItems(#lista_vehiculos)
          actualizarlista()
          
        Case #exportar
          CreateFile(#archivo_ventas,ficheroVentas$)
          WriteStringN(#archivo_ventas,"Ventas realizadas el dia: " + GetGadgetText(#fecha))
          WriteStringN(#archivo_ventas,"")
          ForEach ventas()
            WriteStringN(#archivo_ventas,ventas())
          Next
          WriteStringN(#archivo_ventas,"")
          WriteStringN(#archivo_ventas,"Total recaudado: $" + Str(totalrecaudado))
          CloseFile(#archivo_ventas)
          MessageRequester("OK","Archivo guardado correctamente")
          
        Case #guardarActual
          guardarValores()
          MessageRequester("Atencion","Gestion actual guardada")
          
        Case #actualizar_valores
          ventana_valores()
          
          
        Case #borrar_ventas
          ClearList(ventas())
          MessageRequester("OK","Ventas del dia borradas",#PB_MessageRequester_Ok)
          
          Case #lista_ventas
            ventana_ventas(ventas(),totalrecaudado)
          ForEach ventas()
            Debug ventas()
          Next
          
          
      EndSelect
      
  EndSelect
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 218
; FirstLine = 65
; Folding = A5
; EnableXP
; DPIAware
; Executable = ..\Estacionamiento.exe