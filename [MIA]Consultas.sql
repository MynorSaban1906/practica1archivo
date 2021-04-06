
1. Mostrar el nombre del hospital, su dirección y el número de fallecidos por
cada hospital registrado


select a.HospitalId as IdHospital,h.NombreH as Hospital ,h.Ubicacion,count(a.VictimaId) as Pacientes_Fallecidos
from AsignaHospital as a  inner join Victima as v
on a.VictimaId=v.idVictima
inner join Hospital as h
on a.HospitalId=h.idHospital
where v.FechaMuerte!=''
group by a.HospitalId;


2. Mostrar el nombre, apellido de todas las víctimas en cuarentena que
presentaron una efectividad mayor a 5 en el tratamiento “Transfusiones de
sangre”.

SELECT v.NombreV,v.ApellidoV,v.EstadoVictima,a.EfectividadVictima,t.NombreT
	FROM AsignaTratamiento a
	INNER JOIN Victima v
	ON a.idVictima=v.idVictima
	INNER JOIN Tratamiento t
	ON t.idTratamiento= a.idTratamiento
    where v.EstadoVictima LIKE '%cuarentena%' and a.EfectividadVictima>5 and 
    t.NombreT='Transfusiones de sangre';


3. Mostrar el nombre, apellido y dirección de las víctimas fallecidas con más de
tres personas asociadas.

SELECT  v.NombreV,v.ApellidoV,v.DireccionV,count(a.VictimaId) as Asociados
	FROM ContactoVictima a
	INNER JOIN  Victima v
	ON a.VictimaId=v.idVictima
    where v.FechaMuerte!=''
    group by (a.VictimaId)
    having Asociados>3 ;
    
SELECT distinct v.idVictima,v.NombreV,v.ApellidoV,v.DireccionV,count(a.ConocidoId)
	FROM ContactoVictima a
	INNER JOIN  Victima v
	ON a.VictimaId=v.idVictima
    where v.FechaMuerte!=''
    group by (a.ConocidoId);
    having asociados>3 ;



4. Mostrar el nombre y apellido de todas las víctimas en estado “Suspendida”
que tuvieron contacto físico de tipo “Beso” con más de 2 de sus asociados.

SELECT c.Tipo_Contacto, v.NombreV,v.ApellidoV,v.EstadoVictima,count(a.VictimaId) as Asociados
	FROM AsignaConocidos a
	INNER JOIN  Victima  v
	ON a.VictimaId=v.idVictima 
    INNER JOIN ContactoVictima  c
	ON c.VictimaId=v.idVictima and c.ConocidoId=a.PersonasConocidasId  
    where v.EstadoVictima like '%sospecha%' and c.Tipo_Contacto='Beso'
    group by (a.VictimaId)
    having Asociados>2 ;
    



5. Top 5 de víctimas que más tratamientos se han aplicado del tratamiento
“Oxígeno”.

    
select v.NombreV,v.ApellidoV,T.NombreT,COUNT(T.NombreT) as NUMERO
FROM Victima v
INNER JOIN AsignaTratamiento a on a.idVictima=v.idVictima
INNER JOIN Tratamiento T on T.idTratamiento=a.idTratamiento
where T.NombreT='Oxígeno'
GROUP BY v.NombreV,v.ApellidoV,T.NombreT
LIMIT 5;
    
6. Mostrar el nombre, el apellido y la fecha de fallecimiento de todas las
víctimas que se movieron por la dirección “1987 Delphine Well” a los cuales
se les aplicó "Manejo de la presión arterial" como tratamiento.

SELECT distinct v.NombreV,v.ApellidoV,v.FechaMuerte,u.Direccion,t.NombreT
	FROM  (select idVictima,DireccionV,NombreV,ApellidoV,FechaMuerte
    from Victima where FechaMuerte!='')  v
	INNER JOIN Ubicacion u
	ON u.idVictima=v.idVictima
    INNER JOIN AsignaTratamiento a
	ON a.idVictima=v.idVictima
    INNER JOIN (select * from Tratamiento where NombreT='Manejo de la presión arterial') t
	ON t.idTratamiento=a.idTratamiento
    where u.Direccion='1987 Delphine Well' ;




7. Mostrar nombre, apellido y dirección de las víctimas que tienen menos de 2
allegados los cuales hayan estado en un hospital y que se le hayan aplicado
únicamente dos tratamientos.

    
SELECT  v.NombreV,v.ApellidoV,v.DireccionV,count(a.VictimaId) as Asociados
	FROM ContactoVictima a
	INNER JOIN  Victima v
	ON a.VictimaId=v.idVictima
	INNER JOIN  (SELECT  v.idVictima as VictimaId,count(a.idVictima) as numero
	FROM AsignaTratamiento a INNER JOIN  Victima v ON a.idVictima=v.idVictima
	INNER JOIN  AsignaHospital h ON h.VictimaId=v.idVictima
    group by a.idVictima having numero=2 ) h
	ON h.VictimaId=v.idVictima
	group by a.VictimaId
	having Asociados<2;
 
select v.NombreV,v.ApellidoV,v.DireccionV,count(distinct a.IdConocido) as asociados
from Victima as v
inner join ContactoVictima as cv on cv.VictimaId=v.idVictima
inner join PersonasConocida as a on a.IdConocido=cv.ConocidoId
inner join AsignaTratamiento as att on att.idVictima=v.idVictima
inner join Tratamiento as t on t.idTratamiento=att.idTratamiento
inner join AsignaHospital as ah on ah.VictimaId=v.idVictima
inner join Hospital as h on h.idHospital=ah.HospitalId 
WHERE h.NombreH!=''
group by v.NombreV,v.ApellidoV,v.DireccionV
having count(distinct cv.ConocidoId)<2 and count(distinct t.idTratamiento)=2
order by v.NombreV;

8. Mostrar el número de mes ,de la fecha de la primera sospecha, nombre y
apellido de las víctimas que más tratamientos se han aplicado y las que
menos. (Todo en una sola consulta).


SELECT substring(v.FechaSospecha,6,2) as Mes_Primera_Sospecha,v.NombreV,v.ApellidoV,count(a.idTratamiento) as cantidad,min.CANT
	FROM Victima v
	INNER JOIN  AsignaTratamiento a
	ON  v.idVictima =a.idVictima
    INNER JOIN (select max(d.cantidad),d.tratamiento AS CANT from (
	SELECT count(a.idTratamiento),a.idTratamiento as tratamiento as cantidad
	FROM Victima v
	INNER JOIN  AsignaTratamiento a
	ON  v.idVictima =a.idVictima
    group by a.idVictima) as d) AS MIN
    min.CANT
    group by a.idVictima;


SELECT * FROM(
select v.NombreV,v.ApellidoV,v.FechaSospecha,substring(v.FechaSospecha,6,2) as mes_primera_sospecha,count(att.idTratamiento)as nTRatamiento 
from Tratamiento as t
inner join AsignaTratamiento att on att.idTratamiento=t.idTratamiento
inner join Victima v on v.idVictima=att.idVictima
group by v.NombreV,v.ApellidoV,v.FechaSospecha
order by nTRatamiento DESC
LIMIT 5
)a
union all 
select * from (
select v.NombreV,v.ApellidoV,v.FechaSospecha,substring(v.FechaSospecha,6,2) as mes_primera_sospecha,count(att.idTratamiento)as nTRatamiento 
from Tratamiento as t
inner join AsignaTratamiento att on att.idTratamiento=t.idTratamiento
inner join Victima v on v.idVictima=att.idVictima
group by v.NombreV,v.ApellidoV,v.FechaSospecha
order by nTRatamiento asc
LIMIT 5
)b;
    
9. Mostrar el porcentaje de víctimas que le corresponden a cada hospital.



select a.HospitalId,h.NombreH,count(a.VictimaId)/(select sum(p.pacientes) from (select count(a.VictimaId) as pacientes
	from AsignaHospital as a 
	inner join Hospital as h
	on a.HospitalId=h.idHospital
	group by a.HospitalId) as p) as pacientes
	from AsignaHospital as a 
	inner join Hospital as h
	on a.HospitalId=h.idHospital
	group by a.HospitalId ;




10. Mostrar el porcentaje del contacto físico más común de cada hospital de la
siguiente manera: nombre de hospital, nombre del contacto físico, porcentaje
de víctimas.


select a.HospitalId as IdHospital,h.NombreH as Hospital,count(a.VictimaId) as Pacientes_En_Hospital
from AsignaHospital as a  inner join Victima as v
on a.VictimaId=v.idVictima
inner join Hospital as h
on a.HospitalId=h.idHospital
where v.FechaMuerte=''
group by a.HospitalId;