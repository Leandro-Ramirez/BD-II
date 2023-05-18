--- Ejercicio 1
Restore Filelistonly 
from disk = 'D:\Backup_DATABASES.bak'

restore headeronly
from disk = 'D:\Backup_DATABASES.bak'

Restore database Neptuno
from disk = 'D:\Backup_DATABASES.bak'
with 
move 'Neptuno_DATA' to 'D:\Base de Datos\Archivos Neptuno\MDF\Neptuno.mdf',
move 'Extension_I' to 'D:\Base de Datos\Archivos Neptuno\NDF\Neptuno_1.ndf',
move 'Extensión_II'  to 'D:\Base de Datos\Archivos Neptuno\NDF\Neptuno_2.ndf',
move 'Neptuno_log' to 'D:\Base de Datos\Archivos Neptuno\LDF\Neptuno.ldf'

Backup database Neptuno
to disk = 'D:\Neptuno.bak'

--drop database Neptuno


Restore log Neptuno
from disk = 'D:\Neptuno.bak'
with file = 16,
recovery

--- Ejercicio 2

create procedure AlertaSistema
@PedidoID int
AS
BEGIN
	Declare @Usuario varchar(50)
	Declare @IDProducto int
	Declare @Cantidad int
	Declare @Subtotal varchar(50)

	SELECT	@IDProducto = D.idproducto,
			@Cantidad = D.cantidad,
			@Subtotal = SUM((D.cantidad*D.preciounidad))
	FROM detallesdepedidos AS D 
	WHERE idpedido = @PedidoID
	GROUP BY D.idproducto,D.cantidad

	SET @Usuario = SUSER_SNAME()

	Delete from detallesdepedidos where idpedido = @PedidoID

	DECLARE @BodyError NVARCHAR(MAX) = N''
	SET @BodyError =	'Pedido ID:'+CAST(@PedidoID AS varchar(50))+', 
						IDProducto:'+CAST(@IDProducto AS varchar(50))+',
						Cantidad: '+CAST(@Cantidad AS varchar(50))+',
						Subtotal:'+CAST(@Subtotal AS varchar(50))+',
						registro eliminado por el usuario:'+@Usuario;
               
	Raiserror(@BodyError,1,1)
END
 exec AlertaSistema 10256


 --- Falso verdadero
Create login Test with password = '12345';
Create user Test for login Test;

 --3.	El rol de base de datos db_owner puede generar respaldos y restauraciones de base de datos en las cuales es propietario.. Verdadero */
 grant create database to Test

sp_addrolemember db_owner, Test
sp_droprolemember db_owner, Test

Use TEST
go
Backup database TEST
to disk = 'D:\backup.bak'


--- 4.	 SecurityAdmin puede asignar roles de servidor a usuarios. Verdadero


sp_addrolemember db_SecurityAdmin, Test
sp_droprolemember db_SecurityAdmin, Test

Grant create any database to Test
Revoke create any database to Test

-- 5.	SecurityAdmin puede crear usuarios en bases de datos. Falso

create user Kevin from login Test
-- El Security admin solo gestionar los roles y permisos pero no puede crear






