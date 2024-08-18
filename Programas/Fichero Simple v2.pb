;Banco de datos, fichero simple que guarde nombrea, apellido y dni (ficha)
;ventana debe tener
;menu con ingreso de datos, consulta
;3 campos para guardar
;boton avanzar y retroceder
;boton de grabacion
;---------------------------------------------
;Progrma fichero simple v2
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
Global posicion, nombre_bdd.s, entrada_bdd.s, nombre_tabla.s
nombre_bdd="rodry_datos"
nombre_tabla.s="fihero_simple"
entrada_bdd="host=localhost port=3306 dbname=rodry_datos"
;posicion para determinar las posiciones de los vectores tanto de las casillas de texto de la ventama como del texto de cada ficha de datos

pass$="1234" ;contraseña para modificacion de datos
Global nombrefichero$="Fichero datos.txt"

Procedure ventana_ayuda() ;del menu de ayuda-acerca de
     
   OpenWindow(#ventana_ayuda, 0, 0, 310, 210, "", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
    TextGadget(#PB_Any, 30, 20, 160, 20, "Fichero simple v1.0")
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

Procedure actualizarvalores() ;Actualiza los valores mostrados por pantalla
 
  ;Procedimiento para actualizar los datos en pantalla con la nueva posicion,
  ; usado al guardar los datos y al usar los botones anterior y posterior
  SetGadgetText(#Ficha, "N° Ficha: " + Str(ListIndex(personas())+1))
  SetGadgetText(#Apellidotext, personas()\apellido)
  SetGadgetText(#Nombretext, personas()\nombre)
  SetGadgetText(#DNItext, personas()\dni)
  SetGadgetText(#BotonGuardar,"Guardar")
  
EndProcedure

Procedure Asignardatos()    ;Funcion para leer los datos y asignarlos a los vetores de apellido, nombre y dni
  If ReadFile(#Archivo,nombrefichero$)
    While Eof(#Archivo)=0
      text$=ReadString(#Archivo)
      AddElement(personas())
      personas()\apellido=StringField(text$,1,",")  ;Se le asigna a cada vector el valor leido en cada posicion delimitada por las comas
      personas()\nombre=StringField(text$,2,",")
      personas()\dni=StringField(text$,3,",")
    Wend
    CloseFile(#Archivo)
  Else
    MessageRequester("Atencion","No se encontro archivo guardado")
  EndIf   
EndProcedure

Procedure actualizar_archivo()  ;Funcion para guardar y actualizar el archivo txt
  CreateFile(#Archivo,nombrefichero$)
  OpenFile(#Archivo,nombrefichero$) ;se borra el archivo gurdado anteriormente y se guarda un nuevo archivo con los valores anteriores
    ForEach personas()         ;recorremos el vector hasta la
      OpenFile(#Archivo,nombrefichero$)
      FileSeek(#Archivo, Lof(#Archivo)) 
      WriteStringN(#Archivo, personas()\apellido + "," + personas()\nombre + "," + personas()\dni)     ;vamos escribiendo las lineas del archivo txt con los vectores que no esten vacios
    Next
    CloseFile(#Archivo)
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

Procedure anterior()
  If ListIndex(personas())>0
    SelectElement(personas(),ListIndex(personas())-1)
    actualizarvalores()
    
  Else
    SelectElement(personas(),ListSize(personas())-1)       ;si estamos en la posicion 0, al presionar anterior nos vamos al ultimo registro ingresado para que quede en modo de "carrusel"
    actualizarvalores()
  EndIf  
EndProcedure

Procedure posterior()
  If ListIndex(personas())<ListSize(personas())-1
    SelectElement(personas(),ListIndex(personas())+1)
    actualizarvalores()
  Else
    SelectElement(personas(),0)      ;Modo de carrusel al igual que con el boton anterior, al llegar al final volvemos al principio
    actualizarvalores()
  EndIf
EndProcedure

Procedure ventana_lista()
  OpenWindow(#ventana_lista, 0, 0, 330, 410, "Lista de Personas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ListViewGadget(#list_personas, 10, 40, 310, 360)
  TextGadget(#PB_Any, 50, 10, 240, 25, "Listado de Personas", #PB_Text_Center)
  ForEach personas()
    If personas()\apellido<>"" : AddGadgetItem(#list_personas,-1,personas()\apellido + ", " + personas()\nombre + " - " + personas()\dni) : EndIf
  Next
  Repeat
    event=WindowEvent()
    If event=#PB_Event_CloseWindow : CloseWindow(#ventana_lista) : EndIf  
    Until event=#PB_Event_CloseWindow
EndProcedure

Procedure consultas()
  SelectElement(personas(),0)
  actualizarvalores()
  ;MessageRequester("Consulta", "Consulta de ficha")
  DisableGadget(#BotonAnterior,0)
  DisableGadget(#BotonPosterior,0)
  DisableGadget(#BotonGuardar,1)
  DisableGadget(#Apellidotext,1)
  DisableGadget(#Nombretext,1)
  DisableGadget(#DNItext,1)
  SetGadgetText(#Titulo,"Sistema de Consultas")
  SetGadgetText(#Ficha,"N° Ficha: " + Str(ListIndex(personas())+1))
EndProcedure

Procedure ingreso()
  LastElement(personas())
  SetGadgetText(#Nombretext,"") : SetGadgetText(#Apellidotext,"") : SetGadgetText(#DNItext,"")
  DisableGadget(#BotonAnterior,1)
  DisableGadget(#BotonPosterior,1)
  DisableGadget(#BotonGuardar,0)
  SetGadgetText(#Titulo,"Sistema de Ingreso")
  SetGadgetText(#Ficha, "N° Ficha: " + Str(ListSize(personas())))
  DisableGadget(#Apellidotext,0)
  DisableGadget(#Nombretext,0)
  DisableGadget(#DNItext,0)
EndProcedure

Procedure modificacion()
  If GetGadgetText(#Nombretext) = ""
    MessageRequester("Error","La ficha se encuentra vacia",#PB_MessageRequester_Error)
    DisableGadget(#BotonAnterior,0)
    DisableGadget(#BotonPosterior,0)
    DisableGadget(#BotonGuardar,1)
    DisableGadget(#Nombretext,1)
    DisableGadget(#Apellidotext,1)
    DisableGadget(#DNItext,1)
  Else
    entrada$ = login()  ;funcion de entrada de contraseña
    If entrada$ = pass$ ;salida de exito en caso de colocar bien la contraseña, sino mensaje de error
      SetGadgetText(#Titulo,"Modificacion de datos")
      DisableGadget(#BotonAnterior,1)
      DisableGadget(#BotonPosterior,1)                  ;habilitacion y desabilitacion de botones segun el caso
      DisableGadget(#BotonGuardar,0)
      SetGadgetText(#BotonGuardar,"Modificar")
      DisableGadget(#Nombretext,0)
      DisableGadget(#Apellidotext,0)
      DisableGadget(#DNItext,0)
      SetGadgetText(#Ficha,"N° Ficha: " + Str(ListIndex(personas())+1))
    Else
      MessageRequester("Error","Error de autenticacion",#PB_MessageRequester_Error)
      SetGadgetText(#Titulo,"Sistema de consultas")
      DisableGadget(#BotonAnterior,0)
      DisableGadget(#BotonPosterior,0)
      DisableGadget(#BotonGuardar,1)
      DisableGadget(#Nombretext,1)
      DisableGadget(#Apellidotext,1)
      DisableGadget(#DNItext,1)
    EndIf
  EndIf 
EndProcedure

Procedure boton_guardar()
  apellido$=title(GetGadgetText(#Apellidotext))  ;formateo de texto introducido a primer letra mayuscula
  nombre$=title(GetGadgetText(#Nombretext))      ;idem anterior
  dni$=GetGadgetText(#DNItext)
  If nombre$=""       ;Mensajes en caso de no completar alguno de los campos
    MessageRequester("Error","No completaste el nombre")
  EndIf
  If apellido$=""
    MessageRequester("Error","No completaste el apellido")
  EndIf
  If dni$=""
    MessageRequester("Error","No completaste el DNI")
  EndIf
  If nombre$<>"" And apellido$<>"" And  dni$<>""        ;Solo guardar las variables en caso de completar todos los campos
    
    If GetGadgetText(#Titulo)<>"Modificacion de datos"    ;si no estamos en modo modificacion de datos aparece mensaje de archivo guardado  
      AddElement(personas())
      MessageRequester("Exito", "Ficha guardada", #PB_MessageRequester_Ok)
    Else
      ;en caso contrario estaremos dentro del menu de modificacion de datos por lo que el mensaje debe aparecer como que se modificaron los datos que ya estaban ingresados correctamente
      DisableGadget(#BotonAnterior,0)
      DisableGadget(#BotonPosterior,0)
      DisableGadget(#BotonGuardar,1)
      DisableGadget(#Nombretext,1)
      DisableGadget(#Apellidotext,1)
      DisableGadget(#DNItext,1)
      SetGadgetText(#Titulo,"Sistema de Consultas") ;se vuelve la ventama a modo de consulta luego de modificar datos
      MessageRequester("Mensaje","Datos modificados correctamente",#PB_MessageRequester_Info)
    EndIf
    personas()\nombre=nombre$
    personas()\apellido=apellido$
    personas()\dni=dni$
    actualizar_archivo()
    actualizarvalores()
  EndIf  
EndProcedure

;Propiedades de la ventana principal
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget |  #PB_Window_SizeGadget

;Proceso principal

Asignardatos()

OpenWindow(#Principal, 0, 0, 650, 340, "Banco de Datos: Fichero Simple",#FLAGS)
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
StatusBarText(#barra_estado,1,"Total personas ingresadas: " + Str(ListSize(personas())),#PB_StatusBar_Center)
Repeat 
  Event.l= WindowEvent()    ;esta linea capta los eventos que pasan en la ventana
  Select Event
      
    Case #PB_Event_Menu
      Select EventMenu()
        Case #MenuConsulta
          consultas()
        Case  #MenuIngreso
          ingreso()
        Case #MenuModificacion
          modificacion()
        Case #Menu_lista
          ventana_lista()
        Case #Ayuda
          ventana_ayuda() ;llamado a funcion de ventana
        Case #anterior_tecla
          If GetGadgetText(#Titulo)="Sistema de Consultas" : anterior() : EndIf  
        Case #posterior_tecla
          If GetGadgetText(#Titulo)="Sistema de Consultas" : posterior() : EndIf 
        Case #tecla_f2
          consultas()
        Case #tecla_f1
          ingreso()
        Case #tecla_f3
          modificacion()
        Case #tecla_intro
          boton_guardar()
        Case #bdd_comprobar
          If OpenDatabase(#bdd_id,entrada_bdd,"rodry","jcmc1719")
            MessageRequester("Conexion exitosa","Se establecio la conexio con la BDD correctamente")
          Else
            MessageRequester("Error","Error la establecer la conexion con la BDD")
          EndIf 
          
      EndSelect
      
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #BotonGuardar
          boton_guardar()
        Case  #BotonAnterior
          anterior()
        Case #BotonPosterior
          posterior()
          
      EndSelect
  EndSelect
Until Event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 365
; FirstLine = 155
; Folding = AA-
; EnableXP
; DPIAware