/* 1. Los usuarios que han recibido permisos para crear tablas, pueden crear tablas en los 
esquemas de su propiedad.  V */

Create login Test with password = '12345';
Create user Test for login Test;

Create schema TestSchema authorization Test;

Grant create table to Test;
Revoke create table to Test;

----Ejecutar en login Test

Use Northwind
go
Create table TestSchema.Tabla(
   ID INT PRIMARY KEY,
   Name VARCHAR(50)
);

select * from TestSchema.Tabla

-------------------------------------------------------------------------------
/* 2. Los usuarios al ser creados tienen por defecto el rol public.  V */

EXEC sp_helpsrvrolemember

-------------------------------------------------------------------------------
/* 3. Se pueden asignar permisos al rol de base de datos public.  V */

Grant Select to public;

-------------------------------------------------------------------------------
/* 4. Los usuarios con With grant Option no pueden heredar permisos a usuarios con rol 
db_datareader.  F */

sp_addrolemember db_datareader, Test
sp_droprolemember db_datareader, Test

sp_helprotect null, Test

Create login UserNorthwind
with password = 'uni2023'
go
Create user UserNorthwind
from login UserNorthwind

drop user UserNorthwind

Grant Select on Categories to UserNorthwind
with grant option

sp_helplogins Test

---Ejecutar en login UserNorthwind

use Northwind
go
Grant select on Categories to Test

-------------------------------------------------------------------------------
/* 5. Un inicio de sesión puede tener más de un usuario siempre y cuando tenga un 
nombre.distino en la misma base de datos. F */

/*  Cada inicio de sesión en SQL Server se identifica de manera única por su nombre de inicio de sesión, 
y cada usuario en una base de datos se identifica de manera única por su nombre de usuario. 
Por lo tanto, un inicio de sesión puede estar asociado con múltiples bases de datos, pero en cada base de datos, 
solo puede haber un usuario con el mismo nombre de usuario. */

-------------------------------------------------------------------------------
/* 6. El rol de Servidor Datawriter solo permite permisos de escritura y actualizado.  F */

use Northwind
go
sp_addrolemember db_datawriter, Test
sp_droprolemember db_datawriter, Test

--Ejecutar en login Test

Use Northwind

Insert into Region values (5, 'Asia')

-------------------------------------------------------------------------------
/* 7. Un esquema puede tener más de un propietario.  F */

SELECT s.name AS schema_name, u.name AS owner_name
FROM sys.schemas s
INNER JOIN sys.database_principals u ON u.principal_id = s.principal_id
ORDER BY schema_name;

-------------------------------------------------------------------------------
/* 8. Se puede borrar un usuario cuando no propietario de un esquema.  V */

Drop user Test --Aquí es dueño de un esquema

Alter Authorization on Schema:: TestSchema to UserNorthwind ---Le cambiamos el propietario del esquema

Drop user Test --Y ahora sí podemos borrarlo

-------------------------------------------------------------------------------
/* 9. El rol de BD db_BackupOperator no permite realizar backup del log de transacciones. F */

sp_addrolemember db_BackupOperator, Test
sp_droprolemember db_BackupOperator, Test

sp_helplogins Test

--Ejecutar en login Test

Backup log Northwind
to disk = 'D:\Prueba\NorthwindRespaldo.bak'

  -------------------------------------------------------------------------------
  /* 10. El rol db_ddladmin permite le permite al usuario crear vistas con objetos a los que no 
tiene permiso de acceso.  V */

sp_addrolemember db_ddladmin, UserNorthwind
sp_droprolemember db_ddladmin, UserNorthwind

sp_helplogins UserNorthwind

-- Ejecutar en login UserNorthwind
Create view dbo.RecuperarCustomers
as
Select * from Customers

-------------------------------------------------------------------------------
/* 11.  El rol db_owner no puede crear backup de la base de datos. V */

sp_addrolemember db_owner, Test
sp_droprolemember db_owner, Test

-- Ejecutar en login Test
Use Northwind
go
Backup database Northwind
to disk = 'D:\Prueba\Northwind.bak'
with 
name = 'Respaldo Full 1', 
Description = 'Respaldo de archivos primarios y secundarios'

-------------------------------------------------------------------------------
/* 12.  Para borrar los permisos de un usuario que ha heredado a otros usuarios se utiliza 
CASCADE. V */

Grant select on Categories to UserNorthwind
with grant option

Revoke select on Categories to UserNorthwind CASCADE

-------------------------------------------------------------------------------
/* 13. Se puede denegar el permiso de selección a un objeto que es propiedad del usuario.  V */

sp_addrolemember db_datareader, Test
sp_droprolemember db_datareader, Test

Deny select on Region to Test

--Ejecutar en login de Test

select * from Region

-------------------------------------------------------------------------------
/* 14. Db_SecurityAdmin puede denegar y conceder accesos a todos los usuarios de la base de 
datos.  V */

sp_addrolemember db_SecurityAdmin, Test
sp_droprolemember db_SecurityAdmin, Test

--Ejecutar en login Test

Grant create any database to UserNorthwind
Revoke create any database to UserNorthwind

-------------------------------------------------------------------------------
/* 15. Cuando se agrega un objeto a un esquema que es propiedad del usuario, este podrá 
borrarlo o modificarlo.  V */

sp_addrolemember db_datawriter, UserNorthwind
sp_droprolemember db_datawriter, UserNorthwind

--- Ejecutar en login UserNorthwind
Insert into TestSchema.Tabla values (1, 'Leandro')

select * from TestSchema.Tabla

Delete from TestSchema.Tabla

-------------------------------------------------------------------------------
/* 16. Db_Securityadmin puede crear usuarios y asignarlos a cuentas de acceso. V */

sp_addrolemember db_SecurityAdmin, 
sp_droprolemember db_SecurityAdmin, Test

Create database Test
sp_changedbowner Test

--Ejecutar en login Test
Create login TestLogin with Password = '1234567'
go
Create user TestUser for login TestLogin
go
Exec sp_addrolemember db_datareader, TestUser
Exec sp_droprolemember db_datareader, TestUser
go
Exec sp_addrolemember db_datawriter, TestUser
Exec sp_droprolemember db_datawriter, TestUser

-------------------------------------------------------------------------------
/* 17. Pueden existir usuarios sin login. F */

/* No, en Microsoft SQL Server no pueden existir usuarios sin login. 
Los usuarios son creados en el contexto de un login y se les asignan permisos para acceder a objetos en una base de datos. 
Si se intenta crear un usuario sin especificar un login existente, se producirá un error. */

-------------------------------------------------------------------------------
/* 18. SetupAdmin permite administrar SQL Server Agent. F */

/* No es del todo correcto. El rol de servidor "setupadmin" permite al usuario realizar tareas de instalación y configuración de SQL Server, 
pero no tiene permisos para administrar SQL Server Agent directamente.

Para administrar SQL Server Agent, se requiere el rol de servidor "sysadmin" o el rol de base de datos 
"SQLAgentOperatorRole" en la base de datos msdb. */

USE msdb;
GO
EXEC sp_addrolemember SQLAgentOperatorRole, TestLogin
GO

-------------------------------------------------------------------------------
/*  19. Securityadmin puede ingresar a todas las bases de datos.  F*/

sp_addrolemember db_SecurityAdmin, Test
sp_droprolemember db_SecurityAdmin, Test

--Ejecutar en login Test
Use Northwind
go
Select * from dbo.Region

-------------------------------------------------------------------------------
/* 20. Securityadmin puede borrar esquemas y crear nuevos esquemas. V */

sp_addrolemember db_SecurityAdmin, Test
sp_droprolemember db_SecurityAdmin, Test

Alter Authorization on Schema:: TestSchema to Test

--Ejecutar en login Test
DROP SCHEMA TestSchema
Drop table TestSchema.Tabla

-------------------------------------------------------------------------------
/* 21. Securityadmin puede cambiar los permisos de propiedad de un esquema (Transferirlos). F */

sp_addrolemember db_SecurityAdmin, Test
sp_droprolemember db_SecurityAdmin, Test

Create schema TestSchema authorization Test;

--- Ejecutar en Test

Alter Authorization on Schema:: TestSchema to UserNorthwind

-------------------------------------------------------------------------------
/* 22. Bulkadmin puede administrar la función Bulk Insert. V */

BULK INSERT myTable
FROM 'C:\myFile.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');

-------------------------------------------------------------------------------
/* 23. Al revocarle los permisos de un usuario no se revokan los heredados. F*/

/*Esta afirmación es falsa. Al revocarle los permisos a un usuario, los permisos que hayan sido heredados también serán revocados.

Por ejemplo, si un usuario A tiene permisos a una tabla y se le han otorgado permisos a otro usuario B para acceder a esa misma tabla, 
al revocarle los permisos a A, B también perderá los permisos para acceder a la tabla.*/

-------------------------------------------------------------------------------
/* 24. db_owner puede administrar dispositivos de almacenamiento sp_addumpdevice. V */

SELECT name, SUSER_SNAME(owner_sid) AS database_owner
FROM sys.databases
WHERE name = 'Northwind'

USE Northwind;
EXEC sp_addumpdevice 'disk', 'MyBackupDevice', 'D:\Prueba\Northwind.bak'