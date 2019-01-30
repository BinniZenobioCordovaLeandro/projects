select
  (
    select count(distinct(id_person)) as "persone con Barthel compilata entro 48ore dall'ingresso"
    	from forms f
     where external_id in
         (
           select forminstanceid
             from dwh_schedaindicebarthel
         )
       and insert_date in
    	   (
    		   select max(insert_date)
             from forms
             where id_person = f.id_person
    		 )
    	 and id_contract in
    		 (
    		 	select id
    		 	  from contracts
    		 	 where f.insert_date between valid_from and valid_from + interval '2 days'
    		 	   and (valid_from between TO_DATE('29/11/2018', 'YYYY-MM-dd') and TO_DATE('30/11/2018', 'YYYY-MM-dd'))
               or (valid_from <= TO_DATE('29/11/2018', 'YYYY-MM-dd')
              and (valid_to is null or NULLIF(valid_to, TO_DATE('30/11/2018', 'YYYY-MM-dd'))
          between TO_DATE('29/11/2018', 'YYYY-MM-dd') and TO_DATE('30/11/2018', 'YYYY-MM-dd')))
                and id = f.id_contract
    		 )
    	 and id_form_parameter in
    	  (
      	 	 select id
      	 	   from form_parameters
      	 	  where id_organization = 2
      	 	  and id = f.id_form_parameter
    	  )
       and id_contract not in
        (
          select id_contract
            from contract_history ch
           where classification_id not in
               (
                 select id
                   from classifications
                  where lower(description) like '%sollievo%'
                     and id = ch.classification_id
               )
             and id_contract = f.id_contract
        )
  ),
  (
    select count(*) as "ingressi nel periodo"
      from contracts c
     where id_service in
         (
           select id
             from services
            where upper(name) = 'RSA'
         )
       and (valid_from between TO_DATE('29/11/2018', 'YYYY-MM-dd') and TO_DATE('30/11/2018', 'YYYY-MM-dd'))
        or (valid_from <= TO_DATE('29/11/2018', 'YYYY-MM-dd')
       and (valid_to is null or NULLIF(valid_to, TO_DATE('30/11/2018', 'YYYY-MM-dd'))
   between TO_DATE('29/11/2018', 'YYYY-MM-dd') and TO_DATE('30/11/2018', 'YYYY-MM-dd')))
       and id not in
        (
           select id_contract
             from contract_history ch
            where id_contract = c.id
              and classification_id not in
                (
                  select id
                    from classifications
                   where id = ch.classification_id
                     and lower(description) like '%sollievo%'
                 )
        )
  ),
  (
    select count(distinct(id_person)) as "persone nel periodo con perdita della capacità funzionalità - (valori da un mese prima)"
    	from forms f
     where insert_date in
    		(
    			select max(insert_date)
            from forms
           where id_person = f.id_person
    		)
    	 and id_contract in
    		(
    			select id
    			  from contracts
    			 where id = f.id_contract
    			   and f.insert_date between valid_from and valid_from + interval '2 days'
    			   and valid_from >= (to_timestamp('26/11/2018','dd/MM/yyyy') - interval '1 month')
    			   and (valid_from between TO_DATE('29/11/2018', 'YYYY-MM-dd') and TO_DATE('30/11/2018', 'YYYY-MM-dd'))
              or (valid_from <= TO_DATE('29/11/2018', 'YYYY-MM-dd')
             and (valid_to is null or NULLIF(valid_to, TO_DATE('30/11/2018', 'YYYY-MM-dd'))
         between TO_DATE('29/11/2018', 'YYYY-MM-dd') and TO_DATE('30/11/2018', 'YYYY-MM-dd')))
    		)
    	 and id_form_parameter in
    	  (
      	 	select id
      	 	  from form_parameters
      	 	 where id = f.id_form_parameter
      	 	   and id_organization = 2
    	  )
       and id_contract not in
        (
          select id_contract
            from contract_history ch
           where id_contract = f.id_contract
             and classification_id not in
               (
                 select id
                   from classifications
                  where id = ch.classification_id
                    and lower(description) like '%sollievo%'
               )
        )
  ),
  (
    select count(*) as "ingressi nel periodo di riferimento (valori da un mese prima)"
      from contracts c
     where id_service in
         (
           select id
             from services
            where upper(name) = 'RSA'
         )
       and (valid_from between TO_DATE('29/11/2018', 'YYYY-MM-dd')- interval '1 month' and TO_DATE('30/11/2018', 'YYYY-MM-dd'))
        or (valid_from <= TO_DATE('29/11/2018', 'YYYY-MM-dd')- interval '1 month'
       and (valid_to is null or NULLIF(valid_to, TO_DATE('30/11/2018', 'YYYY-MM-dd'))
   between TO_DATE('29/11/2018', 'YYYY-MM-dd')- interval '1 month' and TO_DATE('30/11/2018', 'YYYY-MM-dd')))
       and id not in
        (
          select id_contract
            from contract_history ch
           where id_contract = c.id
             and classification_id not in
               (
                 select id
                   from classifications
                  where id = ch.classification_id
                    and lower(description) like '%sollievo%'
               )
        )
  ),
  (
    select count(*) as "persone con perdita funzionale, PAI specifico non programmato"
      from persons p
     where 1 =
     (
       select (
       	case
       	when
       	(
       		select punteggio
       		  from
       		  	(
       			select fd_fd_attivitabase_punteggiovdal as punteggio,
                   inserttime as inserttime
       			  from dwh_schedaindicebarthel dw
       			 where forminstanceid in
       			 	 (
       			 	 	select external_id
       			 	 	  from forms f
       			 	 	 where f.external_id = dw.forminstanceid
       			 	 	   and f.id_person = p.id
       			 	 )
       			 order
       			    by inserttime desc
       			 limit 2
       			) as a
       		 order
       		    by inserttime desc
       		    limit 1
       	)
       	<
       	(
       		select punteggio
       		  from
       		  	(
       			select fd_fd_attivitabase_punteggiovdal as punteggio, inserttime as inserttime
       			  from dwh_schedaindicebarthel dw
       			 where forminstanceid in
       			 	 (
       			 	 	select external_id
       			 	 	  from forms f
       			 	 	 where f.external_id = dw.forminstanceid
       			 	 	   and f.id_person = p.id
       			 	 )
       			 order
       			    by inserttime desc
       			 limit 2
       			) as a
       		 order
       		    by inserttime asc
       		    limit 1
       	)
       	then 1
       	else 0
       	 end
       )
     )
  ),
  (
    select count(*) as "persone perdita funzionale"
      from persons p
     where 1 =
     (
       select (
        case
        when
        (
          select punteggio
            from
              (
            select fd_fd_attivitabase_punteggiovdal as punteggio,
                   inserttime as inserttime
              from dwh_schedaindicebarthel dw
             where forminstanceid in
               (
                select external_id
                  from forms f
                 where f.external_id = dw.forminstanceid
                   and f.id_person = p.id
                   and id_contract in
                     (
                     	select id
                     	  from contracts
                     	 where valid_from >= '30/11/2018'
                     	   and (valid_to is null or valid_to <= '30/11/2018')
                         and id_service in
                           (
                             select id
                               from services
                              where upper(name) = 'RSA'
                           )
                     )
               )
             order by inserttime desc
             limit 2
            ) as a
           order by inserttime desc
              limit 1
        )
        <
        (
          select punteggio
            from
              (
            select fd_fd_attivitabase_punteggiovdal as punteggio, inserttime as inserttime
              from dwh_schedaindicebarthel dw
             where forminstanceid in
               (
                select external_id
                  from forms f
                 where f.external_id = dw.forminstanceid
                   and f.id_person = p.id
                   and id_contract in
                     (
                     	select id
                     	  from contracts
                     	 where valid_from >= '30/11/2018'
                     	   and (valid_to is null or valid_to <= '30/11/2018')
                         and id_service in (
                           select id
                             from services
                            where upper(name) = 'RSA'
                         )
                     )
               )
             order
                by inserttime desc
             limit 2
            ) as a
           order
              by inserttime asc
              limit 1
        )
        then 1
        else 0
         end
       )
     )
  )
