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
Alter procedure Eliminar_Region
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



