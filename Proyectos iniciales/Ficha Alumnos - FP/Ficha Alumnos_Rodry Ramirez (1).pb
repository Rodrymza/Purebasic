;Programa que guardar informacion de una ficha de alumnos con fotos
;Base de datos SQL y foto en carpeta local
;Rodry Ramirez(c) 2024

Enumeration
  #main_window : #apellido
  #titulo : #nombre : #acerca_de
  #domicilio : #telefono : #boton_subir_imagen
  #boton_guardar : #boton_anterior
  #boton_siguiente : #dni : #nuevo
  #boton_modificar : #boton_borrar
  #panel_principal : #lista_principal
  #foto_principal :#imagen : #base_datos
  #ventana_ayuda : #boton_de_ayuda
EndEnumeration

UseJPEGImageDecoder() : UseMySQLDatabase() : UsePNGImageDecoder()
Global NewList documentos()
;                                                         la variable imagen_cambiada sirve para detectar si se subio una imagen al ingresar un alumno nuevo, se usara en el proceso del boton guardar
Global dbname.s="host=localhost port=3306 dbname=rodry_datos", user.s="rodry", pass.s="rodry1234", tablename.s="ficha_alumnos", dni_modificar.s, imagen_cambiada
; variables para autenticar la base de datos y para el nombre de la tabla                  *dni modificar sirve para buscar filtrar el dni en la base de datos  y actualizar los campos

If OpenDatabase(#base_datos, dbname, user, pass)
  If DatabaseUpdate(#base_datos,"CREATE TABLE " + tablename + " (dni INT , apellido VARCHAR(45), nombre VARCHAR(45), domicilio VARCHAR(45), telefono INT, PRIMARY KEY(dni))")
    MessageRequester("Atencion","Se creo la tabla correspondiente en la base de datos")
  EndIf
EndIf

Procedure actualizar_lista()  ; actualiza la lista principal cada vez que se cambia agrega o modifica un alumno
  n=0
  ClearList(documentos())
  ClearGadgetItems(#lista_principal)
  OpenDatabase(#base_datos, dbname, user, pass)
  DatabaseQuery(#base_datos,"SELECT * FROM " + tablename + " ORDER BY apellido")
  While NextDatabaseRow(#base_datos)
    AddGadgetItem(#lista_principal,n, Str(GetDatabaseLong(#base_datos,0)) + Chr(10) + GetDatabaseString(#base_datos,1) + ", " + GetDatabaseString(#base_datos,2) + Chr(10) + GetDatabaseString(#base_datos,3) + Chr(10) + Str(GetDatabaseLong(#base_datos,4))) 
    If n%2=0 : SetGadgetItemColor(#lista_principal,n,#PB_Gadget_BackColor,RGB(187, 255, 255)) : Else : SetGadgetItemColor(#lista_principal,n,#PB_Gadget_BackColor,$FACE87) : EndIf 
    AddElement(documentos()) : documentos()=GetDatabaseLong(#base_datos,0)
    n=n+1
  Wend
EndProcedure

Procedure actualizar_campos()
 
    SetGadgetText(#apellido,"") : SetGadgetText(#nombre,"") : SetGadgetText(#telefono,"") : SetGadgetText(#domicilio,"") : SetGadgetText(#dni,"")
    LoadImage(#imagen,"sin_foto.png") 
    ResizeImage(#imagen,160,160)
    SetGadgetState(#foto_principal,ImageID(#imagen))

EndProcedure

Procedure subir_imagen()
  If LoadImage(#imagen,OpenFileRequester("Seleccione foto del estudiante","","Archivos de Imagen (*.jpg, *.png)",0))
    ResizeImage(#imagen,160,160)
    SetGadgetState(#foto_principal,ImageID(#imagen))
    ProcedureReturn 1
  Else
    ProcedureReturn 0
  EndIf 
  
EndProcedure

Procedure guardardatos(dato) ; 0 para  alumno nuevo y 1 para modificar el establecido
  dni$=GetGadgetText(#dni)
  apellido$ =GetGadgetText(#apellido)
  nombre$ = GetGadgetText(#nombre)
  domicilio$ = GetGadgetText(#domicilio)
  telefono$ = GetGadgetText(#telefono)
  If dato=0 
    comandosql.s="INSERT INTO " + tablename + " (dni, apellido, nombre, domicilio, telefono) VALUES (" + dni$ + ", '" + apellido$ +"', '" + nombre$ + "', '" + domicilio$ + "', " + telefono$ + ")"
    mensaje$="Alumno " + apellido$ + " registrado en la base de datos"
  Else
    comandosql.s="UPDATE " + tablename + " SET dni=" + dni$ + ", apellido='" + apellido$ + "', nombre='" + nombre$ + "', domicilio='" + domicilio$ + "', telefono=" + telefono$ + " WHERE dni= " + dni$
    mensaje$="Alumno " + apellido$ + " modificado correctamente"
  EndIf 
  OpenDatabase(#base_datos, dbname, user, pass)
  If DatabaseUpdate(#base_datos, comandosql)
    SaveImage(#imagen,"Fotos\foto_" + dni$ + ".jpg")
    MessageRequester("Exito",mensaje$)
    actualizar_campos()
    actualizar_lista()
  Else 
    MessageRequester("Error",DatabaseError())
    EndIf   
EndProcedure

Procedure verificar_documento(documento)
  repetido=#False
  ForEach documentos()
    If documentos()=documento
      repetido=#True
    EndIf
  Next
  ProcedureReturn repetido
EndProcedure

Procedure modificar(dni_modificar.s)
  SetGadgetState(#panel_principal,0)
  OpenDatabase(#base_datos,dbname,user,pass)
  DatabaseQuery(#base_datos,"SELECT * FROM " + tablename + " WHERE dni=" + dni_modificar)
  NextDatabaseRow(#base_datos)
  SetGadgetText(#dni,Str(GetDatabaseLong(#base_datos,0))) : SetGadgetText(#apellido,GetDatabaseString(#base_datos,1))
  SetGadgetText(#nombre,GetDatabaseString(#base_datos,2))
  SetGadgetText(#domicilio,GetDatabaseString(#base_datos,3)) : SetGadgetText(#telefono,Str(GetDatabaseLong(#base_datos,4)))
  LoadImage(#imagen,"Fotos\foto_" + Str(GetDatabaseLong(#base_datos,0)) + ".jpg")
  ResizeImage(#imagen,160,160)
  SetGadgetState(#foto_principal,ImageID(#imagen))
  SetGadgetText(#boton_guardar,"Modificar")
  imagen_cambiada=1
EndProcedure

Procedure ventana_acercade() ;del menu de ayuda-acerca de
   OpenWindow(#ventana_ayuda, 0, 0, 310, 210, "", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
    TextGadget(#PB_Any, 30, 20, 280, 20, "Gestion de Alumnos v1.0")
    TextGadget(#PB_Any, 30, 50, 160, 20, "Rodry Ramirez (c) 2024")
    TextGadget(#PB_Any, 30, 80, 160, 20, "rodrymza@gmail.com")
    TextGadget(#PB_Any, 30, 110, 190, 20, "Curso Programacion Profesional")
    TextGadget(#PB_Any, 30, 140, 190, 20, "Profesor: Ricardo Ponce")
    ButtonGadget(#boton_de_ayuda, 110, 170, 100, 25, "Aceptar")
    Repeat  
      event.l= WindowEvent()
      Select Event
        Case #PB_Event_CloseWindow
          CloseWindow(#ventana_ayuda)  
        Case #PB_Event_Gadget
          Select EventGadget()
            Case #boton_de_ayuda
              quit=#True
              CloseWindow(#ventana_ayuda)
          EndSelect
      EndSelect
    Until event= #PB_Event_CloseWindow Or quit=#True
  EndProcedure

LoadImage(#imagen,"sin_foto.png") 
ResizeImage(#imagen,160,160)

OpenWindow(#main_window, 0, 0, 560, 440, "Gestion de Alumnos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  CreateMenu(#PB_Any, WindowID(#main_window))
  MenuTitle("Archivo")
  MenuItem(#nuevo,"Nuevo Alumno")
  MenuItem(#acerca_de, "Acerca de")
  TextGadget(#PB_Any, 190, 10, 190, 25, "Ficha de Alumnos", #PB_Text_Center)
  PanelGadget(#panel_principal, 20, 40, 520, 360)
  AddGadgetItem(#panel_principal, -1, "Ingreso y Modificacion")
  TextGadget(#PB_Any, 20, 68, 80, 25, "DNI")
  StringGadget(#dni, 110, 68, 210, 30, "")
  TextGadget(#PB_Any, 20, 108, 80, 25, "Apellido")
  StringGadget(#apellido, 110, 108, 210, 30, "")
  TextGadget(#titulo, 80, 18, 180, 25, "Ingreso de Nuevo Alumno")
  TextGadget(#PB_Any, 20, 148, 80, 25, "Nombre")
  StringGadget(#nombre, 110, 148, 210, 30, "")
  TextGadget(#PB_Any, 20, 188, 80, 25, "Domicilio")
  StringGadget(#domicilio, 110, 188, 210, 30, "")
  TextGadget(#PB_Any, 20, 228, 80, 25, "Telefono")
  StringGadget(#telefono, 110, 228, 210, 30, "", #PB_String_Numeric)
  ButtonGadget(#boton_guardar, 350, 288, 120, 25, "Guardar")
  ButtonGadget(#boton_anterior, 40, 288, 120, 25, "<- Anterior")
  ButtonGadget(#boton_siguiente, 180, 288, 120, 25, "Siguiente ->")
  ImageGadget(#foto_principal, 340, 78, 160, 160, ImageID(#imagen))
  ButtonGadget(#boton_subir_imagen, 355, 18, 130, 20, "Subir Imagen")
  
  AddGadgetItem(#panel_principal, -1, "Lista de Alumnos", 0, 1)
   ListIconGadget(#lista_principal, 10, 30, 500, 258, "DNI", 80,#PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines)
  AddGadgetColumn(#lista_principal, 1, "Apellido y Nombre", 150)
  AddGadgetColumn(#lista_principal, 2, "Domicilio", 170)
  AddGadgetColumn(#lista_principal, 3, "Telefono", 90)
  ButtonGadget(#boton_modificar, 100, 298, 150, 25, "Modificar")
  ButtonGadget(#boton_borrar, 270, 298, 150, 25, "Borrar")
  
  AddGadgetItem(#panel_principal, -1, "Buscar Alumno", 0, 2)

  CloseGadgetList()
  
  actualizar_lista()
  
  Repeat : event=WindowEvent()
    Select event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #boton_subir_imagen
            imagen_cambiada=subir_imagen()
          Case #boton_guardar
            If verificar_documento(Val(GetGadgetText(#dni)))=#True And GetGadgetText(#boton_guardar)="Guardar"
              MessageRequester("Atencion","El documento ya se encuentra ingresado en la base de datos",#PB_MessageRequester_Warning)
              modificar(GetGadgetText(#dni))
              cont=0
            Else
              If imagen_cambiada=0 
                MessageRequester("Atencion","Falta subir la foto",#PB_MessageRequester_Warning)
              Else
                If GetGadgetText(#boton_guardar)="Guardar"
                  guardardatos(0)
                  imagen_cambiada=0
                Else
                  guardardatos(1)
                  imagen_cambiada=0
                EndIf 
              EndIf 
            EndIf 
            
          Case #boton_modificar
            modificar(GetGadgetText(#lista_principal))
            
          Case #apellido
            If EventType()=#PB_EventType_Focus
              If verificar_documento(Val(GetGadgetText(#dni))) And cont=0
                MessageRequester("Atencion","El documento ya se encuentra ingresado en la base de datos",#PB_MessageRequester_Warning)
                modificar(GetGadgetText(#dni))
                cont=cont+1
              EndIf 
            EndIf
          Case #lista_principal
            If EventType()=#PB_EventType_LeftDoubleClick : modificar(GetGadgetText(#lista_principal))  : SelectElement(documentos(),GetGadgetState(#lista_principal)): EndIf 
            
          Case #boton_siguiente
            If ListIndex(documentos())=ListSize(documentos())-1
              FirstElement(documentos())
            Else
              NextElement(documentos())
            EndIf 
            SetGadgetText(#dni,Str(documentos()))
            modificar(Str(documentos()))
            
            Case #boton_anterior
            If ListIndex(documentos())=0
              LastElement(documentos())
            Else
              PreviousElement(documentos())
            EndIf 
            SetGadgetText(#dni,Str(documentos()))
            modificar(Str(documentos()))
        EndSelect
      Case #PB_Event_Menu
        Select EventMenu()
          Case #nuevo 
            actualizar_campos() : SetGadgetText(#boton_guardar,"Guardar")
            imagen_cambiada=0
          Case #acerca_de
            ventana_acercade()
        EndSelect
        
    EndSelect
  Until event=#PB_Event_CloseWindow
  
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 27
; FirstLine = 77
; Folding = B+
; EnableXP
; HideErrorLog