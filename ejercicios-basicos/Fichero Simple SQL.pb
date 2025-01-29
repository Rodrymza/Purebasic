;Progrma fichero simple v2 con estructura para guardar datos en SQL
;(c) Rodry Ramirez
; rodrymza@gmail.com

Enumeration ;constantes para gadgets y menus
  #Principal
  #Nombre
  #Nombretext
  #Apellido
  #Apellidotext
  #DNI
  #DNItext
  #Ficha
  #BotonAnterior
  #BotonGuardar
  #BotonPosterior
  #MenuIngreso
  #MenuConsulta
  #MenuModificacion
  #Titulo
  #Contrasenia
  #Botoncontrasenia
  #Ventanacontrasenia
  #Archivo
  #Ayuda
  #ventana_ayuda
  #boton_de_ayuda
  #anterior_tecla
  #posterior_tecla
  #list_personas
  #ventana_lista
  #Menu_lista
  #tecla_intro
  #tecla_f2
  #tecla_f1
  #tecla_f3
  #barra_estado
  #base_datos
  #bdd_comprobar
  #bdd_id
EndEnumeration

Enumeration FormFont ;constantes para fuentes
  #Calibri16
  #Calibri18
EndEnumeration

UseMySQLDatabase()
;Carga de fuentes necesarias
LoadFont(#Calibri16,"Calibri Light", 16)
LoadFont(#Calibri18,"Calibri Light", 18)

;Definicion e inicializacion de variables
Structure datos
  apellido.s
  nombre.s
  dni.s
EndStructure
Global NewList personas.datos()

Global tablename.s="fichero_simple", dbname.s="host=localhost port=3306 dbname=rodry_datos", user.s="rodry", pass.s="rodry1234", indice.s

Procedure actualizar_lista()
  ClearList(personas())
  If OpenDatabase(#base_datos,dbname,user,pass) : StatusBarText(#barra_estado,0,"Conectado a BDD") : EndIf 
  DatabaseQuery(#base_datos,"SELECT * FROM " + tablename + " ORDER BY apellido")
  While NextDatabaseRow(#base_datos)
    AddElement(personas())
    personas()\dni=Str(GetDatabaseLong(#base_datos,0))
    personas()\apellido=GetDatabaseString(#base_datos,1)
    personas()\nombre=GetDatabaseString(#base_datos,2)
  Wend
  EndProcedure

Procedure ventana_ayuda() ;del menu de ayuda-acerca de
     
   OpenWindow(#ventana_ayuda, 0, 0, 310, 210, "", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
    TextGadget(#PB_Any, 30, 20, 160, 20, "Fichero simple v2.0 - Base de Datos SQL")
    TextGadget(#PB_Any, 30, 50, 160, 20, "Rodry Ramirez (c) 2024")
    TextGadget(#PB_Any, 30, 80, 160, 20, "rodrymza@gmail.com")
    TextGadget(#PB_Any, 30, 110, 190, 20, "Curso Programacion Profesional")
    TextGadget(#PB_Any, 30, 140, 190, 20, "Profesor: Ricardo Ponce")
    ButtonGadget(#boton_de_ayuda, 110, 170, 100, 25, "Aceptar")
    
    Repeat  
      event.l= WindowEvent()
      Select Event
        Case #PB_Event_CloseWindow
          CloseWindow(#ventana_ayuda)   ;controlo que el evento de cerrar ventana solo ciere la ventana actual, de lo contrario se cerrarian las dos ventanas ejecutadas
        Case #PB_Event_Gadget
          Select EventGadget()
            Case #boton_de_ayuda      ;al presionar el boton cerramos la ventana y salimos del subprograma
              quit=#True
              CloseWindow(#ventana_ayuda)
          EndSelect
      EndSelect
      
    Until event= #PB_Event_CloseWindow Or quit=#True
  
  EndProcedure

Procedure$ title(palabra$)  ;Formatea el texto a primera letra mayuscula
  i.l=2
  r$=UCase(Mid(palabra$,1,1))
  While i<= Len(palabra$)
    If Mid(palabra$,i,1)=" "
      r$=r$+ UCase(Mid(palabra$,i,2))
      i=i+2
    Else
      r$=r$+LCase(Mid(palabra$,i,1))
      i=i+1
    EndIf
  Wend
  ProcedureReturn r$
EndProcedure

Procedure ventana_lista()
  OpenWindow(#ventana_lista, 0, 0, 330, 410, "Lista de Personas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ListViewGadget(#list_personas, 10, 40, 310, 360)
  TextGadget(#PB_Any, 50, 10, 240, 25, "Listado de Personas", #PB_Text_Center)
  ForEach personas()
    AddGadgetItem(#list_personas,-1,personas()\apellido + ", " + personas()\nombre + " - " + personas()\dni)
  Next
  Repeat
    event=WindowEvent()
    If event=#PB_Event_CloseWindow : CloseWindow(#ventana_lista) : EndIf  
    Until event=#PB_Event_CloseWindow
EndProcedure

Procedure actualizar_ventana(valor)
  If valor=1
    SetGadgetText(#DNItext,"") : SetGadgetText(#Nombretext,"") : SetGadgetText(#Apellidotext,"")
    actualizar_lista()
    SetGadgetText(#Ficha,"N° Ficha: " + Str(ListSize(personas())+1))
    StatusBarText(#barra_estado,1,"Total personas ingresadas: " + Str(ListSize(personas())),#PB_StatusBar_Center) 
  Else
    SetGadgetText(#DNItext,personas()\dni) : SetGadgetText(#Apellidotext,personas()\apellido) : SetGadgetText(#Nombretext,personas()\nombre)
    SetGadgetText(#Ficha,"N° Ficha: " + Str(ListIndex(personas())+1))
  EndIf 
  
EndProcedure

Procedure consulta()
  SetGadgetText(#Titulo,"Sistema de Consultas")
  DisableGadget(#BotonGuardar,1) : DisableGadget(#DNItext,1)
  DisableGadget(#BotonAnterior,0) : DisableGadget(#Nombretext,1)
  DisableGadget(#BotonPosterior,0) : DisableGadget(#Apellidotext,1)
  If ListIndex(personas())=ListSize(personas())-1 : FirstElement(personas()) :EndIf
  actualizar_ventana(0)
EndProcedure

Procedure ingreso()
  SetGadgetText(#Titulo,"Sistema de Ingreso")
  actualizar_ventana(1)
  DisableGadget(#BotonAnterior,1) : DisableGadget(#BotonPosterior,1) : DisableGadget(#Nombretext,0)
  DisableGadget(#BotonGuardar,0) :DisableGadget(#DNItext,0) : DisableGadget(#Apellidotext,0)
EndProcedure

Procedure modificacion()
  SetGadgetText(#Titulo,"Modificacion de Datos")
  If ListIndex(personas())=ListSize(personas())-1
    MessageRequester("Error","Ficha vacia",#PB_MessageRequester_Warning)
  Else
    indice.s=GetGadgetText(#DNItext)
    DisableGadget(#DNItext,0) : DisableGadget(#Nombretext,0) : DisableGadget(#Apellidotext,0)
    DisableGadget(#BotonGuardar,0) : DisableGadget(#BotonPosterior,1) : DisableGadget(#BotonAnterior,1)
  EndIf
EndProcedure

Procedure posterior()
  If ListIndex(personas())<ListSize(personas())-1
    SelectElement(personas(),ListIndex(personas())+1)
    actualizar_ventana(0)
  Else
    FirstElement(personas())
    actualizar_ventana(0)
  EndIf 
EndProcedure

Procedure anterior()
  If ListIndex(personas())>0
    SelectElement(personas(),ListIndex(personas())-1)
    actualizar_ventana(0)
  Else
    LastElement(personas())
    actualizar_ventana(0)
  EndIf 
EndProcedure


  ;Proceso principal

OpenWindow(#Principal, 0, 0, 650, 340, "Banco de Datos: Fichero Simple",#PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CreateMenu(0, WindowID(#Principal))
MenuTitle("Sistema")                    ;Barras de menu
MenuItem(#MenuIngreso, "Ingreso (F1)")
MenuItem(#MenuConsulta, "Consulta (F2)")
MenuItem(#MenuModificacion, "Modificar (F3)")
MenuItem(#Menu_lista,"Listado de personas")
MenuTitle("Ayuda")
MenuItem(#Ayuda,"Acerca de")
MenuTitle("Base de datos")
MenuItem(#bdd_comprobar,"Comprobar conexion")
TextGadget(#Apellido, 40, 70, 100, 25, "Apellido")
SetGadgetFont(#Apellido, FontID(#Calibri16))
TextGadget(#Nombre, 40, 120, 100, 25, "Nombre")
SetGadgetFont(#Nombre, FontID(#Calibri16))
TextGadget(#DNI, 40, 170, 100, 25, "DNI")
SetGadgetFont(#DNI, FontID(#Calibri16))
TextGadget(#Ficha, 490, 20, 130, 60, "N° Ficha: " + Str(ListSize(personas())+1))     ;Cuadros de texto
SetGadgetFont(#Ficha, FontID(#Calibri18))
StringGadget(#Apellidotext, 150, 70, 200, 30, "")
SetGadgetFont(#Apellidotext, FontID(#Calibri18))
StringGadget(#Nombretext, 150, 120, 200, 30, "")
SetGadgetFont(#Nombretext, FontID(#Calibri18))
StringGadget(#DNItext, 150, 170, 200, 30, "")
SetGadgetFont(#DNItext, FontID(#Calibri18))
TextGadget(#Titulo, 0, 10, 650, 35, "Sistema de Ingreso", #PB_Text_Center)
SetGadgetFont(#Titulo, FontID(#Calibri18))
ButtonGadget(#BotonAnterior, 210, 260, 120, 35, "<- Anterior")
DisableGadget(#BotonAnterior,1)
ButtonGadget(#BotonGuardar, 360, 260, 120, 35, "Guardar")        ;Botones
ButtonGadget(#BotonPosterior, 510, 260, 120, 35, "Posterior ->")
DisableGadget(#BotonPosterior,1)
AddKeyboardShortcut(#Principal,#PB_Shortcut_Left,#anterior_tecla)   ;creacion de teclas de acceso directo para diferentes acciones
AddKeyboardShortcut(#Principal,#PB_Shortcut_Right,#posterior_tecla) ; se puede cambiar de ficha en el menu de consulta a traves de las flechas 
AddKeyboardShortcut(#Principal,#PB_Shortcut_F2,#tecla_f2)           ; se entra en modo ingreso, modificacion y consulta a traves de F1, F2 y F3
AddKeyboardShortcut(#Principal,#PB_Shortcut_F1,#tecla_f1)
AddKeyboardShortcut(#Principal,#PB_Shortcut_F3,#tecla_f3)
AddKeyboardShortcut(#Principal,#PB_Shortcut_Return,#tecla_intro)
SetActiveGadget(#Apellidotext)
CreateStatusBar(#barra_estado,WindowID(#Principal))
AddStatusBarField(300)
AddStatusBarField(300)

actualizar_ventana(1)


Repeat 
  Event.l= WindowEvent()    ;esta linea capta los eventos que pasan en la ventana
  Select Event
      
    Case #PB_Event_Menu
      Select EventMenu()
        Case #MenuConsulta
          consulta()
        Case #tecla_f2
          consulta()
        Case #tecla_f1
          ingreso()
        Case #MenuIngreso
          ingreso()
        Case #bdd_comprobar
          If OpenDatabase(#base_datos, dbname, user, pass)
            MessageRequester("Exito","Conexion exitosa a la base de datos",#PB_MessageRequester_Info)
          Else
            MessageRequester("Error","No se pudo conectar a la base de datos",#PB_MessageRequester_Error)
          EndIf 
        Case #Menu_lista
          ventana_lista()
        Case #MenuModificacion
          modificacion()
        Case #tecla_f3
          modificacion()
        Case #anterior_tecla
          If GetGadgetText(#Titulo)="Sistema de Consultas" : anterior() : EndIf 
        Case #posterior_tecla
          If GetGadgetText(#Titulo)="Sistema de Consultas" : posterior() : EndIf 
      EndSelect
      
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #BotonGuardar
          
          If GetGadgetText(#Nombretext)="" Or GetGadgetText(#DNItext)="" Or GetGadgetText(#Apellidotext)=""
            MessageRequester("Error","Falta completar campos", #PB_MessageRequester_Warning)
          Else 
            
            nombre.s="'" + title(GetGadgetText(#Nombretext)) + "'"
            apellido.s="'" + title(GetGadgetText(#Apellidotext)) + "'"
            dni.s=GetGadgetText(#DNItext)
            Select GetGadgetText(#Titulo)
              Case "Sistema de Ingreso"
                OpenDatabase(#base_datos,dbname, user, pass)
                If DatabaseUpdate(#base_datos, "INSERT INTO " + tablename + " (dni, apellido, nombre) VALUES (" + dni + ", " + apellido + ", " + nombre + ")")
                  MessageRequester("Exito","Persona ingresada a la ficha correctamente")
                  actualizar_ventana(1)              
                Else
                  MessageRequester("Error","Error al ingresar persona a la base de datos",#PB_MessageRequester_Error)
                EndIf 
                
              Case "Modificacion de Datos"
                Debug "indice dni " + indice
                OpenDatabase(#base_datos, dbname, user, pass)
                If DatabaseUpdate(#base_datos, "UPDATE " + tablename + " SET dni=" + dni + ", apellido=" + apellido + ", nombre=" + nombre + " WHERE dni= "+ indice)
                  MessageRequester("Exito","Persona modificada correctamente")
                  consulta()
                EndIf  
            EndSelect
          EndIf 
           
          
        Case #BotonPosterior
          posterior()
          
        Case #BotonAnterior
          anterior()
          
      EndSelect
  EndSelect
Until Event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 82
; FirstLine = 52
; Folding = Cy
; EnableXP
; DPIAware