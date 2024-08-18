;Gestion de alumnos, calificaciones, promedios y datos personales
;---------------------------------------------
;Programa Gestion de Alumnos v 0.1
;Rodry Ramirez (c) 2024
; rodrymza@gmail.com

Enumeration 
  #ventanaPrincipal
  #menuConsulta
  #menuIngreso
  #Apellido
  #Nombre
  #DNI
  #Nacimiento
  #texto_busqueda
  #aus_injustificadas
  #aus_justificadas
  #total_ausencias
  #tardanzas
  #tel_contacto
  #nota_lengua
  #nota_matematica
  #nota_ingles
  #nota_naturales
  #nota_sociales
  #nota_fisica
  #combo_alumnos
  #boton_guardar
  #combo_materias
  #menuAgregar
  #ventanaAgregarEstudiante
  #estudiante_agregado
  #boton_agregar
  #archivoDatos
  #curso
EndEnumeration


Enumeration FormFont
  #Calibri16
  #Calibri18
EndEnumeration

;variables y estructuras
Structure datos
  dni.s
  apellido.s
  nombre.s
  nacimiento.s
  contacto.s
  Array lengua.f(3)
  Array matematica.f(3)
  Array ingles.f(3)
  Array naturales.f(3)
  Array sociales.f(3)
  Array fisica.f(3)
  justificadas.l
  injustificadas.l
  tardanzas.l
  totales.l
EndStructure

Global NewMap estudiantes.datos ()
Global id.s="", Dim Etapas$(3), num_etapa.i, nombrefichero$="Alumnos.txt"
Etapas$(0) = "1 Primer trimestre" : Etapas$(1) = "2 Segundo trimestre" : Etapas$(2) = "3 Tercer trimestre" : Etapas$(3) = "4 Promedio Anual"


id.s = "00000000"
estudiantes(id)\dni = "00000000"
estudiantes(id)\apellido = "Doe"
estudiantes(id)\nombre = "John"
estudiantes(id)\nacimiento = "xx-xx-xxxx"
estudiantes(id)\contacto = "xxxxxxxxxx"

estudiantes(id)\justificadas = 4
estudiantes(id)\injustificadas = 2
estudiantes(id)\tardanzas = 2
estudiantes(id)\totales = estudiantes(id)\justificadas + estudiantes(id)\injustificadas + estudiantes(id)\tardanzas / 2
;Funciones

Procedure validarInt(entrada$)
  Protected i
  r=#True
  For i=1 To Len(entrada$)
    If Mid(entrada$,i,1)<"0" Or Mid(entrada$,i,1)>"9"
      r=#False 
    EndIf
  Next
  ProcedureReturn r
EndProcedure

Procedure ValidarFloat(entrada$)
  Protected i,j
  r=#True
  i=1
  validos$=".1234567890"
  Debug i
  For i=1 To Len(entrada$)
    For j=1 To Len(validos$)
      If Mid(entrada$,i,1)=Mid(validos$,j,1)
        cont=cont+1
      EndIf 
    Next
    If Mid(entrada$,i,1)="."
      coma=coma+1
    EndIf 
  Next
  
  If cont<>Len(entrada$) Or coma>1
    r=#False
  EndIf
  ProcedureReturn r
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

Procedure actualizarPantalla()
  SetGadgetText(#dni,id)
  ;Debug id
  SetGadgetText(#apellido ,estudiantes(id)\apellido)
  SetGadgetText(#Nombre ,estudiantes(id)\nombre)
  SetGadgetText(#Nacimiento ,estudiantes(id)\nacimiento)
  SetGadgetText(#aus_injustificadas ,Str(estudiantes(id)\injustificadas))
  SetGadgetText(#aus_justificadas ,Str(estudiantes(id)\justificadas))
  SetGadgetText(#tardanzas ,Str(estudiantes(id)\tardanzas))
  SetGadgetText(#total_ausencias ,Str(estudiantes(id)\totales))
  SetGadgetText(#tel_contacto, estudiantes(id)\contacto)
EndProcedure

Procedure desactivarCampos(valor)
  DisableGadget(#dni,valor) : DisableGadget(#Apellido,valor)
  DisableGadget(#Nombre,valor) : DisableGadget(#Nacimiento,valor)
  DisableGadget(#aus_injustificadas,valor) : DisableGadget(#aus_justificadas,valor)
  DisableGadget(#tardanzas,valor) : DisableGadget(#total_ausencias,valor)
  DisableGadget(#nota_lengua,valor) : DisableGadget(#nota_fisica,valor)
  DisableGadget(#nota_matematica,valor) : DisableGadget(#nota_ingles,valor)
  DisableGadget(#nota_naturales,valor) : DisableGadget(#nota_sociales,valor)
  DisableGadget(#tel_contacto,valor) 
EndProcedure

Procedure.s Agregar_estudiante()
  
   OpenWindow(#ventanaAgregarEstudiante, 0, 0, 310, 110, "", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
   TextGadget(#PB_Any, 60, 20, 180, 25, "Coloque DNI del Alumno", #PB_Text_Center)
   StringGadget(#estudiante_agregado, 90, 40, 140, 25, "")
   ButtonGadget(#boton_agregar, 110, 70, 100, 25, "Agregar")
    
    Repeat  
      event.l= WindowEvent()
      Select Event
        Case #PB_Event_CloseWindow
          CloseWindow(#ventanaAgregarEstudiante)
        Case #PB_Event_Gadget
          Select EventGadget()
            Case #boton_agregar
              texto$=GetGadgetText(#estudiante_agregado)
              quit=#True
              CloseWindow(#ventanaAgregarEstudiante)
          EndSelect
      EndSelect
      
    Until event= #PB_Event_CloseWindow Or quit=#True
  
  ProcedureReturn texto$
EndProcedure

Procedure validacionDatos()
  r=#True
  If Not validarInt(GetGadgetText(#dni))
    MessageRequester("Error","DNI Incorrecto",#PB_MessageRequester_Error)
    r=#False
  EndIf  
  If Not validarInt(GetGadgetText(#tel_contacto))
    MessageRequester("Error","Telefono de contacto incorrecto",#PB_MessageRequester_Error)
    r=#False
  EndIf  
  If Not validarInt(GetGadgetText(#aus_justificadas)) Or Not validarInt(GetGadgetText(#aus_injustificadas)) Or Not validarInt(GetGadgetText(#tardanzas))
    MessageRequester("Error","Cuadro de ausencias y tardanzas mal ingresado",#PB_MessageRequester_Error)
    r=#False 
  EndIf  
   If Not ValidarFloat(GetGadgetText(#nota_fisica)) Or Not ValidarFloat(GetGadgetText(#nota_ingles)) Or Not ValidarFloat(GetGadgetText(#nota_lengua)) Or Not ValidarFloat(GetGadgetText(#nota_matematica)) Or Not ValidarFloat(GetGadgetText(#nota_naturales)) Or Not ValidarFloat(GetGadgetText(#nota_sociales))
     MessageRequester("Error","Notas mal ingresadas",#PB_MessageRequester_Error)
     r=#False 
   EndIf  
   
   ProcedureReturn r
 EndProcedure


   Procedure obtener_datos()
     estudiantes(id)\dni = GetGadgetText(#dni)
     estudiantes(id)\apellido = title(GetGadgetText(#Apellido))
     estudiantes(id)\nombre = title(GetGadgetText(#Nombre))
     estudiantes(id)\nacimiento = GetGadgetText(#Nacimiento)
    estudiantes(id)\contacto = GetGadgetText(#tel_contacto)
    estudiantes(id)\justificadas = Val(GetGadgetText(#aus_injustificadas))
    estudiantes(id)\injustificadas = Val(GetGadgetText(#aus_justificadas))
    estudiantes(id)\tardanzas = Val(GetGadgetText(#tardanzas))
    estudiantes(id)\totales = estudiantes(id)\justificadas + estudiantes(id)\injustificadas + estudiantes(id)\tardanzas / 2
    estudiantes(id)\lengua(num_etapa) = Val(GetGadgetText(#nota_lengua))
    estudiantes(id)\matematica(num_etapa) = Val(GetGadgetText(#nota_matematica))
    estudiantes(id)\ingles(num_etapa) =  Val(GetGadgetText(#nota_ingles))           ;error en obtencion notas
    estudiantes(id)\sociales(num_etapa) = Val(GetGadgetText(#nota_sociales))
    estudiantes(id)\naturales(num_etapa) = Val(GetGadgetText(#nota_naturales))
    estudiantes(id)\fisica(num_etapa) = Val(GetGadgetText(#nota_fisica))
  
EndProcedure

Procedure actualizar_materias()
  
  SetGadgetText(#nota_lengua,StrF(estudiantes(id)\lengua(num_etapa),2))
  SetGadgetText(#nota_matematica,StrF(estudiantes(id)\matematica(num_etapa),2))
  SetGadgetText(#nota_ingles,StrF(estudiantes(id)\ingles(num_etapa),2))
  SetGadgetText(#nota_sociales,StrF(estudiantes(id)\sociales(num_etapa),2))
  SetGadgetText(#nota_naturales,StrF(estudiantes(id)\naturales(num_etapa),2))
  SetGadgetText(#nota_fisica,StrF(estudiantes(id)\fisica(num_etapa),2))
  
EndProcedure

Procedure Agregar_a_combobox()
  
  ClearGadgetItems(#combo_alumnos)
   ForEach estudiantes()
     ;If estudiantes()\nombre<>""
     AddGadgetItem(#combo_alumnos,-1, MapKey(estudiantes()) + ", " + estudiantes()\apellido + ", " + estudiantes()\nombre)
     ;EndIf  
  Next
EndProcedure

Procedure GuardarArchivo()
  CreateFile(#archivoDatos,nombrefichero$)
  ForEach estudiantes()
    
      texto$ = estudiantes()\dni + "," + estudiantes()\apellido + "," + estudiantes()\nombre + "," + estudiantes()\nacimiento + "," + estudiantes()\injustificadas + "," + estudiantes()\justificadas + "," + estudiantes()\tardanzas + "," + estudiantes()\totales + "," + estudiantes()\contacto
      Debug "Texto a escribir hasta contactos " + texto$
      For i= 0 To 3
        aux$= Str(estudiantes()\lengua(i)) + "," + Str(estudiantes()\matematica(i)) + "," + Str(estudiantes()\ingles(i)) + "," + Str(estudiantes()\naturales(i)) + "," + Str(estudiantes()\sociales(i)) + "," + Str(estudiantes()\fisica(i))
        Debug "aux " + aux$
        notas$ = notas$ + "," +  aux$
      Next
      Debug "notas quedan asi " + notas$
      texto$ = texto$  + notas$
      
      Debug "texto completo " + texto$
      WriteStringN(#archivoDatos,texto$)
      notas$=""
      
    Next
   
  CloseFile(#archivoDatos)
  
EndProcedure

Procedure Leer_archivo()

  If ReadFile(#archivoDatos,nombrefichero$)
    While Eof(#archivoDatos)=0
      linea$=ReadString(#archivoDatos)
      id=StringField(linea$,1,",")
      AddMapElement(estudiantes(),id)
      estudiantes(id)\dni = id
      estudiantes(id)\apellido = StringField(linea$,2,",")
      estudiantes(id)\nombre = StringField(linea$,3,",")
      estudiantes(id)\nacimiento = StringField(linea$,4,",")
      estudiantes(id)\injustificadas = Val(StringField(linea$,5,","))
      estudiantes(id)\justificadas = Val(StringField(linea$,6,","))
      estudiantes(id)\tardanzas = Val(StringField(linea$,7,","))
      estudiantes(id)\totales = Val(StringField(linea$,8,","))
      estudiantes(id)\contacto = StringField(linea$,9,",")
      n=10
      For i=0 To 3
        estudiantes(id)\lengua(i) = Val(StringField(linea$,n,","))
        n=n+1
        estudiantes(id)\matematica(i) = Val(StringField(linea$,n,","))
        n=n+1
        estudiantes(id)\ingles(i) = Val(StringField(linea$,n,","))
        n=n+1
        estudiantes(id)\naturales(i) = Val(StringField(linea$,n,","))
        n=n+1
        estudiantes(id)\sociales(i) = Val(StringField(linea$,n,","))
        n=n+1
        estudiantes(id)\fisica(i) = Val(StringField(linea$,n,","))
        n=n+1
      Next
    Wend
    CloseFile(#archivoDatos)
  Else
    MessageRequester("Atencion", "No se encontro archivo de datos")
   
  EndIf 
  
EndProcedure

Procedure obtener_promedios()
  ForEach estudiantes()
    
  estudiantes()\lengua(3) = ((estudiantes()\lengua(0) + estudiantes()\lengua(1) + estudiantes()\lengua(2)) / 3)
  estudiantes()\matematica(3) = ((estudiantes()\matematica(0) + estudiantes()\matematica(1) + estudiantes()\matematica(2)) /3)
  estudiantes()\ingles(3) =  ((estudiantes()\ingles(0) + estudiantes()\ingles(1) + estudiantes()\ingles(2)) / 3)         
  estudiantes()\sociales(3) = ((estudiantes()\sociales(0) + estudiantes()\sociales(1) + estudiantes()\sociales(2)) / 3)
  estudiantes()\naturales(3) = ((estudiantes()\naturales(0) + estudiantes()\naturales(1) + estudiantes()\naturales(2)) / 3)
  estudiantes()\fisica(3) = ((estudiantes()\fisica(0) + estudiantes()\fisica(1) + estudiantes()\fisica(2)) / 3 )
 
  Debug "lengua 1 " + estudiantes()\lengua(0)
  Debug "lengua 2 " + estudiantes()\lengua(1)
   Debug "lengua 3 " + estudiantes()\lengua(2)
  Debug estudiantes()\lengua(0) + estudiantes()\lengua(1) + estudiantes()\lengua(2)
  Next
EndProcedure


;Flags ventana
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered |  #PB_Window_SizeGadget


OpenWindow(#ventanaPrincipal, 0, 0, 610, 450, "Nombre de ventana",#FLAGS)


;Elementos de ventana (Gadgets y menus)
CreateMenu(0, WindowID(Window_0))
MenuTitle("Archivo")
MenuItem(#menuConsulta, "Modo consulta")
MenuItem(#menuIngreso, "Modo Edicion")
MenuItem(#menuAgregar, "Agregar estudiante")
TextGadget(#PB_Any, 140, 10, 270, 25, "Gestion de alumnos", #PB_Text_Center)
TextGadget(#PB_Any, 20, 40, 50, 20, "Curso:", #PB_Text_Right)
ComboBoxGadget(#curso, 80, 40, 60, 20)
TextGadget(#PB_Any, 160, 40, 50, 20, "Alumno:", #PB_Text_Right)
ComboBoxGadget(#combo_alumnos, 220, 40, 210, 20)
TextGadget(#PB_Any, 10, 80, 100, 25, "Datos personales:")
TextGadget(#PB_Any, 10, 140, 60, 25, "Apellido:")
TextGadget(#PB_Any, 10, 170, 60, 25, "Nombre: ")
TextGadget(#PB_Any, 10, 110, 60, 25, "DNI:")
TextGadget(#PB_Any, 10, 200, 40, 25, "F/nac:")
StringGadget(#DNI, 70, 110, 100, 20, "")
StringGadget(#Apellido, 70, 140, 100, 20, "")
StringGadget(#Nombre, 70, 170, 100, 20, "")
StringGadget(#Nacimiento, 70, 200, 100, 20, "")
StringGadget(#aus_injustificadas, 90, 260, 40, 20, "")
StringGadget(#aus_justificadas, 90, 290, 40, 20, "")
TextGadget(#PB_Any, 10, 320, 80, 25, "Tardanzas: ")
StringGadget(#tardanzas, 90, 320, 40, 20, "")
StringGadget(#total_ausencias, 180, 270, 40, 20, "")
StringGadget(#tel_contacto, 120, 380, 100, 20, "")
TextGadget(#PB_Any, 410, 40, 70, 20, "Buscar", #PB_Text_Right)
StringGadget(#texto_busqueda, 490, 40, 100, 20, "")
TextGadget(#PB_Any, 10, 230, 80, 25, "Asistencia:")
TextGadget(#PB_Any, 10, 260, 80, 25, "Aus Injust:")
TextGadget(#PB_Any, 10, 290, 80, 25, "Aus Justif:")
TextGadget(#PB_Any, 140, 270, 40, 25, "Total: ")
ComboBoxGadget(#combo_materias, 470, 120, 130, 20)
StringGadget(#nota_lengua, 420, 170, 60, 20, "")
StringGadget(#nota_matematica, 420, 200, 60, 20, "")
StringGadget(#nota_ingles, 420, 230, 60, 20, "")
StringGadget(#nota_naturales, 420, 260, 60, 20, "")
StringGadget(#nota_sociales, 420, 290, 60, 20, "")
StringGadget(#nota_fisica, 420, 320, 60, 20, "")
TextGadget(#PB_Any, 10, 350, 150, 25, "Informacion importante:")
TextGadget(#PB_Any, 10, 380, 110, 25, "Telefono contacto:")
TextGadget(#PB_Any, 330, 90, 220, 25, "Informacion academica:", #PB_Text_Center)
TextGadget(#PB_Any, 340, 120, 120, 20, "Etapa:", #PB_Text_Center)
TextGadget(#PB_Any, 300, 200, 120, 20, "Matematica", #PB_Text_Center)
TextGadget(#PB_Any, 300, 170, 120, 20, "Lengua", #PB_Text_Center)
TextGadget(#PB_Any, 300, 230, 120, 20, "Ingles", #PB_Text_Center)
TextGadget(#PB_Any, 300, 290, 120, 20, "Cs Sociales", #PB_Text_Center)
TextGadget(#PB_Any, 300, 260, 120, 20, "Cs Naturales", #PB_Text_Center)
TextGadget(#PB_Any, 300, 320, 120, 20, "Ed Fisica", #PB_Text_Center)
ButtonGadget(#boton_guardar, 380, 370, 120, 25, "Guardar cambios")

Leer_archivo()

For i=0 To ArraySize(Etapas$())
  AddGadgetItem(#combo_materias,-1 , Etapas$(i))
Next

Agregar_a_combobox()
SetGadgetState(#combo_alumnos,0)
id=Mid(GetGadgetText(#combo_alumnos),0,8)
SetGadgetState(#combo_materias,0)
num_etapa=Val(Mid(GetGadgetText(#combo_materias),0,1))-1 
desactivarCampos(1)
actualizarPantalla()
obtener_promedios()
actualizar_materias()

Repeat
  
  event.l= WindowEvent()
  
  Select Event
      
    Case #PB_Event_Menu
      Select EventMenu()
        Case #menuIngreso
          desactivarCampos(0)
          
        Case #menuConsulta
          desactivarCampos(1)
          
        Case #menuAgregar
          id=Agregar_estudiante()
          estudiantes(id)\dni=id
          ;Debug id
          If id<>""
            MessageRequester("Correcto","Se agrego un nuevo estudiante con DNI " + id, #PB_MessageRequester_Ok)
            AddMapElement(estudiantes(),id)
            estudiantes(id)\dni=id
            Agregar_a_combobox()
            actualizarPantalla()
            desactivarCampos(0)
          Else
            MessageRequester("Error","No ingresaste ningun dni", #PB_MessageRequester_Error)
          EndIf 
          Agregar_a_combobox()
          
      EndSelect
    Case  #PB_Event_Gadget
      Select EventGadget()
        Case #combo_alumnos
          SetGadgetState(#combo_materias,0)
          num_etapa=Val(Mid(GetGadgetText(#combo_materias),0,1))-1 
          id=Mid(GetGadgetText(#combo_alumnos),0,8)
          actualizarPantalla()
          actualizar_materias()
          
        Case #combo_materias
          num_etapa=Val(Mid(GetGadgetText(#combo_materias),0,1))-1      ;Con esta linea obtenemos la posicion del array Etapas$ para usarlo con el array de las materias
          ;Debug num_etapa
          actualizar_materias()
          
        Case #boton_guardar
          If validacionDatos()
            obtener_datos()
            MessageRequester("Exito","Datos grabados correctamente",#PB_MessageRequester_Ok)
            Agregar_a_combobox()
            actualizarPantalla()
            actualizar_materias()
            desactivarCampos(1)
            GuardarArchivo()
          EndIf 
          
      EndSelect
  EndSelect
  
  
Until Event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 453
; FirstLine = 220
; Folding = AD+
; EnableXP