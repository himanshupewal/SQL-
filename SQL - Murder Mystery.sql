-- The solution to the murder mystery on https://mystery.knightlab.com/
-- The story: 
--  A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City​. Start by retrieving the corresponding crime scene report from the police department’s database.

SELECT * 
from crime_scene_report
where date = 20180115 and city = "SQL City" and type="murder" 

-- Security footage shows that there were 2 witnesses. 
-- The first witness lives at the last house on "Northwestern Dr".
-- The second witness, named Annabel, lives somewhere on "Franklin Ave".


  
SELECT name,address_number,id
from person 
where address_street_name = "Northwestern Dr" 
ORDER BY address_number DESC limit 1

-- 14887	Morty Schapiro   

SELECT id,name,license_id,address_number
from person 
where address_street_name = "Franklin Ave" AND name LIKE'Annabel%' 
  
---Annabel Miller


--either we can track transcript by this  Query or We can join to get the table which will give more insights directly
SELECT transcript 
from interview 
where person_id = '16371'
--I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".

SELECT transcript 
from interview 
where person_id = '14887' 
--I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.


------------------------------------
/*joining table to get ,a right idea*/
------------------------------------

SELECT p.name,i.transcript 
from person p 
left join interview i on p.id = i.person_id
where p.name = "Morty Schapiro" or p.name = 'Annabel Miller'

---Morty Schapiro---	I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".
---Annabel Miller---	I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.


-- Let's follow the first clue()
SELECT person_id,id,membership_status from get_fit_now_member
where membership_status ="gold"  AND id like '48Z%' ----name -- Jeremy Bowers person, id = 67318(according to Morty)

              

SELECT gm.person_id,p.name,gm.id ,dl.plate_number
from person as p
join get_fit_now_member as gm  on p.id = gm.person_id
join drivers_license as dl  on p.license_id = dl.id
where gm.membership_status ="gold" and gm.id like "48Z%" and dl.plate_number like "%H42W%"

-- There is the murderer and the site confirms it:
-- But - first listen to the Jeremy Bowers transcript.

SELECT p.name,i.transcript ,i.person_id
from person p 
left join interview i on p.id = i.person_id
where p.name = "Jeremy Bowers"*

---Jeremy Bowers 67318 	I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.



SELECT p.name,dl.car_make,dl.car_model  FROM drivers_license dl
join person p on dl.id = p.license_id
join facebook_event_checkin fc on p.id = fc.person_id
where dl.height between 65 and 67 
and dl.hair_color = "red" 
and gender = "female"
and dl.car_make = 'Tesla' 
and dl.car_model = 'Model S' 
and fc.event_name = "SQL Symphony Concert" 
group by person_id having count(p.name)>=3

---------------------------------(Miranda Priestly)-----------------
--Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!
