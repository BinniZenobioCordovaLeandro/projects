-- "persone presenti"
select count(*) as "persone presenti"
	from persons p
	join contracts c on c.id_contractee = p.id
	join services s on s.id = c.id_service and upper(s.name) = 'RSA'
	where p.fl_patient = true
		and s.id_organization = 1
		and (c.valid_from between '10-10-2017' and '10-10-2018')
		or (c.valid_from <= '10-10-2017'
		and (c.valid_to is null or NULLIF(c.valid_to, '10-10-2018') between '10-10-2017' and '10-10-2018'))

-- "persone con dolore - NRS"
select count(distinct(id_person)) as "persone con dolore - NRS"
			from forms
			where external_id in (
					select forminstanceid
						from dwh_pqrst
						where (
							fd_fd_scoretot::float>=4 and fd_fd_scoretot::float<=6
						)
				)
				and id_contract in (
					select id
					from contracts
						where
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2017' or valid_to is null))
							or
							(valid_from <= '10-10-2018' and (valid_to >= '10-10-2018' or valid_to is null))
							or
							(valid_from >= '10-10-2017' and (valid_to <= '10-10-2018' or valid_to is null))
							or
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2018' or valid_to is null))
				)
			and id_form_parameter in (select id from form_parameters where id_organization = 1)
			and id_person is not null

-- "persone con dolore - PAINAD"
select count(distinct(id_person)) as "persone con dolore - PAINAD"
			from forms
			where external_id in (
					select forminstanceid
						from dwh_pqrst
						where (
							fd_fd_scoretotale is not null
						)
				)
				and id_contract in (
					select id
					from contracts
						where
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2017' or valid_to is null))
							or
							(valid_from <= '10-10-2018' and (valid_to >= '10-10-2018' or valid_to is null))
							or
							(valid_from >= '10-10-2017' and (valid_to <= '10-10-2018' or valid_to is null))
							or
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2018' or valid_to is null))
				)
			and id_form_parameter in (select id from form_parameters where id_organization = 1)
			and id_person is not null

-- "persone con dolore moderato - NRS"
select count(distinct(id_person)) as "persone con dolore moderato - NRS"
				from forms
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
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2017' or valid_to is null))
							or
							(valid_from <= '10-10-2018' and (valid_to >= '10-10-2018' or valid_to is null))
							or
							(valid_from >= '10-10-2017' and (valid_to <= '10-10-2018' or valid_to is null))
							or
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2018' or valid_to is null))
				)
				and id_form_parameter in (select id from form_parameters where id_organization = 1)
				and id_person is not null

-- "persone con dolore moderato - PAINAD"
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
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2017' or valid_to is null))
							or
							(valid_from <= '10-10-2018' and (valid_to >= '10-10-2018' or valid_to is null))
							or
							(valid_from >= '10-10-2017' and (valid_to <= '10-10-2018' or valid_to is null))
							or
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2018' or valid_to is null))
				)
				and id_form_parameter in (select id from form_parameters where id_organization = 1)
				and id_person is not null

-- "persone con dolore severo - NRS"
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
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2017' or valid_to is null))
							or
							(valid_from <= '10-10-2018' and (valid_to >= '10-10-2018' or valid_to is null))
							or
							(valid_from >= '10-10-2017' and (valid_to <= '10-10-2018' or valid_to is null))
							or
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2018' or valid_to is null))
					)
				and id_form_parameter in (select id from form_parameters where id_organization = 1)
				and id_person is not null

-- "persone con dolore severo - PAINAD"
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
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2017' or valid_to is null))
							or
							(valid_from <= '10-10-2018' and (valid_to >= '10-10-2018' or valid_to is null))
							or
							(valid_from >= '10-10-2017' and (valid_to <= '10-10-2018' or valid_to is null))
							or
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2018' or valid_to is null))
				)
			and id_form_parameter in (select id from form_parameters where id_organization = 1)
			and id_person is not null

-- "persone dolore moderato o severo, tratati 60min - NRS"
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
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2017' or valid_to is null))
							or
							(valid_from <= '10-10-2018' and (valid_to >= '10-10-2018' or valid_to is null))
							or
							(valid_from >= '10-10-2017' and (valid_to <= '10-10-2018' or valid_to is null))
							or
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2018' or valid_to is null))
				)
				and id_form_parameter in (select id from form_parameters where id_organization = 1)
				and id_person is not null

-- "persone dolore moderato o severo, tratati 60min - PAINAD"
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
						(valid_from <= '10-10-2017' and (valid_to >= '10-10-2017' or valid_to is null))
						or
						(valid_from <= '10-10-2018' and (valid_to >= '10-10-2018' or valid_to is null))
						or
						(valid_from >= '10-10-2017' and (valid_to <= '10-10-2018' or valid_to is null))
						or
						(valid_from <= '10-10-2017' and (valid_to >= '10-10-2018' or valid_to is null))
			)
			and id_form_parameter in (select id from form_parameters where id_organization = 1)
			and id_person is not null

				10 as "persone dolore moderato o severo, rivalutazione 60min",
				11 as "persone dolore moderato o severo, trattati",
				12 as "persone dolore moderato o severo, senza terapia in atto / terapia inefficace, valutazione medica entro 48ore da rilevazione",

-- "persone dolore moderato o severo - NRS"
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
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2017' or valid_to is null))
							or
							(valid_from <= '10-10-2018' and (valid_to >= '10-10-2018' or valid_to is null))
							or
							(valid_from >= '10-10-2017' and (valid_to <= '10-10-2018' or valid_to is null))
							or
							(valid_from <= '10-10-2017' and (valid_to >= '10-10-2018' or valid_to is null))
				)
				and id_form_parameter in (select id from form_parameters where id_organization = 1)
				and id_person is not null

-- "persone dolore moderato o severo - PAINAD"
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
						(valid_from <= '10-10-2017' and (valid_to >= '10-10-2017' or valid_to is null))
						or
						(valid_from <= '10-10-2018' and (valid_to >= '10-10-2018' or valid_to is null))
						or
						(valid_from >= '10-10-2017' and (valid_to <= '10-10-2018' or valid_to is null))
						or
						(valid_from <= '10-10-2017' and (valid_to >= '10-10-2018' or valid_to is null))
			)
			and id_form_parameter in (select id from form_parameters where id_organization = 1)
			and id_person is not null

select 14 as "persone terapia oppioide associata a lassativo",
select 15 as "persone terapia oppioidi",
select 16 as "persone valutate, presenza dolore, scala periodo riferimento",
select 17 as "persone periodo riferimento",

-- "persone valutate almeno una volta, nel periodo di due settimane"
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
	and id_form_parameter in (select id from form_parameters where id_organization = 1)
	and id_contract in (
		select id
		from contracts
			where
				(valid_from <= '10-10-2017' and (valid_to >= '10-10-2017' or valid_to is null))
				or
				(valid_from <= '10-10-2018' and (valid_to >= '10-10-2018' or valid_to is null))
				or
				(valid_from >= '10-10-2017' and (valid_to <= '10-10-2018' or valid_to is null))
				or
				(valid_from <= '10-10-2017' and (valid_to >= '10-10-2018' or valid_to is null))
	)
	and id_person is not null
