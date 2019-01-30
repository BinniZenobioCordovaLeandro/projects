select
(
  select 1 as "persone con disminuzione non pianificata di peso >= 5%"
),(
  select count(*) as "persone presenti da 3 messi dal giorno indice"
  from persons p
  join contracts c on c.id_contractee = p.id
  join services s on s.id = c.id_service and upper(s.name) = 'RSA'
  where p.fl_patient = true
    --and s.id_organization = 2
    and (c.valid_to is null or c.valid_to >= '22/11/2018')
    and c.valid_from <= (to_date('22/11/2018', 'dd/MM/yyyy') - interval '3 months')
),(
  select 3 as "rischio nutrizionale"
),(
  select count(*) as "PAI effetuati"
    from pais
   where date_definition >= '22/11/2018'
     and date_definition <= '28/11/2018'
     and id_form_parameter in
    	 (
    	 	select id
    		  from form_parameters
    		 where id_organization = 2
    	 )
     and state = 2
),(
  select 5 as "persone malnutrite che assumono integratori"
),(
  select count(distinct(id_person)) as "persone malnutrite per scala Mini Nutritional Assesment"
    from forms f
   where external_id in
       (
         select forminstanceid
           from dwh_schedamininutritionalassesment
          where forminstanceid = f.external_id
       )
     and id_contract in
       (
         select id
           from contracts
          where (valid_to is null or valid_to <= '28/11/2018')
            and id = f.id_contract
       )
     and to_char(insert_date, 'dd/MM/yyyy') = to_char(to_date('28/11/2018','dd/MM/yyyy'),'dd/MM/yyyy')
     and id_form_parameter in
       (
         select id
           from form_parameters
          where id_organization = 2
            and id = f.id_form_parameter
       )
),(
  select count(distinct(id_person)) as "persone malnutrite per scala MUST"
    from forms f
   where external_id in
       (
         select forminstanceid
           from dwh_schedavalutazionemust
          where forminstanceid = f.external_id
       )
     and id_contract in
       (
       	 select id
       	   from contracts
       	  where (valid_to is null or valid_to <= '28/11/2018')
            and id = f.id_contract
       )
     and to_char(insert_date, 'dd/MM/yyyy') = to_char(to_date('28/11/2018','dd/MM/yyyy'),'dd/MM/yyyy')
     and id_form_parameter in
       (
         select id
           from form_parameters
          where id_organization = 2
            and id = f.id_form_parameter
       )
),(
  select count(distinct(id_person)) as "persone disfagiche"
    from forms
   where external_id in
       (
         select forminstanceid
    	     from dwh_test_acqua
    	    where fd_fd_somministrazione::int = 3
       )
     and id_contract in
       (
         select id
           from contracts
          where valid_from >= '28/11/2018'
            and (valid_to is null or valid_to <= '28/11/2018')
       )
),(
  select count(*) as "persone presenti nel periodo mensile secondo il giorno"
    from persons p
   where id in
       (
         select id_contractee
  	     from contracts
  	    where valid_from >= '28/11/2018'
  	      and (valid_to is null or valid_to <= '28/11/2018')
  		  and id_contractee = p.id
       )
),(
  select count(*) as "persone con PEG nel giorno indice"
	from persons p
	where id in (
		select
		id_person
		from forms f
		where id_person = p.id
  		and external_id in (
  			select forminstanceid
  			from dwh_schedavalutazionesanitaria fd
  		  where forminstanceid = f.external_id
  		    and fd_fd_sondinonasogastrico_score = 10
  		)
  		and date_definition = (
  			select max(date_definition)
        from forms
  			where id_person = f.id_person
  		)
      and id_contract in (
    		select
  			id
  			from contracts c
  			where id = f.id_contract
  			  and id not in (
  			  	select
  		  		id_contract
  		  		from contract_history
  		  		where classification_id not in (
  		  			select id
  	  				from classifications
  	  				where lower(description) like '%sollievo%'
  		  		)
  			  )
  			  and (valid_to is null or valid_to <= '22/11/2018')
    	)
	)
),(
  select count(*) as "persone nel giorno indice"
  from persons p
  join contracts c on c.id_contractee = p.id
  join services s on s.id = c.id_service and upper(s.name) = 'RSA'
  where p.fl_patient = true
    -- and s.id_organization = 2
    and (valid_to is null or valid_to >= '22/11/2018')
),(
  select 1 as "PEG posizionate a seguito di processo"
),(
  select count(distinct(id_person)) as "person con PEG"
    from forms
   where external_id in
       (
         select forminstanceid
      		 from dwh_schedavalutazionesanitaria
      		where fd_fd_sondinonasogastrico_code = 'op6a'
       )
     and id in
       (
         select max(id)
           from forms
          where external_id in
              (
                select forminstanceid
                  from dwh_schedavalutazionesanitaria
              )
          group by id_person
       )
)
