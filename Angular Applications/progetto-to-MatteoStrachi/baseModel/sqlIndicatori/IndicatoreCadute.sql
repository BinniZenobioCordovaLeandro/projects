select (
  select count(*) as "persone presenti"
    from persons p
    join contracts c on c.id_contractee = p.id
    join services s on s.id = c.id_service and upper(s.name) = 'RSA'
    where p.fl_patient = true
      and s.id_organization = $P{P_idOrganization}
      and (c.valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
      or (c.valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd')
      and (c.valid_to is null or NULLIF(c.valid_to, TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd')) between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd')))
), (
  select sum(counter) as "solo una caduta"
    from (select case when count(id_person) = 1 then 1 else 0 end as counter from forms
    	where external_id in (select forminstanceid from dwh_schedarilevazionecadutekane)
      and id_contract in (
        select id
        from contracts
          where
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null)))
      and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
    group by id_person) selected
), (
  select sum(counter) as "piu una caduta"
    from (select case when count(id_person) > 1 then 1 else 0 end as counter from forms
    	where external_id in (select forminstanceid from dwh_schedarilevazionecadutekane)
      and id_contract in (
        select id
        from contracts
          where
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null)))
      and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
    group by id_person) selected
), (
  select count(*) as "cadute con esito menore"
    from forms where
      external_id in (select forminstanceid from dwh_schedarilevazionecadutekane
      where
        (fd_formdata_ecrecente_ldtmolli_value = 'SI' or
        fd_formdata_ecrecente_llcontuosa_value = 'SI')
        and
        ((fd_formdata_ecrecente_morte_value = 'NO' or fd_formdata_ecrecente_morte_value is null) and
        (fd_formdata_ecrecente_dmsinsicurezza_value = 'NO' or fd_formdata_ecrecente_dmsinsicurezza_value is null) and
        (fd_formdata_ecrecente_frattura_value = 'NO' or fd_formdata_ecrecente_frattura_value is null) and
        (fd_formdata_ecrecente_ospedalizazione_value = 'NO' or fd_formdata_ecrecente_ospedalizazione_value is null) and
        (fd_formdata_ecrecente_dmslesioni_value = 'NO' or fd_formdata_ecrecente_dmslesioni_value is null) and
        (fd_formdata_ecrecente_esubdurale_value = 'NO' or fd_formdata_ecrecente_esubdurale_value is null)))
        and id_contract in (
      select id
      from contracts
        where
          (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
          or
          (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
          or
          (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
          or
          (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null)))
    and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
),(
  select count(*) as "cadute con esito maggiore"
    from forms where
      external_id in (
      select forminstanceid from dwh_schedarilevazionecadutekane
      where
        fd_formdata_ecrecente_morte_value = 'SI' or
        fd_formdata_ecrecente_dmsinsicurezza_value = 'SI' or
        fd_formdata_ecrecente_frattura_value = 'SI' or
        fd_formdata_ecrecente_ospedalizazione_value = 'SI' or
        fd_formdata_ecrecente_dmslesioni_value = 'SI' or
        fd_formdata_ecrecente_esubdurale_value = 'SI')
          and id_contract in (
        select id
        from contracts
          where
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null)))
      and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
),(
  select
    case
      when abs(SUM(CEIL((EXTRACT(epoch from age(valid_from, valid_to)) / 86400))::int)) is not null
      then abs(SUM(CEIL((EXTRACT(epoch from age(valid_from, valid_to)) / 86400))::int))
      else 0
    end
    as "giorni effetiva presenza"
    from contracts
    where
      valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd')
      and valid_to between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd')
), (
  select count(*) as "cadute in bagno"
  from forms
    where external_id in (
      select formInstanceId
        from dwh_schedarilevazionecadutekane
        where fd_formdata_ldcaduta_value = 'Bagno'
      )
      and id_contract in (
        select id
        from contracts
          where
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
      )
      and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
),(
  select count(*) as "cadute in camera"
  from forms
    where external_id in (
      select formInstanceId
        from dwh_schedarilevazionecadutekane
        where
        fd_formdata_ldcaduta_value = 'Letto' or
        fd_formdata_ldcaduta_value = 'Camera da letto'
      )
      and id_contract in (
        select id
        from contracts
          where
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
      )
      and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
),(
  select count(*) as "cadute in spazi comune"
  from forms
    where external_id in (
      select formInstanceId
        from dwh_schedarilevazionecadutekane
        where
        fd_formdata_ldcaduta_value = 'Spazi di attività comune' or
        fd_formdata_ldcaduta_value = 'Corridoio degenza'
      )
      and id_contract in (
        select id
        from contracts
          where
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
      )
      and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
), (
  select count(*) as "cadute in spazi esterni"
  from forms
    where external_id in (
      select formInstanceId
        from dwh_schedarilevazionecadutekane
        where
        fd_formdata_ldcaduta_value = 'Spazi non di pertinenza della struttura'
      )
      and id_contract in (
        select id
        from contracts
          where
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
      )
      and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
), (
  select count(*) as "cadute dalle 6.00 alle 13.59"
  from forms
  where external_id in (
    select
        formInstanceId
      from dwh_schedarilevazionecadutekane
        where
          fd_formdata_data_value::time between '06:00:00' and '13:59:00'
  )
  and id_contract in (
    select id
    from contracts
      where
        (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
        or
        (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
        or
        (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
        or
        (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
  )
  and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
), (
  select count(*) as "cadute dalle 14.00 alle 20.59"
  from forms
  where external_id in (
    select
        formInstanceId
      from dwh_schedarilevazionecadutekane
        where
          fd_formdata_data_value::time between '14:00:00' and '20:59:00'
  )
  and id_contract in (
    select id
    from contracts
      where
        (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
        or
        (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
        or
        (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
        or
        (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
  )
  and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
), (
  select count(*) as "cadute dalle 21.00 alle 5.59"
  from forms
  where external_id in (
    select
        formInstanceId
      from dwh_schedarilevazionecadutekane
        where
        fd_formdata_data_value::time between '00:00:00' and '5:59:00' or
        fd_formdata_data_value::time between '21:00:00' and '23:59:59'
  )
  and id_contract in (
    select id
    from contracts
      where
        (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
        or
        (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
        or
        (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
        or
        (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
  )
  and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
), (
  select count(*) as "cadute nelle prime 72 ore"
    from contracts
    where id in (
      select id_contract
        from forms
        where external_id in (
          select formInstanceId
            from dwh_schedarilevazionecadutekane
            where fd_formdata_data_value is not null
          )
        and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
    )
    and
      (
        (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
        or
        (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
        or
        (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
        or
        (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
      )
  ), (
    select count(*) as "numero cadute"
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
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
      )
      and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
  ), (
    select count(*) as "cadute con esito"
      from forms where
        external_id in (select forminstanceid from dwh_schedarilevazionecadutekane
        where
          fd_formdata_ecrecente_ldtmolli_value = 'SI' or
          fd_formdata_ecrecente_llcontuosa_value = 'SI' or
          fd_formdata_ecrecente_morte_value = 'SI' or
          fd_formdata_ecrecente_dmsinsicurezza_value = 'SI' or
          fd_formdata_ecrecente_frattura_value = 'SI' or
          fd_formdata_ecrecente_ospedalizazione_value = 'SI' or
          fd_formdata_ecrecente_dmslesioni_value = 'SI' or
          fd_formdata_ecrecente_esubdurale_value = 'SI'
          and id_contract in (
        select id
        from contracts
          where
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from >= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to <= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
            or
            (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and (valid_to >= TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') or valid_to is null))
          )
        )
      and $P!{backP_validator_P_id_Person} and date_definition between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd') and id_form_parameter in (select id from form_parameters  where id_organization = $P{P_idOrganization})
  ), (
        select count(id) as "nuovi ingressi"
          from contracts
            where
            valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd')
  )
