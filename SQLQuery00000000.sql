Create database Universidad
use Universidad
go

create table Estudiante
(IdEstudiante int,
primernombre varchar(50)

)

insert into Estudiante values (1,'Pedro')
use Universidad
select * from Estudiante

--Respaldos full de Base de datos universidad

Backup database Universidad
to disk = 'D:\BASEII\Backups\Universidad.bak'
with
name='Respaldo Full 1',
Description = 'Copia completa de archivos de BD'


--Respaldos 1 diferencial de Base de datos universidad

Backup database Universidad
to disk = 'D:\BASEII\Backups\Universidad.bak'
with
name='Respaldo diferencial 1',
Description = 'Copia parcial de archivos de BD',
differential


--Respaldos 2 diferencial de Base de datos universidad

Backup database Universidad
to disk = 'D:\BASEII\Backups\Universidad.bak'
with
name='Respaldo diferencial 2',
Description = 'Copia parcial de archivos de BD',
differential



--Respaldos 3 diferencial de Base de datos universidad

Backup database Universidad
to disk = 'D:\BASEII\Backups\Universidad.bak'
with
name='Respaldo diferencial 3',
Description = 'Copia parcial de archivos de BD',
differential

insert into Estudiante values (1,'Pedro')


--Respaldos 4 diferencial de Base de datos universidad

Backup database Universidad
to disk = 'D:\BASEII\Backups\Universidad.bak'
with
name='Respaldo diferencial 4',
Description = 'Copia parcial de archivos de BD',
differential

insert into Estudiante values (2,'Juan')

--visualizar archivos respaldos de la bd

Restore headeronly from disk = 'D:\BASEII\Backups\Universidad.bak'


Restore headeronly from disk = 'D:\BASEII\Backups\UniversidadComprimido.bak'

--Respaldos 1 Full Comprimido de Base de datos universidad


Backup database Universidad
to disk = 'D:\BASEII\Backups\UniversidadComprimido.bak'
with
name='Full Comprimido',
Description = 'Copia Full de archivos de BD',
compression

--Restaurar la base de datos

restore database Universidad
from disk = 'D:\BASEII\Backups\Universidad.bak'
with
file = 5,
Recovery

--Eliminar la base de datos
use master
drop database Universidad

-- Respaldo del registro de transacciones SQL SERVER

sp_helpdb Universidad

Backup log Universidad
to disk = 'D:\BASEII\Backups\Universidad.bak'

use Universidad
select * from Estudiante

insert into Estudiante values (4,'Messi')


--Restaurar la base de datos


restore database Universidad
from disk = 'D:\BASEII\Backups\Universidad.bak'
with
file = 5,
Recovery

--¿Como encriptar el backup? 


--Tarea.  Como crear certificados encriptacion de respaldos de base de datos 

