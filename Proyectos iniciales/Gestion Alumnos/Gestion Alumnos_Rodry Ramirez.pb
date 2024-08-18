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
  #boton_agregar
  #combo_materias
  #menuAgregar
  #ventanaAgregarEstudiante
  #estudiante_agregado
  #archivoDatos
  #combo_curso
  #combo_selec_curso
  #menuayuda
  #ventana_ayuda
  #boton_ayuda
  #combo_filtrar_curso
  #boton_limpiar
  #boton_buscar
  #Carga_notas
EndEnumeration

;variables y estructuras
Structure datos
  dni.s
  apellido.s
  nombre.s
  nacimiento.s
  contacto.s
  curso.s
  Array lengua.f(3)
  Array matematica.f(3)
  Array ingles.f(3)
  Array naturales.f(3)
  Array sociales.f(3)
  Array fisica.f(3)
  justificadas.f
  injustificadas.f
  tardanzas.f
  totales.f
EndStructure

Global NewMap estudiantes.datos ()

Global id.s , Dim Etapas$(3), num_etapa.i, nombrefichero$="Alumnos.txt"
Etapas$(0) = "1 Primer trimestre" : Etapas$(1) = "2 Segundo trimestre" : Etapas$(2) = "3 Tercer trimestre" : Etapas$(3) = "4 Promedio Anual"
Global totalCursos.i=6, Dim Cursos$(totalCursos)
Cursos$(0)="1er Grado" : Cursos$(1)="2do Grado" : Cursos$(2)="3er Grado" : Cursos$(3)="4to Grado" : Cursos$(4) = "5to Grado" : Cursos$(5) = "6to Grado" : Cursos$(6) = "7mo Grado"

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

Procedure actualizar_materias()

  SetGadgetText(#nota_lengua,StrF(estudiantes(id)\lengua(num_etapa),2))
  SetGadgetText(#nota_matematica,StrF(estudiantes(id)\matematica(num_etapa),2))
  SetGadgetText(#nota_ingles,StrF(estudiantes(id)\ingles(num_etapa),2))
  SetGadgetText(#nota_sociales,StrF(estudiantes(id)\sociales(num_etapa),2))
  SetGadgetText(#nota_naturales,StrF(estudiantes(id)\naturales(num_etapa),2))
  SetGadgetText(#nota_fisica,StrF(estudiantes(id)\fisica(num_etapa),2))
  
EndProcedure

Procedure obtener_promedios()
  ForEach estudiantes()
    estudiantes()\lengua(3) = ((estudiantes()\lengua(0) + estudiantes()\lengua(1) + estudiantes()\lengua(2)) / 3)
    estudiantes()\matematica(3) = ((estudiantes()\matematica(0) + estudiantes()\matematica(1) + estudiantes()\matematica(2)) /3)
    estudiantes()\ingles(3) =  ((estudiantes()\ingles(0) + estudiantes()\ingles(1) + estudiantes()\ingles(2)) / 3)         
    estudiantes()\sociales(3) = ((estudiantes()\sociales(0) + estudiantes()\sociales(1) + estudiantes()\sociales(2)) / 3)
    estudiantes()\naturales(3) = ((estudiantes()\naturales(0) + estudiantes()\naturales(1) + estudiantes()\naturales(2)) / 3)
    estudiantes()\fisica(3) = ((estudiantes()\fisica(0) + estudiantes()\fisica(1) + estudiantes()\fisica(2)) / 3 )
  Next
EndProcedure

Procedure Agregar_a_combobox() 
  ClearGadgetItems(#combo_alumnos)
  ForEach estudiantes()
    If estudiantes()\dni<>""
      AddGadgetItem(#combo_alumnos,-1, MapKey(estudiantes()) + ", " + estudiantes()\apellido + ", " + estudiantes()\nombre)
    EndIf 
  Next
EndProcedure

Procedure actualizarPantalla()
  If MapSize(estudiantes())<>0
    SetGadgetText(#dni,id)
    SetGadgetText(#apellido ,estudiantes(id)\apellido)
    SetGadgetText(#Nombre ,estudiantes(id)\nombre)
    SetGadgetText(#Nacimiento ,estudiantes(id)\nacimiento)
    SetGadgetText(#aus_injustificadas ,Str(estudiantes(id)\injustificadas))
    SetGadgetText(#aus_justificadas ,Str(estudiantes(id)\justificadas))
    SetGadgetText(#tardanzas ,Str(estudiantes(id)\tardanzas))
    SetGadgetText(#total_ausencias ,StrF(estudiantes(id)\totales,2))
    SetGadgetText(#tel_contacto, estudiantes(id)\contacto)
    For i=0 To totalCursos
      SetGadgetState(#combo_curso,i)
      If GetGadgetText(#combo_curso)=estudiantes(id)\curso  
        Break 
      Else 
        SetGadgetState(#combo_curso,-1)
      EndIf 
    Next
    actualizar_materias()
    obtener_promedios()
    If num_etapa=3 : DisableGadget(#nota_fisica,1) : DisableGadget(#nota_ingles,1) : DisableGadget(#nota_lengua,1) : DisableGadget(#nota_matematica,1) : DisableGadget(#nota_naturales,1) : DisableGadget(#nota_sociales,1) : EndIf
  EndIf 
EndProcedure

Procedure desactivarCampos(valor)
  DisableGadget(#dni,valor) : DisableGadget(#Apellido,valor)
  DisableGadget(#Nombre,valor) : DisableGadget(#Nacimiento,valor)
  DisableGadget(#tel_contacto,valor) : DisableGadget(#combo_curso,valor)
  DisableGadget(#boton_guardar,valor)
EndProcedure

Procedure desactivarNotas(valor)
  If num_etapa=3
    valor=1         ;no permito cambiar los promedios, si esta en la parte de promedios anuales
  EndIf
  
  DisableGadget(#nota_lengua,valor) : DisableGadget(#nota_fisica,valor)
  DisableGadget(#nota_matematica,valor) : DisableGadget(#nota_ingles,valor)
  DisableGadget(#nota_naturales,valor) : DisableGadget(#nota_sociales,valor)
  DisableGadget(#boton_guardar,valor) :DisableGadget(#aus_injustificadas,valor)
  DisableGadget(#aus_justificadas,valor) : DisableGadget(#tardanzas,valor)
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

Procedure obtener_datos()
  estudiantes(id)\dni = GetGadgetText(#dni)
  estudiantes(id)\apellido = title(GetGadgetText(#Apellido))
  estudiantes(id)\nombre = title(GetGadgetText(#Nombre))
  estudiantes(id)\nacimiento = GetGadgetText(#Nacimiento)
  estudiantes(id)\contacto = GetGadgetText(#tel_contacto)
  estudiantes(id)\justificadas = ValF(GetGadgetText(#aus_injustificadas))
  estudiantes(id)\injustificadas = ValF(GetGadgetText(#aus_justificadas))
  estudiantes(id)\tardanzas = ValF(GetGadgetText(#tardanzas))
  estudiantes(id)\totales = estudiantes(id)\justificadas + estudiantes(id)\injustificadas + estudiantes(id)\tardanzas / 2
  estudiantes(id)\contacto = GetGadgetText(#tel_contacto)
  estudiantes(id)\curso = GetGadgetText(#combo_curso)
  estudiantes(id)\lengua(num_etapa) = ValF(GetGadgetText(#nota_lengua))
  estudiantes(id)\matematica(num_etapa) = ValF(GetGadgetText(#nota_matematica))
  estudiantes(id)\ingles(num_etapa) =  ValF(GetGadgetText(#nota_ingles))           ;error en obtencion notas
  estudiantes(id)\sociales(num_etapa) = ValF(GetGadgetText(#nota_sociales))
  estudiantes(id)\naturales(num_etapa) = ValF(GetGadgetText(#nota_naturales))
  estudiantes(id)\fisica(num_etapa) = ValF(GetGadgetText(#nota_fisica))
EndProcedure

Procedure GuardarArchivo()
  CreateFile(#archivoDatos,nombrefichero$)
  ForEach estudiantes()
    If estudiantes()\dni<>""
      texto$ = estudiantes()\dni + "," + estudiantes()\apellido + "," + estudiantes()\nombre + "," + estudiantes()\nacimiento + "," + estudiantes()\injustificadas + "," + estudiantes()\justificadas + "," + estudiantes()\tardanzas + "," + estudiantes()\totales + "," + estudiantes()\contacto + "," + estudiantes()\curso
      ;Debug "Texto a escribir hasta contactos " + texto$
      For i= 0 To 3
        aux$= StrF(estudiantes()\lengua(i),2) + "," + StrF(estudiantes()\matematica(i),2) + "," + StrF(estudiantes()\ingles(i),2) + "," + StrF(estudiantes()\naturales(i),2) + "," + StrF(estudiantes()\sociales(i),2) + "," + StrF(estudiantes()\fisica(i),2)
        ; Debug "aux " + aux$
        notas$ = notas$ + "," +  aux$
      Next
      ;Debug "notas quedan asi " + notas$
      texto$ = texto$  + notas$
      
      ;Debug "texto completo " + texto$
      WriteStringN(#archivoDatos,texto$)
      notas$=""
    EndIf 
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
      estudiantes(id)\injustificadas = ValF(StringField(linea$,5,","))
      estudiantes(id)\justificadas = ValF(StringField(linea$,6,","))
      estudiantes(id)\tardanzas = ValF(StringField(linea$,7,","))
      estudiantes(id)\totales = ValF(StringField(linea$,8,","))
      estudiantes(id)\contacto = StringField(linea$,9,",")
      estudiantes(id)\curso = StringField(linea$,10,",")
      n=11
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

Procedure ventana_ayuda() ;del menu de ayuda-acerca de
  
   
  OpenWindow(#ventana_ayuda, 0, 0, 310, 210, "", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
    TextGadget(#PB_Any, 30, 20, 160, 20, "Gestion de Alumnos v 0.1")
    TextGadget(#PB_Any, 30, 50, 160, 20, "Rodry Ramirez (c) 2024")
    TextGadget(#PB_Any, 30, 80, 160, 20, "rodrymza@gmail.com")
    TextGadget(#PB_Any, 30, 110, 190, 20, "Curso Programacion Profesional")
    TextGadget(#PB_Any, 30, 140, 190, 20, "Profesor: Ricardo Ponce")
    ButtonGadget(#boton_ayuda, 110, 170, 100, 25, "Aceptar")
    
    Repeat  
      event.l= WindowEvent()
      Select Event
        Case #PB_Event_CloseWindow
          CloseWindow(#ventana_ayuda)
        Case #PB_Event_Gadget
          Select EventGadget()
            Case #boton_ayuda
              quit=#True
              CloseWindow(#ventana_ayuda)
          EndSelect
      EndSelect
      
    Until event= #PB_Event_CloseWindow Or quit=#True
  
  EndProcedure
  
;Flags ventana
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered |  #PB_Window_SizeGadget


OpenWindow(#ventanaPrincipal, 0, 0, 610, 450, "Nombre de ventana",#FLAGS)

;Elementos de ventana (Gadgets y menus)
CreateMenu(#PB_Any, WindowID(#ventanaPrincipal))
MenuTitle("Archivo")
MenuItem(#menuConsulta, "Modo consulta")
MenuItem(#menuIngreso, "Editar Datos")
MenuItem(#Carga_notas,"Cargar Notas")
MenuItem(#menuAgregar, "Agregar Estudiante")
MenuTitle("Ayuda")
MenuItem(#menuayuda,"Acerca de")
TextGadget(#PB_Any, 140, 10, 270, 25, "Gestion de alumnos", #PB_Text_Center)
TextGadget(#PB_Any, 10, 40, 50, 20, "Curso:", #PB_Text_Right)
ComboBoxGadget(#combo_curso, 70, 40, 90, 20)
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
DisableGadget(#total_ausencias,1)
StringGadget(#tel_contacto, 120, 380, 100, 20, "")
ButtonGadget(#boton_buscar, 430, 40, 60, 20, "Buscar")
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
TextGadget(#PB_Any, 340, 120, 120, 20, "Periodo:", #PB_Text_Center)
TextGadget(#PB_Any, 300, 200, 120, 20, "Matematica", #PB_Text_Center)
TextGadget(#PB_Any, 300, 170, 120, 20, "Lengua", #PB_Text_Center)
TextGadget(#PB_Any, 300, 230, 120, 20, "Ingles", #PB_Text_Center)
TextGadget(#PB_Any, 300, 290, 120, 20, "Cs Sociales", #PB_Text_Center)
TextGadget(#PB_Any, 300, 260, 120, 20, "Cs Naturales", #PB_Text_Center)
TextGadget(#PB_Any, 300, 320, 120, 20, "Ed Fisica", #PB_Text_Center)
ButtonGadget(#boton_guardar, 380, 370, 120, 25, "Guardar cambios")
TextGadget(#PB_Any, 170, 70, 90, 20, "Filtrar por curso:")
ComboBoxGadget(#combo_filtrar_curso, 270, 69, 90, 20)
ButtonGadget(#boton_limpiar, 380, 69, 90, 20, "Limpiar filtro")

Leer_archivo()
For i=0 To ArraySize(Cursos$())
  AddGadgetItem(#combo_curso,-1,Cursos$(i))
  AddGadgetItem(#combo_filtrar_curso,-1,Cursos$(i)) ;agregar cursos al combobox de filtrar por curso y combo para editar curso
Next


For i=0 To ArraySize(Etapas$())
  AddGadgetItem(#combo_materias,-1 , Etapas$(i))    ;agregar etapas al combobox de periodos del año
Next

Agregar_a_combobox()
SetGadgetState(#combo_alumnos,0)
actualizarPantalla()
id=Mid(GetGadgetText(#combo_alumnos),0,8)
SetGadgetState(#combo_materias,0)
num_etapa=Val(Mid(GetGadgetText(#combo_materias),0,1))-1 
desactivarCampos(1)
desactivarNotas(1)
actualizarPantalla()
obtener_promedios()

;Debug MapSize(estudiantes()) 
Repeat
  
  event.l= WindowEvent()
  
  Select Event
      
    Case #PB_Event_Menu
      Select EventMenu()
        Case #menuIngreso
          MessageRequester("Atencion","Si va a modificar el DNI, recuerde reiniciar la app tras el proceso", #PB_MessageRequester_Info)
          If GetGadgetText(#dni)=""
            MessageRequester("Error","No hay ningun alumno seleccionado",#PB_MessageRequester_Error)
          Else
            SetGadgetState(#combo_materias,0)
            id=Mid(GetGadgetText(#combo_alumnos),0,8)
            num_etapa=0
            actualizarPantalla()
            desactivarNotas(1)
            desactivarCampos(0)
          EndIf 
        Case #menuConsulta
          SetGadgetState(#combo_materias,0)
          num_etapa=0
          id=Mid(GetGadgetText(#combo_alumnos),0,8)
          actualizar_materias()
          desactivarCampos(1)
          desactivarNotas(1)
          actualizarPantalla()
        Case #menuAgregar
          dni$=Agregar_estudiante()
          If Not validarInt(dni$) or Len(dni$)<>8
            MessageRequester("Error","DNI mal ingresado", #PB_MessageRequester_Error)
          Else
            ForEach estudiantes()
              If dni$=MapKey(estudiantes())
                cont.i=cont+1
              EndIf 
            Next
            
            If cont>=1
              MessageRequester("Error","Ya existe un alumno con el documento ingresado",#PB_MessageRequester_Error)
            Else
              id=dni$
              MessageRequester("Correcto","Se agrego un nuevo estudiante con DNI" + id, #PB_MessageRequester_Ok)
              AddMapElement(estudiantes(),id)
              estudiantes(id)\dni=id
              actualizarPantalla()
              Agregar_a_combobox()
              SetGadgetState(#combo_alumnos,-1)
              desactivarCampos(0)
            EndIf 
          EndIf  
          
        Case #menuayuda
          ventana_ayuda()
          
        Case #Carga_notas
          id=Mid(GetGadgetText(#combo_alumnos),0,8)
          num_etapa=Val(Mid(GetGadgetText(#combo_materias),0,1))-1
          desactivarCampos(1)
          desactivarNotas(0)
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
          actualizarPantalla()
          
        Case #boton_guardar
          If GetGadgetText(#DNI)=""
            MessageRequester("Error","No hay un alumno seleccionado",#PB_MessageRequester_Error)
          Else
            If validacionDatos()
              obtener_datos()
              MessageRequester("Exito","Datos grabados correctamente",#PB_MessageRequester_Ok)
              Agregar_a_combobox()
              actualizarPantalla()
              actualizar_materias()
              GuardarArchivo()
            EndIf 
            For i=0 To CountGadgetItems(#combo_alumnos)
              SetGadgetState(#combo_alumnos,i)
              If Mid(GetGadgetText(#combo_alumnos),0,8)=GetGadgetText(#DNI) ;dejamos el combobox activado en el alumno que esta
                Break 
              EndIf
            Next
          EndIf 
          
        Case #combo_filtrar_curso
          ClearGadgetItems(#combo_alumnos)
          ForEach estudiantes()
            If GetGadgetText(#combo_filtrar_curso)=estudiantes()\curso
              AddGadgetItem(#combo_alumnos,-1, MapKey(estudiantes()) + ", " + estudiantes()\apellido + ", " + estudiantes()\nombre)
            EndIf
          Next
          SetGadgetState(#combo_alumnos,0)
          id=Mid(GetGadgetText(#combo_alumnos),0,8)
          actualizarPantalla()
        Case #boton_limpiar
          Agregar_a_combobox()
          SetGadgetState(#combo_alumnos,0)
          id=Mid(GetGadgetText(#combo_alumnos),0,8)
          actualizarPantalla()
        Case #boton_buscar
          ClearGadgetItems(#combo_alumnos)
          ForEach estudiantes()
            If estudiantes()\dni=GetGadgetText(#texto_busqueda) Or LCase(estudiantes()\apellido)=LCase(GetGadgetText(#texto_busqueda)) Or LCase(estudiantes()\nombre)=LCase(GetGadgetText(#texto_busqueda))
              AddGadgetItem(#combo_alumnos,-1, MapKey(estudiantes()) + ", " + estudiantes()\apellido + ", " + estudiantes()\nombre)
            EndIf
          Next
          SetGadgetState(#combo_alumnos,0)
          id=Mid(GetGadgetText(#combo_alumnos),0,8)
          actualizarPantalla()
          
          Case #nota_fisica : If GetGadgetText(#nota_fisica)="0.00" : SetGadgetText(#nota_fisica,"") : EndIf
          Case #nota_sociales : If GetGadgetText(#nota_sociales)="0.00" : SetGadgetText(#nota_sociales,"") : EndIf
          Case #nota_naturales : If GetGadgetText(#nota_naturales)="0.00" : SetGadgetText(#nota_naturales,"") : EndIf
          Case #nota_ingles : If GetGadgetText(#nota_ingles)="0.00" : SetGadgetText(#nota_ingles,"") : EndIf
          Case #nota_matematica : If GetGadgetText(#nota_matematica)="0.00" : SetGadgetText(#nota_matematica,"") : EndIf
          Case #nota_lengua : If GetGadgetText(#nota_lengua)="0.00" : SetGadgetText(#nota_lengua,"") : EndIf
          
      EndSelect
      
  EndSelect
  
Until Event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 496
; FirstLine = 280
; Folding = BB7
; EnableXP