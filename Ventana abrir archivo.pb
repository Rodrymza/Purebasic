;La funcion OpenfileRequester devuelve la ruta del archivo que se selecciona mediante una ventana de buscar archivos
;Los parametros que se usan en la funcion son
;1 Titulo de la Ventana
;2 Tipos de archivos soportados separados por |: tipo de archivo | *.jpg | tipo de archivo | *.png
;3 tipo de archivo activo al abrir la ventana, utilizando un numero empezando dessde 0
OpenFileRequester("Busque archivo","","Archivo jpg (*.jpg) | *.jpg| Aplicaciones (*.exe)| *.exe | Archivos Purebasic | *.pb",1)
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 5
; EnableXP
; HideErrorLog