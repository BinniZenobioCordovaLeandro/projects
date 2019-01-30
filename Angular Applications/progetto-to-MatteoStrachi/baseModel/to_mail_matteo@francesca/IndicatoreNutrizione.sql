-- "persone con disminuzione non pianificata di peso >= 5%"
  select 1 as "persone con disminuzione non pianificata di peso >= 5%"

-- "persone presenti da 3 messi dal giorno indice"
  select count(*) as "persone presenti da 3 messi dal giorno indice"
    from persons p
    join contracts c on c.id_contractee = p.id
    join services s on s.id = c.id_service and upper(s.name) = 'RSA'
   where p.fl_patient = true
      and (valid_from between (to_date('10-10-2011','dd-MM-yyyy') - interval '3 months') and '20-10-2018')
       or (valid_from <= (to_date('10-10-2011','dd-MM-yyyy') - interval '3 months')
      and (valid_to is null or NULLIF(valid_to, '20-10-2018')
  between (to_date('10-10-2011','dd-MM-yyyy') - interval '3 months') and '20-10-2018'))

-- "rischio nutrizionale"
  select 3 as "rischio nutrizionale"

-- "PAI effetuati"
  select count(*) as "PAI effetuati"
    from pais
   where date_definition >= '10-10-2011'
     and date_definition <= '20-10-2018'
     and id_form_parameter in
    	 (
    	 	 select id
    		   from form_parameters
    		  where id_organization = 1
    	 )
     and state = 2

-- "persone malnutrite che assumono integratori"
  select 5 as "persone malnutrite che assumono integratori"

-- "persone malnutrite per scala Mini Nutritional Assesment"
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
          where (valid_to is null or valid_to <= '20-10-2018')
            and id = f.id_contract
       )
     and insert_date between '10-10-2011' and '20-10-2018'
     and id_form_parameter in
       (
         select id
           from form_parameters
          where id_organization = 1
            and id = f.id_form_parameter
       )

-- "persone malnutrite per scala MUST"
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
       	  where (valid_from between '10-10-2011' and '20-10-2018')
             or (valid_from <= '10-10-2011'
            and (valid_to is null or NULLIF(valid_to, '20-10-2018')
        between '10-10-2011' and '20-10-2018'))
            and id = f.id_contract
       )
     and insert_date between '10-10-2011' and '20-10-2018'
     and id_form_parameter in
       (
         select id
           from form_parameters
          where id_organization = 1
            and id = f.id_form_parameter
       )

-- "persone disfagiche"
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
          where (valid_from between '10-10-2011' and '20-10-2018')
             or (valid_from <= '10-10-2011'
            and (valid_to is null or NULLIF(valid_to, '20-10-2018')
        between '10-10-2011' and '20-10-2018'))
       )

-- "persone presenti nel periodo mensile secondo il giorno"
  select count(*) as "persone presenti nel periodo mensile secondo il giorno"
    from persons p
   where id in
       (
         select id_contractee
  	     from contracts
  	    where (valid_from between '10-10-2011' and '20-10-2018')
           or (valid_from <= '10-10-2011'
          and (valid_to is null or NULLIF(valid_to, '20-10-2018')
      between '10-10-2011' and '20-10-2018'))
  		    and id_contractee = p.id
       )

-- "persone con PEG nel giorno indice"
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
  			  and (valid_from between '10-10-2011' and '20-10-2018')
           or (valid_from <= '10-10-2011'
          and (valid_to is null or NULLIF(valid_to, '20-10-2018')
      between '10-10-2011' and '20-10-2018'))
    	)
	)

-- "persone nel giorno indice"
select count(*) as "persone nel giorno indice"
  from persons p
  join contracts c on c.id_contractee = p.id
  join services s on s.id = c.id_service and upper(s.name) = 'RSA'
  where p.fl_patient = true
    and (valid_from between '10-10-2011' and '20-10-2018')
     or (valid_from <= '10-10-2011'
    and (valid_to is null or NULLIF(valid_to, '20-10-2018')
between '10-10-2011' and '20-10-2018'))

-- "PEG posizionate a seguito di processo"
  select 1 as "PEG posizionate a seguito di processo"

-- "person con PEG"
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
           from forms f
          where external_id in
              (
                select forminstanceid
                  from dwh_schedavalutazionesanitaria
                 where forminstanceid = f.external_id
              )
          group by id_person
       )
    and id_contract in
      (
        select id
          from contracts
         where (valid_from between '10-10-2011' and '20-10-2018')
            or (valid_from <= '10-10-2011'
           and (valid_to is null or NULLIF(valid_to, '20-10-2018')
       between '10-10-2011' and '20-10-2018'))
      )
