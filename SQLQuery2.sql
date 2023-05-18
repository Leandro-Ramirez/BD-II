Create database BDRepositorio

use BDRepositorio

Create table Recaudaciones(
IdRecaudacion int primary key,
Fecha date,
Año int,
Mes int,
Monto float,
Descuento float,
MontoFinal float,
CantidadOrdenes int
)



Create table DetalleRecaudaciones(
IdRecaudacion int foreign key Recuadaciones(IdRecaudacion),
IdEmpleado int foreign key Empleado (IdEmpleado)

)

sp_altermessage 156, 'with_log', 'True'


