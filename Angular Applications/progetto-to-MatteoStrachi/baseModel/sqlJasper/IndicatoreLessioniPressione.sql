select
(
  select count(distinct(id_person)) as "persone con lesione"
    from forms f
   where id_contract in
     	 (
     	   select id
           from contracts c
          where ((valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
             or (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd')
            and (valid_to is null or NULLIF(valid_to, TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
        between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))))
            and id = f.id_contract
            and id_contractee in
            	 (
            	  select id
            	    from subjects_cr
            	   where id_organization = $P{P_idOrganization}
            	     and id = c.id_contractee
            	 )
     	 )
     and external_id in
       (
         select forminstanceid
           from dwh_scheda_presenza_lesione_decubito
          where forminstanceid = f.external_id
       )
),
(
  select count(*) as "persone presenti"
    from persons p
    join contracts c on c.id_contractee = p.id
    join services s on s.id = c.id_service and upper(s.name) = 'RSA'
    where p.fl_patient = true
      and s.id_organization = $P{P_idOrganization}
      and (c.valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
       or (c.valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd')
      and (c.valid_to is null or NULLIF(c.valid_to, TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd')) between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd')))
),
(
  select count(distinct(id_person)) as "persone con lesione al primo stadio"
    from forms f
   where id_contract in
       (
         select id
           from contracts c
          where ((valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
             or (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd')
            and (valid_to is null or NULLIF(valid_to, TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
        between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))))
            and id = f.id_contract
            and id_contractee in
            	 (
            	   select id
            	     from subjects_cr
            	    where id_organization = $P{P_idOrganization}
            	      and id = c.id_contractee
            	 )
       )
     and external_id in
       (
         select forminstanceid
           from dwh_scheda_presenza_lesione_decubito
          where fd_fd_sectiontre_gradoLesione_code = 'opL_2a'
            and forminstanceid = f.external_id
       )
),
(
  select count(distinct(id_person)) as "persone con lesione al secondo stadio"
    from forms f
   where id_contract in
       (
         select id
           from contracts c
          where ((valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
             or (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd')
            and (valid_to is null or NULLIF(valid_to, TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
        between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))))
            and id = f.id_contract
            and id_contractee in
            	 (
            	   select id
            	     from subjects_cr
            	    where id_organization = $P{P_idOrganization}
            	      and id = c.id_contractee
            	 )
       )
     and external_id in
       (
         select forminstanceid
           from dwh_scheda_presenza_lesione_decubito
          where fd_fd_sectiontre_gradoLesione_code = 'opL_2b'
            and forminstanceid = f.external_id
       )
),
(
  select count(distinct(id_person)) as "persone con lesione al terzo stadio"
    from forms f
   where id_contract in
       (
         select id
           from contracts c
          where ((valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
             or (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd')
            and (valid_to is null or NULLIF(valid_to, TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
        between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))))
            and id = f.id_contract
            and id_contractee in
            	 (
            	   select id
            	     from subjects_cr
            	    where id_organization = $P{P_idOrganization}
            	      and id = c.id_contractee
            	 )
       )
     and external_id in
       (
         select forminstanceid
           from dwh_scheda_presenza_lesione_decubito
          where fd_fd_sectiontre_gradoLesione_code = 'opL_2c'
            and forminstanceid = f.external_id
       )
),
(
  select count(distinct(id_person)) as "persone con lesione al quarto stadio"
    from forms f
   where id_contract in
       (
         select id
           from contracts c
          where ((valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
             or (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd')
            and (valid_to is null or NULLIF(valid_to, TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
        between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))))
            and id = f.id_contract
            and id_contractee in
            	 (
            	   select id
            	     from subjects_cr
            	    where id_organization = $P{P_idOrganization}
            	      and id = c.id_contractee
            	 )
       )
     and external_id in
       (
         select forminstanceid
           from dwh_scheda_presenza_lesione_decubito
          where fd_fd_sectiontre_gradoLesione_code = 'opL_2d'
            and forminstanceid = f.external_id
       )
),
(
  select count(*) as "totale lesioni da pressione"
    from forms f
   where id_contract in
       (
         select id
           from contracts c
          where (valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
             or (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd')
            and (valid_to is null or NULLIF(valid_to, TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
        between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd')))
            and id = f.id_contract
            and id_contractee in
               (
                 select id
                   from subjects_cr
                  where id_organization = $P{P_idOrganization}
                    and id = c.id_contractee
               )
       )
     and external_id in
       (
         select forminstanceid
           from dwh_scheda_presenza_lesione_decubito
          where fd_fd_sectiontre_gradoLesione_code is not null
            and forminstanceid = f.external_id
       )
),
(
  select count(distinct(id_person)) as "persone a RSA con almeno 1 lesione (i)"
    from forms f
   where id_contract in
     	 (
       	 	 select id
      		   from contracts
      		  where id_service in
      		 	    (
      		 	      select id
      		       	  from services
      		      	 where upper(name) = 'RSA'
      		 	    )
      		    and ((valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
               or (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd')
              and (valid_to is null or NULLIF(valid_to, TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
          between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))))
              and id = f.id_contract
              and id_contractee in
            	  (
            	    select id
            	      from subjects_cr
            	     where id_organization = $P{P_idOrganization}
            	       and id = c.id_contractee
            	  )
     	 )
     and external_id in
       (
         select forminstanceid
           from dwh_scheda_presenza_lesione_decubito
          where fd_fd_sectiontre_gradoLesione_code is not null
            and forminstanceid = f.external_id
       )
     and id_contract not in
       (
         select id
           from contracts c
          where valid_from between $P{P_dataDa} and '30/11/2018'
            and id_contractee in
          	  (
          	    select id
          	      from subjects_cr
          	     where id_organization = $P{P_idOrganization}
          	       and id = c.id_contractee
          	  )
       )
     and id_form_parameter in
       (
         select id
      		 from form_parameters
      		where id_service = 2
            and id = f.id_form_parameter
       )
),
(
  select count(*) as "nuovi ingressi nel periodo di riferimento"
    from contracts c
   where valid_from between $P{P_dataDa} and '30/11/2018'
     and id_contractee in
     	 (
     	   select id
     	     from subjects_cr
     	    where id_organization = $P{P_idOrganization}
     	      and id = c.id_contractee
     	 )
),
4 as "persone che hanno sviluppato lesione",
4 as "giorni effetiva presenza",
(
  select
    case
      when abs(SUM(CEIL((EXTRACT(epoch from age(valid_from, valid_to)) / 86400))::int)) is not null
      then abs(SUM(CEIL((EXTRACT(epoch from age(valid_from, valid_to)) / 86400))::int))
      else 0
    end
    as "giorni effetiva presenza"
    from contracts
    where
      valid_from between '30/09/2018' and '04/12/2018'
      and valid_to between '30/10/2018' and '04/12/2018'
),
2 as "persone con rischio di sviluppo di lesioni",
1 as "persone di basso rischio",
(
  select count(*) as "persone con 2 o più lesioni"
    from persons p
   where 1 =
   	 (
   	 	select
           case
             when count(id_person) >= 2
             then 1
             else 0
           end
      from forms f
     where id_person = p.id
       and id_contract in
       	 (
       	   select id
             from contracts c
            where ((valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
               or (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd')
              and (valid_to is null or NULLIF(valid_to, TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
          between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))))
              and id = f.id_contract
              and id_contractee in
              	 (
              	  select id
              	    from subjects_cr
              	   where id_organization = $P{P_idOrganization}
              	     and id = c.id_contractee
              	 )
       	 )
       and external_id in
         (
           select forminstanceid
             from dwh_scheda_presenza_lesione_decubito
            where
                (
                  fd_fd_sectiontre_gradoLesione_code = 'opL_2a'
                  or fd_fd_sectiontre_gradoLesione_code = 'opL_2b'
                  or fd_fd_sectiontre_gradoLesione_code = 'opL_2c'
                  or fd_fd_sectiontre_gradoLesione_code = 'opL_2d'
                )
              and forminstanceid = f.external_id
         )
   	 )
),
(
  select count(*) as "persone con 1 o più lesioni"
    from persons p
   where 1 =
     (
         select
                case
                 when count(id_person) >= 1
                 then 1
                 else 0
                end
           from forms f
          where id_person = p.id
            and id_contract in
              (
                select id
                  from contracts c
                 where ((valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
                    or (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd')
                   and (valid_to is null or NULLIF(valid_to, TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
               between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))))
                   and id = f.id_contract
                   and id_contractee in
                      (
                       select id
                         from subjects_cr
                        where id_organization = $P{P_idOrganization}
                          and id = c.id_contractee
                      )
              )
            and external_id in
              (
                select forminstanceid
                  from dwh_scheda_presenza_lesione_decubito
                 where
                     (
                       fd_fd_sectiontre_gradoLesione_code = 'opL_2a'
                       or fd_fd_sectiontre_gradoLesione_code = 'opL_2b'
                       or fd_fd_sectiontre_gradoLesione_code = 'opL_2c'
                       or fd_fd_sectiontre_gradoLesione_code = 'opL_2d'
                     )
                   and forminstanceid = f.external_id
              )
     )
),
1 as "persone con lesione, malnutrite, intervento nutrizionale (energetica - proteica)",
(
  select count(*) as "persone con lesione da pressione e malnutriti"
    from persons p
    where id in
        (
          select id_person
            from forms f
           where external_id in
               (
                 select forminstanceid
                   from schedavalutazionerischiodecubiti
                  where forminstanceid = f.external_id
               )
             and id_person = p.id
             and id_contract in
             	 (
             	   select id
                   from contracts c
                  where ((valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
                     or (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd')
                    and (valid_to is null or NULLIF(valid_to, TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
                between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))))
                    and id = f.id_contract
                    and id_contractee in
                    	(
                        select id
                    	    from subjects_cr
                    	   where id_organization = $P{P_idOrganization}
                    	     and id = c.id_contractee
                    	 )
             	 )
        )
      and id in (
        select id_person
          from forms f
         where external_id in
             (
               select forminstanceid
                 from schedamininutritionalassesment
                where
                      (fd_fd_totalescreening <= 7 and fd_fd_resultatototale = 0)
                   or
                      (fd_fd_totalescreening <= 11 and fd_fd_resultatototale <= 17)
                  and forminstanceid = f.external_id
             )
           and id_contract in
           	 (
           	   select id
                 from contracts c
                where ((valid_from between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
                   or (valid_from <= TO_DATE($P{P_dataDa}, 'YYYY-MM-dd')
                  and (valid_to is null or NULLIF(valid_to, TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))
              between TO_DATE($P{P_dataDa}, 'YYYY-MM-dd') and TO_DATE($P{P_dataFinoA}, 'YYYY-MM-dd'))))
                  and id = f.id_contract
                  and id_contractee in
                	  (
                	    select id
                	      from subjects_cr
                	     where id_organization = $P{P_idOrganization}
                	       and id = c.id_contractee
                	  )
           	 )
      )
)
