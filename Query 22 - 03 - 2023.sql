

use Northwind
go
Select  from Customers

Select * from Customers c
iner join 
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