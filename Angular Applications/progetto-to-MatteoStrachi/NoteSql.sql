select (
  select count(distinct(id_person)) "persone presenti" from forms
	where external_id in (
    select forminstanceid
    from dwh_schedarilevazionecadutekane)
  and id_contract in (
    select id
    from contracts
      where
        (valid_from <= '2018-11-12' and (valid_to >= '2018-11-12' or valid_to is null))
        or
        (valid_from <= '2018-11-14' and (valid_to >= '2018-11-14' or valid_to is null))
        or
        (valid_from >= '2018-11-12' and (valid_to <= '2018-11-14' or valid_to is null))
        or
        (valid_from <= '2018-11-12' and (valid_to >= '2018-11-14' or valid_to is null)))
), (
  select sum(counter) as "più una cduta" from (select case when count(id_person) > 1 then 1 else 0 end as counter from forms
  	where external_id in (select forminstanceid from dwh_schedarilevazionecadutekane)
    and id_contract in (
      select id
      from contracts
        where
          (valid_from <= '2018-11-12' and (valid_to >= '2018-11-12' or valid_to is null))
          or
          (valid_from <= '2018-11-14' and (valid_to >= '2018-11-14' or valid_to is null))
          or
          (valid_from >= '2018-11-12' and (valid_to <= '2018-11-14' or valid_to is null))
          or
          (valid_from <= '2018-11-12' and (valid_to >= '2018-11-14' or valid_to is null)))
  group by id_person) selected
)
