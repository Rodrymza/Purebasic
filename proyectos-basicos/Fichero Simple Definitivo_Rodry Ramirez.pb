;Banco de datos, fichero simple que guarde nombrea, apellido y dni (ficha)
;ventana debe tener
;menu con ingreso de datos, consulta
;3 campos para guardar
;boton avanzar y retroceder
;boton de grabacion
;---------------------------------------------
;Progrma fichero simple
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
EndEnumeration

Enumeration FormFont ;constantes para fuentes
  #Calibri16
  #Calibri18
EndEnumeration

;Carga de fuentes necesarias
LoadFont(#Calibri16,"Calibri Light", 16)
LoadFont(#Calibri18,"Calibri Light", 18)

;Definicion e inicializacion de variables

Global posicion.l, maxfichas.l=50, Dim listaNombre$(maxfichas), Dim listaDni$(maxfichas), Dim listaApellido$(maxfichas), nombrefichero$, Dim texto$(maxfichas)
;posicion para determinar las posiciones de los vectores tanto de las casillas de texto de la ventama como del texto de cada ficha de datos

pass$="1234" ;contraseña para modificacion de datos
nombrefichero$="Fichero datos.txt"

For i=0 To 19     ;inicializacion de vector en 0
  texto$(i)=""
Next

Procedure posfinal() ;establece la ultima posicion donde se encuentra un arreglo vacio
  For i=0 To maxfichas-1
    If texto$(i)<>""
      posicionfinal=i
    EndIf
  Next
  ProcedureReturn posicionfinal
EndProcedure

Procedure ordenar() ;ordena el arreglo en orden alfabetico
  posicionfinal=posfinal()
  
  For i=0 To posicionfinal
    For j=i To posicionfinal
      If texto$(i)>texto$(j)
        aux$=texto$(i)
        texto$(i)=texto$(j)
        texto$(j)=aux$
      EndIf
    Next
  Next
EndProcedure

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

Procedure actualizarvalores(posicion) ;Actualiza los valores mostrados por pantalla
 
  ;Procedimiento para actualizar los datos en pantalla con la nueva posicion,
  ; usado al guardar los datos y al usar los botones anterior y posterior
  SetGadgetText(#Ficha, "N° Ficha: " + Str(posicion+1))
  SetGadgetText(#Apellidotext, listaApellido$(posicion))
  SetGadgetText(#Nombretext, listaNombre$(posicion))
  SetGadgetText(#DNItext, listaDni$(posicion))
  SetGadgetText(#BotonGuardar,"Guardar")
  
EndProcedure

Procedure.s login() ;login para colocar contraseña para entrar al menu de modificacion
pass$="1234"
salir=#False  ;Variable para salir de la ventana al colocar bien la contraseña
#Propiedades = #PB_Window_SystemMenu | #PB_Window_ScreenCentered 


OpenWindow(#Ventanacontrasenia, 0, 0, 470, 140, "Login Gerencia", #Propiedades)
  
  ;Elementos de ventana (Gadgets y menus)
  TextGadget(#Ventanacontrasenia, 120, 30, 200, 30, "Ingrese contraseña de gerencia", #PB_Text_Center)
  StringGadget(#Contrasenia, 140, 60, 180, 25, "")
  ButtonGadget(#Botoncontrasenia, 180, 100, 100, 25, "Ingresar", #PB_Button_MultiLine)
  
  Repeat 
    Event.l= WindowEvent()   
    Select Event
      Case #PB_Event_CloseWindow
        CloseWindow(#Ventanacontrasenia)
      Case  #PB_Event_Gadget
        Select EventGadget()
          Case #botoncontrasenia
            contrasenia$=GetGadgetText(#Contrasenia)
            If contrasenia$=pass$
              MessageRequester("Accedido","Acceso concedido", #PB_MessageRequester_Info)
              salir=#True
              CloseWindow(#Ventanacontrasenia)
            Else
              
              MessageRequester("Error","Contraseña incorrecta", #PB_MessageRequester_Error)
            EndIf 
        EndSelect
    EndSelect
    
  Until Event= #PB_Event_CloseWindow Or salir=#True
  
  ProcedureReturn contrasenia$
EndProcedure

Procedure Asignardatos()    ;Funcion para leer los datos y asignarlos a los vetores de apellido, nombre y dni
  ;se usa la funcion stringfield que separa las cadenas de texto con un delimitador especifico, en este caso con las comas ","
  n.l=0
  If ReadFile(#Archivo,nombrefichero$)
    While Eof(#Archivo)=0
      text$=ReadString(#Archivo)
      listaApellido$(n)=StringField(text$,1,",")  ;Se le asigna a cada vector el valor leido en cada posicion delimitada por las comas
      listaNombre$(n)=StringField(text$,2,",")
      listaDni$(n)=StringField(text$,3,",")
      n=n+1
    Wend
    CloseFile(#Archivo)
  EndIf   
EndProcedure

Procedure valorposicion() ;Funcion para buscar la primer posicion vacia al arrancar el programa
  
  posicioninicial.l=0
  If ReadFile(#Archivo, nombrefichero$) 
    While Eof(#Archivo) = 0
      texto$(posicioninicial)=ReadString(#Archivo)
      posicioninicial=posicioninicial+1               ;se lee el archivo hasta el final, la ultima linea corresponde con el valor de la posicion inicial
    Wend
    CloseFile(#Archivo)
    If posicioninicial<>0
      MessageRequester("Atencion","Se encontro un archivo guardado con " + Str(posicioninicial) + " fichas" ,#PB_MessageRequester_Info) ;Mensaje al encontrar archivo de fichas
    EndIf
  EndIf
  
  ProcedureReturn posicioninicial ;devolvemos como resultado la posicion inicial encontrada en la funcion
EndProcedure

Procedure actualizar_archivo()  ;Funcion para guardar y actualizar el archivo txt
  ordenar()   ;ordenamos vector en orden alfabetico primero
  DeleteFile(nombrefichero$)  ;se borra el archivo gurdado anteriormente y se guarda un nuevo archivo con los valores anteriores
    For i=0 To maxfichas-1         ;recorremos el vector hasta la
    If texto$(i)<>""
      OpenFile(#Archivo,nombrefichero$)
      FileSeek(#Archivo, Lof(#Archivo)) 
      WriteStringN(#Archivo, texto$(i))     ;vamos escribiendo las lineas del archivo txt con los vectores que no esten vacios
    EndIf
  Next
  Asignardatos()    ;se actualizan los datos de los vectores
    ;no cierro el archivo ya que la funcion asignar datos cierra el archivo, sino daria error
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
;Propiedades de la ventana principal
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget |  #PB_Window_SizeGadget

;Proceso principal
OpenWindow(#Principal, 0, 0, 650, 340, "Banco de Datos: Fichero Simple",#FLAGS)

result.l=OpenFile(#Archivo,nombrefichero$)  ;buscamos si hay un archivo de fichas guardado
If result=0
  CreateFile(#Archivo,nombrefichero$)       ;en caso de no encontrar archivo, lo creamos, esto es para no sobreescribir el posible archivo que haya guardado con anterioridad
EndIf 

posicion=valorposicion()  ;llamado a funcion para encontrar la posicion inicial en caso de haber archivo guardado
Asignardatos()
posicionfinal=posfinal()
CreateMenu(0, WindowID(#Principal))
MenuTitle("Sistema")                    ;Barras de menu
MenuItem(#MenuIngreso, "Ingreso")
MenuItem(#MenuConsulta, "Consulta")
MenuItem(#MenuModificacion, "Modificar")
MenuTitle("Ayuda")
MenuItem(#Ayuda,"Acerca de")

TextGadget(#Apellido, 40, 70, 100, 25, "Apellido")
SetGadgetFont(#Apellido, FontID(#Calibri16))
TextGadget(#Nombre, 40, 120, 100, 25, "Nombre")
SetGadgetFont(#Nombre, FontID(#Calibri16))
TextGadget(#DNI, 40, 170, 100, 25, "DNI")
SetGadgetFont(#DNI, FontID(#Calibri16))
TextGadget(#Ficha, 490, 20, 130, 60, "N° Ficha: " + Str(posicion+1))     ;Cuadros de texto
SetGadgetFont(#Ficha, FontID(#Calibri18))
StringGadget(#Apellidotext, 150, 70, 200, 30, listaApellido$(posicion))
SetGadgetFont(#Apellidotext, FontID(#Calibri18))
StringGadget(#Nombretext, 150, 120, 200, 30, listaNombre$(posicion))
SetGadgetFont(#Nombretext, FontID(#Calibri18))
StringGadget(#DNItext, 150, 170, 200, 30, listaDni$(posicion))
SetGadgetFont(#DNItext, FontID(#Calibri18))
TextGadget(#Titulo, 0, 10, 650, 35, "Sistema de Ingreso", #PB_Text_Center)
SetGadgetFont(#Titulo, FontID(#Calibri18))

ButtonGadget(#BotonAnterior, 210, 260, 120, 35, "<- Anterior")
DisableGadget(#BotonAnterior,1)
ButtonGadget(#BotonGuardar, 360, 260, 120, 35, "Guardar")        ;Botones
ButtonGadget(#BotonPosterior, 510, 260, 120, 35, "Posterior ->")
DisableGadget(#BotonPosterior,1)

Repeat 
  Event.l= WindowEvent()    ;esta linea capta los eventos que pasan en la ventana
  Select Event
      
    Case #PB_Event_Menu
      Select EventMenu()
        Case #MenuConsulta
          posicion=posfinal()   ;colocamos el la posicion en el ultimo fichero guardado
          posicionfinal=posfinal()  ;actualizamos para buscar la ultima posicion con un fichero
          actualizarvalores(posicion)
          ;MessageRequester("Consulta", "Consulta de ficha")
          DisableGadget(#BotonAnterior,0)
          DisableGadget(#BotonPosterior,0)
          DisableGadget(#BotonGuardar,1)
          DisableGadget(#Apellidotext,1)
          DisableGadget(#Nombretext,1)
          DisableGadget(#DNItext,1)
          SetGadgetText(#Titulo,"Sistema de Consultas")
          SetGadgetText(#Ficha,"N° Ficha: " + Str(posicion+1))
          
        Case  #MenuIngreso
          posicion=posfinal()+1   ;ponemos el fichero en la primer posicion vacia
          actualizarvalores(posicion)
          DisableGadget(#BotonAnterior,1)
          DisableGadget(#BotonPosterior,1)
          DisableGadget(#BotonGuardar,0)
          SetGadgetText(#Titulo,"Sistema de Ingreso")
          SetGadgetText(#Ficha, "N° Ficha: " + Str(posicion+1))
          DisableGadget(#Apellidotext,0)
          DisableGadget(#Nombretext,0)
          DisableGadget(#DNItext,0)
          
        Case #MenuModificacion
          
          If GetGadgetText(#Nombretext)=""
            MessageRequester("Error","La ficha se encuentra vacia",#PB_MessageRequester_Error)
            posicion=posfinal()
            DisableGadget(#BotonAnterior,0)
            DisableGadget(#BotonPosterior,0)
            DisableGadget(#BotonGuardar,1)
            DisableGadget(#BotonGuardar,1)
            DisableGadget(#Apellidotext,1)
            DisableGadget(#Nombretext,1)
            DisableGadget(#DNItext,1)
            actualizarvalores(posicion)
          Else
            
            entrada$=login()  ;funcion de entrada de contraseña
            
            If entrada$=pass$ ;salida de exito en caso de colocar bien la contraseña, sino mensaje de error
              
              SetGadgetText(#Titulo,"Modificacion de datos")
              DisableGadget(#BotonAnterior,1)
              DisableGadget(#BotonPosterior,1)                  ;habilitacion y desabilitacion de botones segun el caso
              DisableGadget(#BotonGuardar,0)
              SetGadgetText(#BotonGuardar,"Modificar")
              DisableGadget(#Nombretext,0)
              DisableGadget(#Apellidotext,0)
              DisableGadget(#DNItext,0)
              SetGadgetText(#Ficha,"N° Ficha: " + Str(posicion+1))
            Else
              MessageRequester("Error","Error de autenticacion",#PB_MessageRequester_Error)
              SetGadgetText(#Titulo,"Sistema de consultas")
              DisableGadget(#BotonAnterior,0)
              DisableGadget(#BotonPosterior,0)
              DisableGadget(#BotonGuardar,1)
              DisableGadget(#Nombretext,1)
              DisableGadget(#Apellidotext,1)
              DisableGadget(#DNItext,1)
              SetGadgetText(#Ficha,"N° Ficha: " + Str(posicion+1))
            EndIf
            
          EndIf 
          
        Case #Ayuda
          ventana_ayuda() ;llamado a funcion de ventana
      EndSelect
      
    Case #PB_Event_Gadget
      Select EventGadget()
          
        Case #BotonGuardar
          apellido$=title(GetGadgetText(#Apellidotext)) : Debug apellido$    
          nombre$=title(GetGadgetText(#Nombretext)) : Debug nombre$          
          dni$=GetGadgetText(#DNItext)
          
          texto$(posicion) = apellido$ + "," + nombre$ + "," + dni$   ;guardado de vector de texto para guardar despues en fichero
          ;Debug texto$(posicion)
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
            listaApellido$(posicion)=nombre$
            listanombre$(posicion)=apellido$
            listaDni$(posicion)=GetGadgetText(#DNItext)
            
          
            If GetGadgetText(#Titulo)<>"Modificacion de datos"    ;si no estamos en modo modificacion de datos aparece mensaje de archivo guardado
            
              MessageRequester("Exito", "Ficha guardada", #PB_MessageRequester_Ok)
              posicion = posicion+1
              
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
              posicion=0
              
            EndIf
            actualizar_archivo()
            actualizarvalores(posicion)
          Else
            MessageRequester("Error","No se guardo la ficham falta completar campos", #PB_MessageRequester_Error)
          EndIf 
        Case  #BotonAnterior
          If posicion>0
            posicion=posicion-1
            actualizarvalores(posicion)
            
          Else
            posicion=posfinal()       ;si estamos en la posicion 0, al presionar anterior nos vamos al ultimo registro ingresado para que quede en modo de "carrusel"
            actualizarvalores(posicion)
          EndIf
          
        Case #BotonPosterior
          If posicion<posfinal()
            posicion=posicion+1
            actualizarvalores(posicion)
          Else
            posicion=0      ;Modo de carrusel al igual que con el boton anterior, al llegar al final volvemos al principio
            actualizarvalores(posicion)
          EndIf
          
      EndSelect
  EndSelect
Until Event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 406
; FirstLine = 208
; Folding = B5
; EnableXP
; DPIAware