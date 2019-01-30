--"persone presenti"
      select count(*) as "persone presenti"
		    from persons p
		    join contracts c on c.id_contractee = p.id
		    join services s on s.id = c.id_service and upper(s.name) = 'RSA'
		    where p.fl_patient = true
		      and s.id_organization = 15
		      and (c.valid_from between '02-10-2018' and '05-06-2019')
		      or (c.valid_from <= '02-10-2018'
		      and (c.valid_to is null or NULLIF(c.valid_to, '05-06-2019') between '02-10-2018' and '05-06-2019'))

-- "solo una caduta"
		  select sum(counter) as "solo una caduta"
		    from (select case when count(id_person) = 1 then 1 else 0 end as counter from forms
		    	where external_id in (select forminstanceid from dwh_schedarilevazionecadutekane)
		      and id_contract in (
		        select id
		        from contracts
		          where
		            (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		            or
		            (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		            or
		            (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		            or
		            (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null)))
		      and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)
		    group by id_person) selected

-- "piu una caduta"
		  select sum(counter) as "piu una caduta"
		    from (select case when count(id_person) > 1 then 1 else 0 end as counter from forms
		    	where external_id in (select forminstanceid from dwh_schedarilevazionecadutekane)
		      and id_contract in (
		        select id
		        from contracts
		          where
		            (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		            or
		            (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		            or
		            (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		            or
		            (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null)))
		      and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)
		    group by id_person) selected

-- "cadute con esito menore"
		  select count(*) as "cadute con esito menore"
		    from forms where
		      external_id in (select forminstanceid from dwh_schedarilevazionecadutekane
		      where
		        (fd_fd_ecrecente_ldtmolli_value = 'SI' or
		        fd_fd_ecrecente_llcontuosa_value = 'SI')
		        and
		        ((fd_fd_ecrecente_morte_value = 'NO' or fd_fd_ecrecente_morte_value is null) and
		        (fd_fd_ecrecente_dmsinsicurezza_value = 'NO' or fd_fd_ecrecente_dmsinsicurezza_value is null) and
		        (fd_fd_ecrecente_frattura_value = 'NO' or fd_fd_ecrecente_frattura_value is null) and
		        (fd_fd_ecrecente_ospedalizazione_value = 'NO' or fd_fd_ecrecente_ospedalizazione_value is null) and
		        (fd_fd_ecrecente_dmslesioni_value = 'NO' or fd_fd_ecrecente_dmslesioni_value is null) and
		        (fd_fd_ecrecente_esubdurale_value = 'NO' or fd_fd_ecrecente_esubdurale_value is null)))
		        and id_contract in (
		      select id
		      from contracts
		        where
		          (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		          or
		          (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		          or
		          (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		          or
		          (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null)))
		    and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)

-- "cadute con esito maggiore"
		  select count(*) as "cadute con esito maggiore"
		    from forms where
		      external_id in (
		      select forminstanceid from dwh_schedarilevazionecadutekane
		      where
		        fd_fd_ecrecente_morte_value = 'SI' or
		        fd_fd_ecrecente_dmsinsicurezza_value = 'SI' or
		        fd_fd_ecrecente_frattura_value = 'SI' or
		        fd_fd_ecrecente_ospedalizazione_value = 'SI' or
		        fd_fd_ecrecente_dmslesioni_value = 'SI' or
		        fd_fd_ecrecente_esubdurale_value = 'SI')
		          and id_contract in (
		        select id
		        from contracts
		          where
		            (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		            or
		            (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		            or
		            (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		            or
		            (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null)))
		      and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)

-- "giorni effetiva presenza"
		  select
		    case
		      when abs(SUM(CEIL((EXTRACT(epoch from age(valid_from, valid_to)) / 86400))::int)) is not null
		      then abs(SUM(CEIL((EXTRACT(epoch from age(valid_from, valid_to)) / 86400))::int))
		      else 0
		    end
		    as "giorni effetiva presenza"
		    from contracts
		    where
		      valid_from between '02-10-2018' and '05-06-2019'
		      and valid_to between '02-10-2018' and '05-06-2019'

-- "cadute in bagno"
		  select
		  count(*) as "cadute in bagno"
		  from forms
		    where external_id in (
		      select formInstanceId
		        from dwh_schedarilevazionecadutekane
		        where fd_fd_ldcaduta_value = 'Bagno'
		      )
		      and id_contract in (
		        select id
		        from contracts
		          where
		            (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		            or
		            (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		            or
		            (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		            or
		            (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null))
		      )
		      and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)

-- "cadute in camera"
		  select
		  count(*) as "cadute in camera"
		  from forms
		    where external_id in (
		      select formInstanceId
		        from dwh_schedarilevazionecadutekane
		        where
		        fd_fd_ldcaduta_value = 'Letto' or
		        fd_fd_ldcaduta_value = 'Camera da letto'
		      )
		      and id_contract in (
		        select id
		        from contracts
		          where
		            (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		            or
		            (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		            or
		            (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		            or
		            (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null))
		      )
		      and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)

-- "cadute in spazi comune"
		  select
		  count(*) as "cadute in spazi comune"
		  from forms
		    where external_id in (
		      select formInstanceId
		        from dwh_schedarilevazionecadutekane
		        where
		        fd_fd_ldcaduta_value = 'Spazi di attività comune' or
		        fd_fd_ldcaduta_value = 'Corridoio degenza'
		      )
		      and id_contract in (
		        select id
		        from contracts
		          where
		            (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		            or
		            (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		            or
		            (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		            or
		            (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null))
		      )
		      and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)

-- "cadute in spazi esterni"
		  select
		  count(*) as "cadute in spazi esterni"
		  from forms
		    where external_id in (
		      select formInstanceId
		        from dwh_schedarilevazionecadutekane
		        where
		        fd_fd_ldcaduta_value = 'Spazi non di pertinenza della struttura'
		      )
		      and id_contract in (
		        select id
		        from contracts
		          where
		            (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		            or
		            (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		            or
		            (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		            or
		            (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null))
		      )
		      and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)

-- "cadute dalle 6.00 alle 13.59"
		  select
		    count(*) as "cadute dalle 6.00 alle 13.59"
		  from forms
		  where external_id in (
		    select
		        formInstanceId
		      from dwh_schedarilevazionecadutekane
		        where
		          fd_fd_data_value::time between '06:00:00' and '13:59:00'
		  )
		  and id_contract in (
		    select id
		    from contracts
		      where
		        (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		        or
		        (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		        or
		        (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		        or
		        (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null))
		  )
		  and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)

-- "cadute dalle 14.00 alle 20.59"
		  select
		    count(*) as "cadute dalle 14.00 alle 20.59"
		  from forms
		  where external_id in (
		    select
		        formInstanceId
		      from dwh_schedarilevazionecadutekane
		        where
		          fd_fd_data_value::time between '14:00:00' and '20:59:00'
		  )
		  and id_contract in (
		    select id
		    from contracts
		      where
		        (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		        or
		        (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		        or
		        (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		        or
		        (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null))
		  )
		  and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)

-- "cadute dalle 21.00 alle 5.59"
		  select
		    count(*) as "cadute dalle 21.00 alle 5.59"
		  from forms
		  where external_id in (
		    select
		        formInstanceId
		      from dwh_schedarilevazionecadutekane
		        where
		        fd_fd_data_value::time between '00:00:00' and '5:59:00' or
		        fd_fd_data_value::time between '21:00:00' and '23:59:59'
		  )
		  and id_contract in (
		    select id
		    from contracts
		      where
		        (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		        or
		        (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		        or
		        (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		        or
		        (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null))
		  )
		  and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)

-- "cadute nelle prime 72 ore"
		  select
		    count(*) as "cadute nelle prime 72 ore"
		    from contracts
		    where id in (
		      select id_contract
		        from forms
		        where external_id in (
		          select formInstanceId
		            from dwh_schedarilevazionecadutekane
		            where fd_fd_data_value is not null
		          )
		        and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)
		    )
		    and
		      (
		        (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		        or
		        (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		        or
		        (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		        or
		        (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null))
		      )

-- "numero cadute"
		    select
		      count(*) as "numero cadute"
		      from forms
		      where external_id in (
		        select
		          formInstanceId
		          from dwh_schedarilevazionecadutekane
		        )
		      and id_contract in (
		        select id
		        from contracts
		          where
		            (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		            or
		            (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		            or
		            (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		            or
		            (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null))
		      )
		      and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)

-- "cadute con esito"
		    select count(*) as "cadute con esito"
		      from forms where
		        external_id in (select forminstanceid from dwh_schedarilevazionecadutekane
		        where
		          fd_fd_ecrecente_ldtmolli_value = 'SI' or
		          fd_fd_ecrecente_llcontuosa_value = 'SI' or
		          fd_fd_ecrecente_morte_value = 'SI' or
		          fd_fd_ecrecente_dmsinsicurezza_value = 'SI' or
		          fd_fd_ecrecente_frattura_value = 'SI' or
		          fd_fd_ecrecente_ospedalizazione_value = 'SI' or
		          fd_fd_ecrecente_dmslesioni_value = 'SI' or
		          fd_fd_ecrecente_esubdurale_value = 'SI'
		          and id_contract in (
		        select id
		        from contracts
		          where
		            (valid_from <= '02-10-2018' and (valid_to >= '02-10-2018' or valid_to is null))
		            or
		            (valid_from <= '05-06-2019' and (valid_to >= '05-06-2019' or valid_to is null))
		            or
		            (valid_from >= '02-10-2018' and (valid_to <= '05-06-2019' or valid_to is null))
		            or
		            (valid_from <= '02-10-2018' and (valid_to >= '05-06-2019' or valid_to is null))
		          )
		        )
		      and id_person is not null and date_definition between '02-10-2018' and '05-06-2019' and id_form_parameter in (select id from form_parameters  where id_organization = 15)

-- "nuovi ingressi"
		        select
		          count(id) as "nuovi ingressi"
		          from contracts
		            where
		            valid_from between '02-10-2018' and '05-06-2019'
