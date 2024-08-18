;convertir una cantidad de minutos a horas y minutos

OpenConsole()
EnableGraphicalConsole(1)

Define.l horas,minutos,miningresados

PrintN("Ingrese el valor en minutos")
miningresados=Val(Input())

horas=miningresados/60
minutos=miningresados%60
PrintN( Str(miningresados) + "corresponden a ")
PrintN( Str(horas) + " horas  y " + minutos + "  minutos")
Input()
; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; EnableXP