-- persone con almeno una caduta
select count(id_person) from forms where external_id in (select formInstanceId from dwh_schedarilevazionecadutekane);

-- persone con più di una caduta
select sum(counter) from (select case when count(id_person) > 1 then 1 else 0 end as counter from forms
	where external_id in (select forminstanceid from dwh_schedarilevazionecadutekane)
group by id_person) selected;

-- persone cadute nel periodo di riferimento_
select count(distinct(id_person)) from forms
	where external_id in (select forminstanceid from dwh_schedarilevazionecadutekane)

-- contracts per rango di data:
select id
from contracts
  where
    (valid_from <= '2018-11-12' and (valid_to >= '2018-11-12' or valid_to is null))
    or
    (valid_from <= '2018-11-14' and (valid_to >= '2018-11-14' or valid_to is null))
    or
    (valid_from >= '2018-11-12' and (valid_to <= '2018-11-14' or valid_to is null))
    or
    (valid_from <= '2018-11-12' and (valid_to >= '2018-11-14' or valid_to is null));

-- cadute con esito minore
select forminstanceid from dwh_schedarilevazionecadutekane
  where
    (fd_formdata_ecrecente_ldtmolli_value = 'SI' or
    fd_formdata_ecrecente_llcontuosa_value = 'SI')
    and
    ((fd_formdata_ecrecente_morte_value = 'NO' or fd_formdata_ecrecente_morte_value is null) and
    (fd_formdata_ecrecente_dmsinsicurezza_value = 'NO' or fd_formdata_ecrecente_dmsinsicurezza_value is null) and
    (fd_formdata_ecrecente_frattura_value = 'NO' or fd_formdata_ecrecente_frattura_value is null) and
    (fd_formdata_ecrecente_ospedalizazione_value = 'NO' or fd_formdata_ecrecente_ospedalizazione_value is null) and
    (fd_formdata_ecrecente_dmslesioni_value = 'NO' or fd_formdata_ecrecente_dmslesioni_value is null) and
    (fd_formdata_ecrecente_esubdurale_value = 'NO' or fd_formdata_ecrecente_esubdurale_value is null));

-- cadute con esito maggiore
select forminstanceid from dwh_schedarilevazionecadutekane
  where
    fd_formdata_ecrecente_morte_value = 'SI' or
    fd_formdata_ecrecente_dmsinsicurezza_value = 'SI' or
    fd_formdata_ecrecente_frattura_value = 'SI' or
    fd_formdata_ecrecente_ospedalizazione_value = 'SI' or
    fd_formdata_ecrecente_dmslesioni_value = 'SI' or
    fd_formdata_ecrecente_esubdurale_value = 'SI';

-- cadute registrate nel periodo di rferimento
select forminstanceid from dwh_schedarilevazionecadutekane

-- numero dei giorni di effetiva presenza dei residenti nel periodo di riferiemento.
select
	abs(SUM(CEIL((EXTRACT(epoch from age(valid_from, valid_to)) / 86400))::int))
	from contracts
	where
		valid_from between '2018-01-12' and '2018-12-31'
		and valid_to between '2018-01-12' and '2018-12-31';


-- > 1_9
-- cadute in Bagno
select formInstanceId
  from dwh_schedarilevazionecadutekane
  where
    fd_formdata_ldcaduta_value = 'Bagno'

-- cadute in Letto
select formInstanceId
  from dwh_schedarilevazionecadutekane
  where
    fd_formdata_ldcaduta_value = 'Letto' or
    fd_formdata_ldcaduta_value = 'Camera da letto';

-- cadute in spazi comune
select formInstanceId
  from dwh_schedarilevazionecadutekane
  where
    fd_formdata_ldcaduta_value = 'Spazi di attività comune' or
    fd_formdata_ldcaduta_value = 'Corridoio degenza'

-- cadute negli spaisi esterni
select formInstanceId
  from dwh_schedarilevazionecadutekane
  where
    fd_formdata_ldcaduta_value = 'Spazi non di pertinenza della struttura';


-- rango di ore:


-- cadute dalle 6.00 alle 13.59
select
    fd_formdata_data_value::time
  from dwh_schedarilevazionecadutekane
    where
      fd_formdata_data_value::time between '06:00:00' and '13:59:00'

-- cadute dalle 14.00 alle 20.59
select
    fd_formdata_data_value::time
  from dwh_schedarilevazionecadutekane
    where
      fd_formdata_data_value::time between '14:00:00' and '20:59:00';

-- cadute dalle 21.00 alle 5.59
select
    fd_formdata_data_value::time
  from dwh_schedarilevazionecadutekane
    where
      fd_formdata_data_value::time between '00:00:00' and '5:59:00' or
      fd_formdata_data_value::time between '21:00:00' and '23:59:59';
