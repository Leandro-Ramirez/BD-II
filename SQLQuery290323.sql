Create database MiEmpresaSistema


----calse 29/03/23

Create login [DESKTOP-I64862Q\CCBB-15] 
from windows

sp_addsrvrolemember [DESKTOP-I64862Q\CCBB-15], Sysadmin

sp_addsrvrolemember Sistema, dbCreator

Create Login Sistema with password='uni2023'
select @@SERVERNAME

create database Universidad
go
Create database MiEmprendimiento

sp_helpdb MiEmpresaSistema


sp_addsrvrolemember Sistema, Sysadmin

Deny view any database to Sistema





--Buscar que es un directorio activo

--como se hace