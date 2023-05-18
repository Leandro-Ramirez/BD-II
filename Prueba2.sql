--Restaurar bases en ordenes, recordar que el no recovery es cuando aun no se va a hacer el backupcompleto

RESTORE DATABASE AdventureWorks  
   FROM AdventureWorksBackups  
   WITH FILE=3, NORECOVERY;  
  
RESTORE LOG AdventureWorks  
   FROM AdventureWorksBackups  
   WITH FILE=4, NORECOVERY, STOPAT = 'Apr 15, 2020 12:00 AM';  
  
RESTORE LOG AdventureWorks  
   FROM AdventureWorksBackups  
   WITH FILE=5, NORECOVERY, STOPAT = 'Apr 15, 2020 12:00 AM';  
RESTORE DATABASE AdventureWorks WITH RECOVERY;   
GO  


--28/03/23---------------------

use Northwind

go

select e.EmployeeID, e.FirstName, et.TerritoryID, t.TerritoryDescription, r.RegionDescription
from EmployeeTerritories et
inner join Employees e on e.EmployeeID = et.EmployeeID
inner join Territories t on t.TerritoryID = et.TerritoryID
inner join Region r on r.RegionID= t.RegionID


select distinct  r.RegionDescription,round(SUM((od.Quantity * od.UnitPrice) * (1-od.Discount)),2) as Total
from EmployeeTerritories et
inner join Employees e on e.EmployeeID = et.EmployeeID
inner join Territories t on t.TerritoryID = et.TerritoryID
inner join Region r on r.RegionID= t.RegionID
inner join Orders o on e.EmployeeID= o.EmployeeID
inner Join [Order Details] od on o.OrderID= od.OrderID
group by r.RegionDescription 
order by r.RegionDescription

select
round(sum((od.Quantity * od.UnitPrice) * (1-od.Discount)),2)
from [Order Details] od


select A.RegionDescription,SUM(Recaudación) as Recaudación from
(select distinct e.EmployeeID, r.RegionDescription
from EmployeeTerritories et
inner join Employees e on e.EmployeeID = et.EmployeeID
inner join Territories t on t.TerritoryID = et.TerritoryID
inner join Region r on r.RegionID= t.RegionID) A

inner join

(select o.EmployeeID, round(sum((od.Quantity * od.UnitPrice) * (1-od.Discount)),2) as  Recaudación
from [Order Details] od
inner join orders o on o.OrderID= od.OrderID
inner join Employees e on  e.EmployeeID =o.EmployeeID
group by o.EmployeeID
)B
 
 on B.EmployeeID = A.EmployeeID
 group by A.RegionDescription


Select * from Region
-- Creando Mensaje personalizado del Sistema de BD
sP_addmessage 50002,1, 'El registro con ID:%d, ha sido eliminado por el usuario: %s',
                        'us_english', 'true'

-- Creación de Procedimientos Almacenados Insertar / Delete

Create procedure Insertar_Region
@RegionID int,
@NombreRegion varchar(60)
as
Insert into Region values(@RegionID, @NombreRegion)

-----------------------------------------------------------
Create procedure Eliminar_Region
@RegionID int
as
Declare @Usuario varchar(50)
set @Usuario = SUSER_SNAME()
Delete from Region where RegionID = @RegionID
-- Ejecutamos el mensaje 
Raiserror(50002, 1,1, @RegionID, @Usuario)

Execute Insertar_Region 5, 'Centro América'

Execute Eliminar_Region 5

Create login SistemaNorthwind
with password = 'sistemas2023'
go
sp_adduser SistemaNorthwind, SistemaNorthwind
go
Grant Execute on Insertar_Region to SistemaNorthwind

Grant Execute on Eliminar_Region to SistemaNorthwind

------Respaldos codigo---------------------------


-- Visualizar los archivos .bak

Restore headeronly from disk = 
'D:\Base de Datos\Respaldos\Northwind.bak'

-- Visualizar los archivos de BD del respaldo

Restore Filelistonly from disk = 
'D:\Base de Datos\Respaldos\Northwind.bak'

-- Restauración de la BD Northwind

Restore database Northwind
from disk = 'D:\Base de Datos\Respaldos\Northwind.bak'
with 
move 'Northwind' to 'D:\Base de Datos\Archivos de Base de Datos\MDF\northwnd.mdf',
move 'Northwind_1' to 'D:\Base de Datos\Archivos de Base de Datos\NDF\Northwind_1.ndf',
move  'Northwind_2'  to 'D:\Base de Datos\Archivos de Base de Datos\NDF\Northwind_2.ndf',
move  'Northwind_log' to 'D:\Base de Datos\Archivos de Base de Datos\LDF\northwnd.ldf'

-- Backup Full de Base de Datos Northwind

Backup database Northwind
to disk  = 'D:\Base de Datos\Respaldos\NorthwindRespaldo.bak'

Restore filelistonly from disk = 'D:\Base de Datos\Respaldos\NorthwindRespaldo.bak'

Use Master
go
Drop database Northwind

Restore database Northwind
from disk = 'D:\Base de Datos\Respaldos\NorthwindRespaldo.bak'
-- Visualizando información de archivos de BD
sp_helpdb Northwind

-- Separación y vinculación de Base de Datos Northwind
use Master
go
sp_detach_db Northwind

sp_attach_db Northwind,
'D:\Base de Datos\Archivos de Base de Datos\Archivos Northwind\MDF\northwnd.mdf',
'D:\Base de Datos\Archivos de Base de Datos\Archivos Northwind\NDF\Northwind_1.ndf',
'D:\Base de Datos\Archivos de Base de Datos\Archivos Northwind\NDF\Northwind_2.ndf',
'D:\Base de Datos\Archivos de Base de Datos\Archivos Northwind\LDF\northwnd.ldf'

Restore database Northwind
from disk = 'D:\Base de Datos\Respaldos\NorthwindRespaldo.bak'
with 
move 'Northwind' to 'D:\Base de Datos\Archivos de Base de Datos\Archivos Northwind\MDF\northwnd.mdf',
move 'Northwind_1' to 'D:\Base de Datos\Archivos de Base de Datos\Archivos Northwind\NDF\Northwind_1.ndf',
move  'Northwind_2'  to 'D:\Base de Datos\Archivos de Base de Datos\Archivos Northwind\NDF\Northwind_2.ndf',
move  'Northwind_log' to 'D:\Base de Datos\Archivos de Base de Datos\Archivos Northwind\LDF\northwnd.ldf'

Use Northwind
go
Select * from Region

--Respaldo Full de Base de Datos Northwind

Backup database Northwind
to disk = 'D:\Base de Datos\Respaldos\NorthwindRespaldo.bak'

-- Respaldo Diferencial de Base de Datos Northwind
Backup database Northwind
to disk = 'D:\Base de Datos\Respaldos\NorthwindRespaldo.bak'
With
Differential

-- Respaldo del Registro de Transacciones
Insert into Region values (5, 'América Central')
Backup log Northwind
to disk = 'D:\Base de Datos\Respaldos\NorthwindRespaldo.bak'

-----------------------------------------------
Insert into Region values (6, 'América del Sur')
Backup log Northwind
to disk = 'D:\Base de Datos\Respaldos\NorthwindRespaldo.bak'
----------------------------------------------------------------
Insert into Region values (7, 'América del Norte')
Backup log Northwind
to disk = 'D:\Base de Datos\Respaldos\NorthwindRespaldo.bak'

Restore Headeronly
from disk = 'D:\Base de Datos\Respaldos\NorthwindRespaldo.bak'

----------------------------------------------------------------------
insert into Region values (8, 'Este')
Backup log Northwind
to disk = 'D:\Base de Datos\Respaldos\NorthwindRespaldoLog.bak'

--------------------------------------------------
insert into Region values (9, 'Norte')
Backup log Northwind
to disk = 'D:\Base de Datos\Respaldos\NorthwindRespaldo.bak'

----------- Restauración de la Base de Datos Northwind
Restore headeronly from disk = 
'D:\Base de Datos\Respaldos\NorthwindRespaldo.bak'

Restore Database Northwind
from Northwind_Backup
with file = 8,
recovery

use Northwind
go
Select * from Region


-- Creación de Dispositivo de Almacenamiento para Respaldos y Restauración de BD

sp_addumpdevice 'Disk', 'Northwind_Backup','D:\Base de Datos\Respaldos\NorthwindRespaldo.bak'

sp_helpdevice 

sp_dropdevice Respaldo_Northwind

Backup database Northwind
to Northwind_Backup 
with Differential

Backup log Northwind
to Northwind_Backup 


-- Modelo de Recuperación: Full -- Simple -- Registro Masivo
Alter database Northwind
set Recovery Simple

Alter database Northwind
set Recovery Full


-----------23/03/23------------------

-- Tabla Recaudación
--------------------------------------------
Insert into  BDRepositorio.dbo.Recaudacion
Select 
      cast(Getdate() as Date) as Fecha,
	  'Northwind' as BD,
	  (Select distinct year(Orderdate) from orders where year(Orderdate) = year(getdate()) and month(Orderdate) = month(getdate())) as Año,
	  (Select distinct month(Orderdate) from orders where year(Orderdate) = year(getdate()) and month(Orderdate) = month(getdate())) as Mes,

	  round(sum(od.UnitPrice * od.Quantity ),2) as Monto,
	  round(sum(od.UnitPrice * od.Quantity * od.Discount ),2) as Descuento,
	  round(sum((od.UnitPrice * od.Quantity) * (1 - od.Discount )),2) as MontoTotal,
	  count(distinct o.orderID) as CantidadOrdenes
from [Order Details] od
inner join Orders o on od.OrderID = o.OrderID
where 
year(Orderdate) = year(getdate())
and
month(Orderdate) = month(getdate())
go

------  Tabla Detalle de la Recaudación------------------------------------------------------------------------------

Insert into  BDRepositorio.dbo.Detalle_Recaudacion
Select 
      (Select IdRecaudacion from  BDRepositorio.dbo.Recaudacion
       where year(Fecha) = year(getdate()) and month(Fecha) = month(getdate())) as IdRecaudación,
	  o.EmployeeID,
	  round(sum(od.UnitPrice * od.Quantity ),2) as Monto,
	  round(sum(od.UnitPrice * od.Quantity * od.Discount ),2) as Descuento,
	  round(sum((od.UnitPrice * od.Quantity) * (1 - od.Discount )),2) as MontoTotal,
	  count(distinct o.orderID) as CantidadOrdenes
from [Order Details] od
inner join Orders o on od.OrderID = o.OrderID
where 
year(Orderdate) = year(getdate())
and
month(Orderdate) = month(getdate())
Group by 
 o.EmployeeID
  
 go





Delete from  BDRepositorio.dbo.Recaudacion
Delete from BDRepositorio.dbo.Detalle_Recaudacion

Declare @Dato int
Select @Dato
Select @@IDENTITY


---------------22/03/23------------------


use Northwind
go
Select  from Customers

Select * from Customers c
inner join 
Orders o on o.CustomerID = c.CustomerID

sP_altermessage 156, 'with_log', 'False'
sP_altermessage 102, 'with_log', 'False'

---------------------------------------------------------------
-- Factura
Alter procedure Factura_Northwind_Reporte @OrderID int, @Correo varchar(100)
as
if exists (Select * from Orders where OrderID = @OrderID)
begin
Select  
    o.OrderID,
	cast(Orderdate as Date) as Fecha_Orden,
	c.CompanyName as [Nombre Empresa],
	'Ms/Mr '+e.FirstName + ' '+e.LastName as [Vendedor],
	s.CompanyName as 'Empresa de Envío'
	
from Orders o
inner join Customers c on c.CustomerID = o.CustomerID
inner join Employees e on e.EmployeeID = o.EmployeeID
inner join Shippers s on s.ShipperID = o.ShipVia

where o.orderID = @OrderID
---------------------------------------------------------------------
Select 
      p.ProductName as [Nombre Producto],
	  od.UnitPrice as Precio,
	  od.Quantity as Cantidad,
	  od.Discount as Descuento,
	  round((od.UnitPrice * od.Quantity) * (1 - od.Discount ),2) as Subtotal
from [Order Details] od
     inner join Products p on p.ProductID = od.ProductID
where od.OrderID = @OrderID
--------------------------------------------------------------------------
Select 
 
	  round(sum((od.UnitPrice * od.Quantity) * (1 - od.Discount )),2) as SubTotalProductos,
	  (Select o.Freight from Orders o where o.orderID = @OrderID) as 'Costo X Envío',
	  ((round(sum((od.UnitPrice * od.Quantity) * (1 - od.Discount )),2))
	   + (Select o.Freight from Orders o where o.orderID = @OrderID))*1.15 as [Total (IVA15%)]
from [Order Details] od
     inner join Products p on p.ProductID = od.ProductID
where od.OrderID = @OrderID
end
else
Begin
Print 'La orden ingresada no existe en el sistema de BD Northwind'
End

Exec Northwind.dbo. Factura_Northwind_Reporte
10249, 'null'



Select * from Orders
year(Orderdate) = 2023
and
month(Orderdate) = 
update Orders set Orderdate = getdate()
where 
year(Orderdate) = 2018
and
month(Orderdate) = 5


--------------------------------------------
Select 
      cast(Getdate() as Date) as Fecha,
	  (Select distinct year(Orderdate) from orders where year(Orderdate) = year(getdate()) and month(Orderdate) = month(getdate())) as Año,
	  (Select distinct month(Orderdate) from orders where year(Orderdate) = year(getdate()) and month(Orderdate) = month(getdate())) as Mes,

	  round(sum(od.UnitPrice * od.Quantity ),2) as Monto,
	  round(sum(od.UnitPrice * od.Quantity * od.Discount ),2) as Descuento,
	  round(sum((od.UnitPrice * od.Quantity) * (1 - od.Discount )),2) as MontoTotal,
	  count(distinct o.orderID) as CantidadOrdenes
from [Order Details] od
--into BDRepositorio.dbo.Recaudacion
inner join Orders o on od.OrderID = o.OrderID
where 
year(Orderdate) = year(getdate())
and
month(Orderdate) = month(getdate())

Select distinct year(Orderdate) from orders where year(Orderdate) = year(getdate()) and month(Orderdate) = month(getdate())
