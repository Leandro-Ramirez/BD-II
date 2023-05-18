use Model
go
create table Estudiantes (IdEstudiante int)
create database Universidad

exec msdb.[dbo].[sp_send_dbmail]
@profile_name = 'Administrador de Base de Datos',
@recipients = 'jasseromero@outlook.com',
@copy_recipients = 'jasseromero@outlook.com',
@subject = 'Catalogo de Regiones',
@body = 'Xd',
@query = 'select * from Northwind.dbo.Region',
@attach_query_result_as_file = 1

exec msdb.[dbo].[sp_send_dbmail]
@profile_name = 'Administrador de Base de Datos',
@recipients = 'jasseromero@outlook.com',
@copy_recipients = 'jasseromero@outlook.com',
@subject = 'Catalogo de Regiones',
@body = 'Xd',
@query = 'execute Northwind.dbo.Regiones_Northwind',
@attach_query_result_as_file = 1

alter procedure Region_Northwind
as
select * from Northwind.dbo.Region

select * from Northwind.dbo.Region

exec Region_Northwind
