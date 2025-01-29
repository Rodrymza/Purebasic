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

Structure campos
  nombre.s
  apellido.s
  dni.s
EndStructure

 ;tamaño predefinido para campos y registro
 #Largo_Nombre = 20
 #Largo_Apellido = 20
 #Largo_DNI = 8
 #Largo_Registro = #Largo_Nombre + #Largo_Apellido + #Largo_DNI
 Debug #Largo_Registro
  

;Carga de fuentes necesarias
LoadFont(#Calibri16,"Calibri Light", 16)
LoadFont(#Calibri18,"Calibri Light", 18)

;Definicion e inicializacion de variables

Global posicion.l, maxfichas.l=50, Dim listaNombre$(maxfichas), Dim listaDni$(maxfichas), Dim listaApellido$(maxfichas), nombrefichero$, Dim texto$(maxfichas)
Global registro.campos
posicion=0
;posicion para determinar las posiciones de los vectores tanto de las casillas de texto de la ventama como del texto de cada ficha de datos

pass$="1234" ;contraseña para modificacion de datos
nombrefichero$="Fichero binario.txt"

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

Procedure actualizarpantalla(posicion) ;Actualiza los valores mostrados por pantalla
 
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

Procedure guardar_archivo(posicion_ficha)  ;Funcion para guardar y actualizar el archivo txt
  
  pos_grabado= posicion_ficha * #Largo_Registro
  ;Debug "posicion en funcion guardar" + posicion_ficha
  If OpenFile(#Archivo,nombrefichero$)
    FileSeek(#Archivo, pos_grabado)
    ;Debug "fin de linea "  + Lof(#Archivo)
    ;Debug "fin de linea calculado " + posicion_grabado
    WriteString(#Archivo, texto$(posicion_ficha))
    CloseFile(#Archivo)
  Else
    MessageRequester("Error","No se pudo abrir el archivo")
  EndIf 
  
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

Procedure$ formatear_largo(palabra$,largo)
  
  If Len(palabra$)<largo
    palabra_form$=palabra$ + Space(largo-Len(palabra$))
  EndIf
    ProcedureReturn palabra_form$
  
EndProcedure

 Procedure.i Registros_Grabados() ;lee la cantidad de lineas en el txt y determina la cantida de fichas
   
   numero_registros.i = 0
   
   If ReadFile(#Archivo, nombrefichero$) 
     numero_registros = Lof(#Archivo) / #Largo_Registro
     CloseFile(#Archivo)             
   Else
     numero_registros = 0
   EndIf
   
   ;MessageRequester ("numero_registros",Str(numero_registros))
   
   ProcedureReturn numero_registros
  
 EndProcedure 
 
  Procedure.s Leer_Registro (num_ficha)
   
   ; la lectura de un registro se calcula en base
   ; al tamaño del registro y el posicionamiento 
   ; de los datos dentro de un archivo binario
   
   Posicion_de_Lectura.i = 0
   Ficha_leida.s =""  
   ;se calcula la posición actual del puntero 
   ;de lectura en base al numero de registro
   ;que se debe leer
   Posicion_de_Lectura = #Largo_Registro * num_ficha
         
   If ReadFile(#Archivo, nombrefichero$) ;apertura del fichero
     FileSeek(#Archivo, Posicion_de_Lectura) ;posicionamiento del puntero de lecto-escritura
     texto$(num_ficha) = ReadString(#Archivo , #PB_Ascii , #Largo_Registro) ;extracción de datos
     CloseFile(#Archivo)  ;cierre del archivo
   Else
     Ficha_leida = "" ;no se pudo abrir
   EndIf
   
 EndProcedure  
 
 Procedure asignardatos()
   For i=0 To Registros_Grabados()-1
     listaApellido$(i)=Mid(texto$(i),1,#Largo_Apellido)
     listaNombre$(i)=Mid(texto$(i),#Largo_Apellido+1,#Largo_Nombre)
     listaDni$(i)=Mid(texto$(i),#Largo_Nombre+#Largo_Apellido+1,#Largo_DNI)
     ;Debug "Vector asignado a " + i + " " + listaApellido$(i)
     ;Debug "Vector asignado a " + i + " " + listaNombre$(i)
     ;Debug "Vector asignado a " + i + " " + listaDni$(i)
     Next
 EndProcedure
 
 Procedure ordenar(Array vector$(1),posicionfinal)
For i=0 To posicionfinal
  For j=i To posicionfinal
    If vector$(i)>vector$(j)
      aux$=vector$(i)
      vector$(i)=vector$(j)
      vector$(j)=aux$
    EndIf
  Next
Next
EndProcedure

Procedure actualizacion()
  
  For i=0 To Registros_Grabados()
    Leer_Registro(i)
    ;Debug "Vector en " + i  + texto$(i) + Len(texto$(i))
  Next

For i=0 To posicion
  ;Debug "lista texto " + i + texto$(i)
Next

asignardatos()

EndProcedure

 
;Propiedades de la ventana principal
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget |  #PB_Window_SizeGadget

;Proceso principal
OpenWindow(#Principal, 0, 0, 650, 340, "Banco de Datos: Fichero Simple",#FLAGS)

posicion=Registros_Grabados()
;Debug "posicion inicial" + posicion
actualizacion()

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
          posfinal=Registros_Grabados()-1
          posicion=0 ;colocamos el la posicion en el ultimo fichero guardado
          actualizarpantalla(posicion)
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
          posicion=Registros_Grabados()  ;ponemos el fichero en la primer posicion vacia
          actualizarpantalla(posicion)
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
            posicion=0
            DisableGadget(#BotonAnterior,0)
            DisableGadget(#BotonPosterior,0)
            DisableGadget(#BotonGuardar,1)
            DisableGadget(#BotonGuardar,1)
            DisableGadget(#Apellidotext,1)
            DisableGadget(#Nombretext,1)
            DisableGadget(#DNItext,1)
            actualizarpantalla(posicion)
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
          ;formateo hasta maxima longitud y formato titulo
          registro\apellido=title(Left(GetGadgetText(#Apellidotext),#Largo_Apellido+1))  ;formateo de texto introducido a primer letra mayuscula
          registro\nombre=title(Left(GetGadgetText(#Nombretext),#Largo_Nombre+1))
          registro\dni=Left(GetGadgetText(#DNItext),#Largo_DNI+1)
             ;guardado de vector de texto para guardar despues en fichero
          If registro\nombre=""       ;Mensajes en caso de no completar alguno de los campos
            MessageRequester("Error","No completaste el nombre")
          EndIf
          If registro\apellido=""
            MessageRequester("Error","No completaste el apellido")
          EndIf
          If registro\dni=""
            MessageRequester("Error","No completaste el DNI")
          EndIf
          If registro\apellido<>"" And registro\nombre<>"" And  registro\dni<>""        ;Solo guardar las variables en caso de completar todos los campos
            
            If Len(registro\apellido)<#Largo_Apellido : registro\apellido=formatear_largo(registro\apellido,#Largo_Apellido) : EndIf   ;coloco espacios hasta llegar a la longitud predeterminada
            If Len(registro\nombre)<#Largo_Nombre : registro\nombre=formatear_largo(registro\nombre,#Largo_Nombre) : EndIf  
            If Len(registro\dni)<#Largo_DNI : registro\dni=formatear_largo(registro\dni,#Largo_DNI) : EndIf 
            
            listaApellido$(posicion)=registro\apellido
            listanombre$(posicion)=registro\nombre
            listaDni$(posicion)=registro\dni
            texto$(posicion) = registro\apellido + registro\nombre + registro\dni
            
           ;Debug "nombre: " + listaNombre$(posicion) + "len " + Len(listaNombre$(posicion))
           ; Debug "apellido: " + listaApellido$(posicion) + "len " + Len(listaApellido$(posicion))
            ;Debug "dni: " + listaDni$(posicion) + "len " + Len(listaDni$(posicion))
            ;Debug "array texto$" + texto$(posicion) + "# fin de linea" 
            If GetGadgetText(#Titulo)<>"Modificacion de datos"    ;si no estamos en modo modificacion de datos aparece mensaje de archivo guardado
              
              MessageRequester("Exito", "Ficha guardada", #PB_MessageRequester_Ok)
              OpenFile(#Archivo,nombrefichero$)

              guardar_archivo(posicion)
              ;Debug "se guarda el archivo de posicion " + posicion
              posicion=posicion+1
              actualizarpantalla(posicion)
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

              OpenFile(#Archivo,nombrefichero$)
              
              
              guardar_archivo(posicion)
              Debug "posicion enviada" + posicion
              actualizacion()
              posicion=0
              actualizarpantalla(posicion)
              
            EndIf
            
            
           
          Else
            MessageRequester("Error","No se guardo la ficha",#PB_MessageRequester_Error) ;error al faltar datos para guardar
          EndIf 
        Case  #BotonAnterior
          If posicion>0
            posicion=posicion-1
            actualizarpantalla(posicion)
            
          Else
            posicion=posfinal       ;si estamos en la posicion 0, al presionar anterior nos vamos al ultimo registro ingresado para que quede en modo de "carrusel"
            actualizarpantalla(posicion)
          EndIf
          
        Case #BotonPosterior
          If posicion<posfinal
            posicion=posicion+1
            actualizarpantalla(posicion)
          Else
            posicion=0      ;Modo de carrusel al igual que con el boton anterior, al llegar al final volvemos al principio
            actualizarpantalla(posicion)
          EndIf
          
      EndSelect
  EndSelect
Until Event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 157
; FirstLine = 82
; Folding = Cg
; Markers = 447
; EnableXP
; DPIAware