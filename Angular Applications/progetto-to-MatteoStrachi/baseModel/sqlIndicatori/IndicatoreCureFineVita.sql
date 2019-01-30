select (
  select count(*) as "persone decedute RSA"
    from persons p
    join contracts c on c.id_contractee = p.id
    join services s on s.id = c.id_service and upper(s.name) = 'RSA'
    where p.fl_patient = true
      and s.id_organization = 2
      and p.date_of_death is not null
),(
  select count(*) as "persone decedute"
    from persons p
    join contracts c on c.id_contractee = p.id
    join services s on s.id = c.id_service
    where p.fl_patient = true
      and s.id_organization = 2
      and p.date_of_death between '01-11-2017' and '21-11-2018'
),(
  select count(*) as "persone in fine vita e decedute RSA a periodo"
    from persons p
    join contracts c on c.id_contractee = p.id
    join services s on s.id = c.id_service and upper(s.name) = 'RSA'
    where p.fl_patient = true
      and s.id_organization = 2
      and (
            p.date_of_death between '01-11-2017' and '21-11-2018'
            or p.id in
            (select id_person from forms where external_id in (select forminstanceid from dwh_schedasegnimorteimminente))
          )
),(
  select count(*) as "persone in fine vita e decedute a periodo"
    from persons p
    join contracts c on c.id_contractee = p.id
    join services s on s.id = c.id_service
    where p.fl_patient = true
      and s.id_organization = 2
      and (
            p.date_of_death between '01-11-2017' and '21-11-2018'
            or p.id in (select id_person from forms where external_id in (select forminstanceid from dwh_schedasegnimorteimminente))
          )
),(
  select count(distinct(id)) as "PAI anticipati, accompagnamento del morente"
    from persons
    where id in (select id_person from pais) -- NOTE: (punto 4.3) "se le PAI se danno per diversi motivi, come so che sono essatamente per il accompagnamento del morente ? "
      and date_of_death is null
),(
  select count(distinct(id)) as "PAI anticipati, accompagnamento del morente condivisi con familiari/cari"
    from persons
    where id in (select id_person from pais) -- NOTE: (punto 4.4) "se le PAI se danno per diversi motivi, come so che sono essatamente per il accompagnamento del morente è condivissa con i familiari? "
      and date_of_death is null
),(
  select 1 as "persone in fine vita e decedute, rielaborati e discussi, a periodo" -- NOTE: (punto 4.5) "𝑁𝑢𝑚𝑒𝑟𝑜 𝑐𝑎𝑠𝑖 (𝑑𝑖 𝑝𝑒𝑟𝑠𝑜𝑛𝑒 𝑖𝑛 𝑓𝑖𝑛𝑒 𝑣𝑖𝑡𝑎 𝑒 𝑑𝑒𝑐𝑒𝑑𝑢𝑡𝑒) 𝑟𝑖𝑒𝑙𝑎𝑏𝑜𝑟𝑎𝑡𝑖 𝑒 𝑑𝑖𝑠𝑐𝑢𝑠𝑠𝑖 𝑖𝑛 𝑒𝑞𝑢𝑖𝑝𝑒 𝑛𝑒𝑙 𝑝𝑒𝑟𝑖𝑜𝑑𝑜 𝑑𝑖 𝑟𝑖𝑓𝑒𝑟𝑖𝑚𝑒𝑛𝑡𝑜?"
),(
  select count(*) as "persone in fine vita e decedute a periodo, ma del messe prima" -- NOTE: (punto 4.5)
    from persons p
    join contracts c on c.id_contractee = p.id
    join services s on s.id = c.id_service
    where p.fl_patient = true
      and s.id_organization = 2
      and (
            p.date_of_death between '01-11-2017' and '21-11-2018'
            or p.id in (select id_person from forms where external_id in (select forminstanceid from dwh_schedasegnimorteimminente))
          )
)
