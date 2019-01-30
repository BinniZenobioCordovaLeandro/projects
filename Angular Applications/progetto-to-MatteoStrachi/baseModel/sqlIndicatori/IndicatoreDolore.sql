select
(
  select count(*) as "persone presenti"
    from persons p
    join contracts c on c.id_contractee = p.id
    join services s on s.id = c.id_service and upper(s.name) = 'RSA'
    where p.fl_patient = true
      and s.id_organization = 2
      and (c.valid_from between TO_DATE('10/11/2018', 'YYYY-MM-dd') and TO_DATE('25/12/2018', 'YYYY-MM-dd'))
      or (c.valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd')
      and (c.valid_to is null or NULLIF(c.valid_to, TO_DATE('25/12/2018', 'YYYY-MM-dd')) between TO_DATE('10/11/2018', 'YYYY-MM-dd') and TO_DATE('25/12/2018', 'YYYY-MM-dd')))
),
(
  select count(distinct(id_person)) as "persone con dolore - NRS"
      	from forms f
      	where external_id in (
      		  select forminstanceid
              from dwh_pqrst
              where (
                fd_fd_scoretot::float >= 4 and fd_fd_scoretot::float <= 6
              )
      		)
          and id_contract in (
            select id
        		from contracts
        			where
          				  ((valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('10/11/2018', 'YYYY-MM-dd') or valid_to is null))
          				or
          				  (valid_from <= TO_DATE('25/12/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
          				or
          				  (valid_from >= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to <= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
          				or
          				  (valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null)))
          )
        and id_form_parameter in (select id from form_parameters where id_organization = 2)
        and id_person is not null
),
(
  select count(distinct(id_person)) as "persone con dolore - PAINAD"
      	from forms f
      	where external_id in (
      		  select forminstanceid
              from dwh_pqrst
             where (
                fd_fd_scoretotale is not null
              )
               and forminstanceid = f.external_id
      		)
          and id_contract in (
            select id
        		from contracts
        			where
        				(valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('10/11/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from <= TO_DATE('25/12/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from >= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to <= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
          )
        and id_form_parameter in (select id from form_parameters where id_organization = 2)
        and id_person is not null
),
(
  select count(distinct(id_person)) as "persone con dolore moderato - NRS"
        	from forms
        	where external_id in (
        		  select forminstanceid
                from dwh_pqrst
                where (
                  fd_fd_scoretot::float >= 4 and fd_fd_scoretot::float <=6
                )
        		)
          and id_contract in (
            select id
        		from contracts
        			where
        				(valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('10/11/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from <= TO_DATE('25/12/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from >= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to <= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
          )
          and id_form_parameter in (select id from form_parameters where id_organization = 2)
          and id_person is not null
),
(
  select count(distinct(id_person)) as "persone con dolore moderato - PAINAD"
        from forms
        where external_id in (
            select forminstanceid
              from dwh_pqrst
              where (
                fd_fd_scoretotale::float >= 4 and fd_fd_scoretotale::float <=6
              )
          )
          and id_contract in (
            select id
            from contracts
              where
                (valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('10/11/2018', 'YYYY-MM-dd') or valid_to is null))
                or
                (valid_from <= TO_DATE('25/12/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
                or
                (valid_from >= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to <= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
                or
                (valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
          )
          and id_form_parameter in (select id from form_parameters where id_organization = 2)
          and id_person is not null
),
(
  select count(distinct(id_person)) as "persone con dolore severo - NRS"
        	from forms
        	where external_id in (
        		  select forminstanceid
                from dwh_pqrst
                where (
                  fd_fd_scoretot::float >= 7
                )
        		)
          and id_contract in (
            select id
        		from contracts
        			where
        				(valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('10/11/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from <= TO_DATE('25/12/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from >= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to <= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
            )
          and id_form_parameter in (select id from form_parameters where id_organization = 2)
          and id_person is not null
),
(
  select count(distinct(id_person)) as "persone con dolore severo - PAINAD"
        from forms
        where external_id in (
            select forminstanceid
              from dwh_pqrst
              where (
                fd_fd_scoretotale::float >= 7
              )
          )
        and id_contract in (
            select id
            from contracts
              where
                (valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('10/11/2018', 'YYYY-MM-dd') or valid_to is null))
                or
                (valid_from <= TO_DATE('25/12/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
                or
                (valid_from >= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to <= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
                or
                (valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
          )
        and id_form_parameter in (select id from form_parameters where id_organization = 2)
        and id_person is not null
),
(
  select count(distinct(id_person)) as "persone dolore moderato o severo, tratati 60min - NRS"
        	from forms
        	where external_id in (
        		  select forminstanceid
                from dwh_pqrst
                where (
                  fd_fd_scoretot::float >= 4
                )
        		)
          and id_contract in (
            select id
        		from contracts
        			where
        				(valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('10/11/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from <= TO_DATE('25/12/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from >= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to <= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
          )
          and id_form_parameter in (select id from form_parameters where id_organization = 2)
          and id_person is not null
),
(
  select count(distinct(id_person)) as "persone dolore moderato o severo, tratati 60min - PAINAD"
        from forms
        where external_id in (
          select forminstanceid
            from dwh_pqrst
            where (
              fd_fd_scoretotale::float >= 4
            )
        )
        and id_contract in (
          select id
          from contracts
            where
              (valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('10/11/2018', 'YYYY-MM-dd') or valid_to is null))
              or
              (valid_from <= TO_DATE('25/12/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
              or
              (valid_from >= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to <= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
              or
              (valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
        )
        and id_form_parameter in (select id from form_parameters where id_organization = 2)
        and id_person is not null
),
10 as "persone dolore moderato o severo, rivalutazione 60min",
11 as "persone dolore moderato o severo, trattati",
12 as "persone dolore moderato o severo, senza terapia in atto / terapia inefficace, valutazione medica entro 48ore da rilevazione",
(
  select count(distinct(id_person)) as "persone dolore moderato o severo - NRS"
        	from forms
        	where external_id in (
        		  select forminstanceid
                from dwh_pqrst
                where (
                  fd_fd_scoretot::float >= 4
                )
        		)
          and id_contract in (
            select id
        		from contracts
        			where
        				(valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('10/11/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from <= TO_DATE('25/12/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from >= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to <= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
        				or
        				(valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
          )
          and id_form_parameter in (select id from form_parameters where id_organization = 2)
          and id_person is not null
),
(
  select count(distinct(id_person)) as "persone dolore moderato o severo - PAINAD"
        from forms
        where external_id in (
          select forminstanceid
            from dwh_pqrst
            where (
              fd_fd_scoretotale::float >= 4
            )
        )
        and id_contract in (
          select id
          from contracts
            where
              (valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('10/11/2018', 'YYYY-MM-dd') or valid_to is null))
              or
              (valid_from <= TO_DATE('25/12/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
              or
              (valid_from >= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to <= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
              or
              (valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
        )
        and id_form_parameter in (select id from form_parameters where id_organization = 2)
        and id_person is not null
),
14 as "persone terapia oppioide associata a lassativo",
15 as "persone terapia oppioidi",
16 as "persone valutate, presenza dolore, scala periodo riferimento",
17 as "persone periodo riferimento",
(
  select count(distinct(id_person)) as "persone valutate almeno una volta, nel periodo di due settimane"
    from forms f
  	where id in (
  		select id
  			from forms
  			where date_valutation between (f.date_valutation - INTERVAL '7' DAY) and (f.date_valutation + INTERVAL '7' DAY)
  	)
  	and external_id in (
  		select forminstanceid from dwh_pqrst
  	)
  	and id_form_parameter in (select id from form_parameters where id_organization = 2)
    and id_contract in (
      select id
      from contracts
        where
          (valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('10/11/2018', 'YYYY-MM-dd') or valid_to is null))
          or
          (valid_from <= TO_DATE('25/12/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
          or
          (valid_from >= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to <= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
          or
          (valid_from <= TO_DATE('10/11/2018', 'YYYY-MM-dd') and (valid_to >= TO_DATE('25/12/2018', 'YYYY-MM-dd') or valid_to is null))
    )
    and id_person is not null
)
