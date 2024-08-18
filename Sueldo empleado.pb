;Un vendedor recibe un sueldo base mas un 10% extra por comisión de sus ventas, el vendedor desea saber cuanto dinero obtendrá por
; concepto de comisiones por las tres ventas que realiza en el mes y el total que recibirá en el mes tomando en cuenta su sueldo base y comisiones.

OpenConsole()
EnableGraphicalConsole(1)
Define.f sueldobase=1500, cont=0 ,venta,totalventas,sueldototal

Repeat
  ClearConsole()
  cont=cont+1
  PrintN("Ingrese el monto de la venta " + cont)
  venta=Val(Input())
  
  totalventas=totalventas+venta
  ;Debug "Totalventas " + totalventas
  
  
;   Debug "contador " + cont
Until cont=3

comision=totalventas*0.1
sueldototal=sueldobase+comision

;Debug "comision " + comision
ConsoleLocate(0,15)
PrintN("El total a percibir del empleado es de " + sueldototal)
;Debug "monto a percibir " + sueldototal
Delay(2000)
Input()
; IDE Options = PureBasic 5.70 LTS (Windows - x64)
; CursorPosition = 20
; EnableXP