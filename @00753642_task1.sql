create database Hospital_DB

--user_login
create table user_login (
user_id integer identity(1,1) primary key, 
uname nvarchar(100),
user_name as uname + '_' + cast(user_id as varchar(10)),
PasswordHash binary(64) NOT NULL,
Salt uniqueidentifier
)

--Create procedure for login
create procedure proc_AddUser @uname nvarchar(50), @password nvarchar(50)
as
declare @salt uniqueidentifier= newid()
insert into user_login (uname, passwordHash, salt)
values(@uname, hashbytes('SHA2_512',
@password+cast(@salt as nvarchar(36))), @salt);

Execute proc_AddUser @uname = 'sara_ahmad', @password='scw12w';
Execute proc_AddUser @uname = 'shakeel_arshad', @password='lmn6547';
Execute proc_AddUser @uname = 'sai_raguri', @password='sai1204';
Execute proc_AddUser @uname = 'Maryyam_Ali', @password='tld12mnh';
Execute proc_AddUser @uname = 'donna_dale', @password='donna678';
Execute proc_AddUser @uname = 'jingi_mao', @password='123789';
Execute proc_AddUser @uname = 'tom_thomas', @password='thomas@20';
Execute proc_AddUser @uname = 'hadi_adeel', @password='abc456';
Execute proc_AddUser @uname = 'adam_sanderson', @password='sand1284';
Execute proc_AddUser @uname = 'mahboob_ahmad', @password='mahboob43';
Execute proc_AddUser @uname = 'roy_guri', @password='roy@78';
Execute proc_AddUser @uname = 'adeel_arshad', @password='209876';
Execute proc_AddUser @uname = 'fara_bhatti', @password='bhatti@07';

--Patient Table
create table patient(
pat_id integer identity(1,1) primary key,
user_id int not null foreign key references user_login(user_id),
first_name nvarchar(50) not null,
last_name nvarchar(50) not null,
gender varchar(20) ,
dob date not null,
address nvarchar(50) not null,
postcode nvarchar(10) not null,
city nvarchar(50) not null,
insurance nvarchar(20) not null,
phone nvarchar(20) ,
email nvarchar(50) 
)

--Depertment Table
create table department(
dep_id integer identity(1,1) primary key,
dep_name nvarchar(250) not null,
phone_number nvarchar(20) not null,
)

--Doctor Table
create table doctor(
doc_id integer identity(1,1) primary key,
dep_id int not null foreign key references department(dep_id),
first_name nvarchar(50) not null,
last_name nvarchar(50) not null,
gender varchar(20)  not null,
specialization nvarchar(200) not null,
phone_number nvarchar(20)  not null,
)

--Doctor_availability Table
create table doctor_availability(
ava_id integer identity(1,1) primary key,
doc_id int not null foreign key references doctor(doc_id),
app_status bit not null
)

--Appointment_status Table
create table appointment_status(
status_id integer identity(1,1) primary key,
status_name nvarchar(10) not null 
)

--Appointment Table
create table appointment(
app_id integer identity(1,1) primary key,
pat_id int not null foreign key references patient(pat_id),
doc_id int not null foreign key references doctor(doc_id),
app_date date default convert(date, getdate()),
app_time time not null,
app_status int not null foreign key references appointment_status(status_id) 
)

--Past_appointment Table
create table past_appointment(
app_id integer identity(1,1) primary key,
pat_id int not null foreign key references patient(pat_id),
doc_id int not null foreign key references doctor(doc_id),
app_date date default convert(date, getdate()),
app_time time not null,
app_status int not null foreign key references appointment_status(status_id) 
)

--Medical_History
create table medical_history(
mh_id integer identity(1,1) primary key,
pat_id int not null foreign key references patient(pat_id),
diagnosis nvarchar(max) not null,
medicine nvarchar(max) not null,
allergies nvarchar(max) not null,
prescribed_date date not null
)

--Patient_review Table
create table patient_review(
rev_id integer identity(1,1) primary key,
app_id int not null foreign key references appointment(app_id),
review nvarchar(max) null
)

-- Appointment_Archive Table
create table appointment_archive(
app_id int not null,
pat_id int not null ,
doc_id int not null ,
app_date date ,
app_time time not null,
app_status int not null 
)

 --Patient_Archive Table
 create table patient_archive(
pat_id int not null,
user_id int not null,
first_name nvarchar(50) not null,
last_name nvarchar(50) not null,
gender varchar(20) ,
dob date not null,
address nvarchar(50) not null,
postcode nvarchar(10) not null,
city nvarchar(50) not null,
insurance nvarchar(20) not null,
phone nvarchar(20) ,
email nvarchar(50) 
)

--Patient Table Values
insert into patient(user_id,first_name,last_name,gender,dob,address,postcode,city, insurance,phone,email)
values
(1,	'Sarah',	'Ahmad',	'F',	'1979-05-08',	'2 OakHurst Garden, Prestwich',	'M25 1JQ',	'Manchester',	'ABC78975',	'0161 772233',	'saraAhmad12@gmail.com'),	
(2,	'Shakeel',	'Arshad',	'M',	'1974-08-29',	'10 Solness Street, Bury',	'BL9 6PP',	'Manchester',	'CDC11223',	null,	'shakeel787@hotmail.com'),	
(3,	'Sai',	'Raguri',	'F',	'1950-10-10',	'11 Crumpsall Lane,Crumpsall',	'M8 5SR',	'Manchester',	'AMA21212',	null,	null ),	
(4,	'Maryyam',	'Ali',	'F',	'1985-06-02',	'27 Walmersley Road, Bury',	'BL9 7PL',	'Manchester',	'XYZ413431',	'161234567'	,Null),	
(5,	'Donna'	,'Dale',	'F',	'1990-11-06',	'5 Mosley Avenue,Bury',	'BL9 6PQ',	'Manchester',	'IJK45678',	'161786934',	Null),	
(6,	'Jingi',	'Mao',	'F',	'2008-03-20',	'52 Noris Road,Sale',	'M33 3JR',	'Manchester'	,'HTC23456'	,Null	,Null),	
(7,	'Tom',	'Thomas',	'M',	'2000-07-15',	'8 Mount Road, Gorton',	'M18 7GR',	'Manchester'	,'LIM67895'	,Null	,Null	),
(8,	'Hadi',	'Adeel',	'M',	'2010-07-27',	'66 Hays Road, Prestwich',	'M25 1JZ',	'Manchester'	,'DRV56743'	,Null, Null	),
(9,	'Adam',	'Sanderson',	'M'	,'1952-06-06',	'32 Haliwell Lane, Cheetham Hill',	'M8 9FR',	'Manchester',	'SAD34567',	'161567875'	,'adamSnderson12@gmail.com'),	
(10,'Mahboob',	'Ahmad',	'M',	'1943-08-31',	'12 Solness Street, Bury',	'BL9 6PT',	'Manchester',	'CDE07896',	'161345678',	'Mahboob43@yahoo.co.uk'),	
(11,'Roy',	'Guri',	'M',	'1960-12-29',	'3 Laurel Street, Tottington',	'BL8 3LY',	'Manchester',	'BGT24680',	'161675432',	'RoyR34@yahoo.co.uk'),	
(12,'Adeel',	'Arshad',	'M',	'1975-12-02',	'11 OakLane, Sale',	'M33 3LJ',	'Manchester',	'ALM098765',	Null,	Null),	
(13,'Fara',	'Bhatti',	'F',	'1976-03-27',	'12 Hockey Street, Bury',	'BL6 9UL',	'Manchester',	'SDC234678',	Null,	Null)	

--Department Table Values
insert into department(dep_name,phone_number)
values('Emergency Unit','0161 6240420'),	
('IntensiveCare Unit','0161 6240421'),	
('X-ray Unit','0161 6240422'),	
('Physiotherapy Unit','0161 6240422'	),
('Urology Unit',	'0161 6240423'),
('Oncology Unit','0161 6240424'),	
('Cardiology Unit',	'0161 6240425'),	
('Gastroenterology',	'0161 6240426'),	
('Gynecology Unit',	'0161 6240427'),	
('Maternity Unit',	'0161 6240428'),	
('Nephrology Unit',	'0161 6240429')

--Doctor Table Values
insert into doctor(dep_id,first_name,last_name,gender,specialization,phone_number)
values
(1	,'John',	'Smith',	'M',	'General Medicine',	'7868175589'),
(9	,'Ali',	'Haq',	'M',	'Gastroenterologist',	'7900906025'),
(3	,'Michael',	'Williams',	'M',	'General Medicine',	'7234560789'),
(4	,'Ameer',	'Ahmad',	'M',	'General Medicine',	'7894563122'),
(5	,'Robert',	'Brown',	'M',	'Cardiologist',	'7456879234'),
(6	,'Alice',	'Miller',	'F',	'Oncologist',	'7648923678'),
(7	,'Irfan',	'Rasool',	'M',  'Nephrologist',	'7676897645'),
(8	,'Jane',	'Johnson',	'F',	'Radiographer','7343434561'),
(9	,'Sarah',	'Ali',	'F', 'Gynaecologist',	'7654328912'),
(10,'Emily',	'Davis',	'F',	'General Medicine',	'7890123456'),
(11,'Amal',	'Smith',	'F',	'Physiotherapist',	'7654389012')

--Doctor_availability Table Values
insert into doctor_availibility( doc_id, app_status)
values(1,	1),
(2,	1),
(3,	1),
(4,	1),
(5,	1),
(6,	1),
(7,	1),
(8,	1),
(9,	1),
(10,  1),
(11,  1)

--Appointment_status Table Values
insert into appointment_status(status_name)
values
('completed'),
('pending'),
('cancelled'),
('available')

--Appointment Table Values
insert into appointment(pat_id,doc_id,app_date,app_time,app_status)
values
(10,7,'2024-04-19','11:30:00',2),
(2,1,	'2024-06-15','10:00:00',2),
(6,2,	'2024-05-06','12:00:00',2),
(3,6,	'2024-05-11','09:30:00',3),
(4,3,	'2024-05-12','10:30:00',2),
(10,7,'2024-05-12','11:30:00',2),
(1, 9,'2024-05-12','13:00:00',2),
(7,4,	'2024-05-16','12:00:00',2),
(5,11,'2024-05-17','09:00:00',2),
(9,5,	'2024-05-17','10:30:00',2),
(8,8,	'2024-08-12','13:30:00',2),
(11,6,'2024-07-12','15:30:00',2),
(10,5,'2024-06-06','14:00:00',2),
(10,5,'2024-06-12','15:00:00',2),
(1,4,	'2024-06-12','15:00:00',3),
(10,7,'2024-05-19','11:30:00',2)

--Past_appointment Table Values
insert into past_appointment(pat_id,doc_id,app_date,app_time,app_status)
values
(2, 2,'2024-02-04','12:00:00',1),
(8,6,'2024-03-06','14:00:00',1),
(10,5,'2024-02-12','15:00:00',1),
(1,4,	'2023-12-12','15:00:00',1)

--Medical_History Table Values
insert into medical_history(pat_id,diagnosis,medicine,allergies,prescribed_date)
values
(2,'Bloating and Heartburn','Gaviscon','Null','2022-12-12'),
(6,'Throat Infection','Macrolides','Penicllin','2023-05-10'),
(3,'Lung Cancer','Docetaxel','Null','2023-06-06'),
(4,'Eczema','Eczema Cream','Null','2022-12-11'),
(1,'Pregnant','Folic Acid','Null','2023-11-12'),
(7,'Urinary Infection','Nitofurantoin','Null','2022-09-18'),
(5,'Arthiritis','Naproxen Sodium','Null','2022-11-09'),
(9,'Heart Blockage','Loprin','Null','2020-11-11'),
(8,'Facture','Null','Nut','2023-12-10'),
(11,'Blood Cancer','Arsenic Trioxide','Null','2021-09-01'),
(10,'Heart Blockage','Loprin','Haprin','2023-07-25'),
(10,'Kidney Stone','Farxiga','Haprin','2023-10-04'),
(4,'High Fever','Paracetamol','Null','2023-12-11'),
(1,'Body Rash','Piriton','Null','2024-02-15'),
(3,'Lung Cancer','Chemotherapy','Null','2023-12-06'),
(2,'High Blood Pressure','Ramipril','Null','2023-12-06'),
(7,'Migraine',	'Sumatriptan','Null','2023-04-03'),
(6,'Stomach Ulcer','Omeprazol','Penicllin','2024-03-12'),
(9,'Diabetes','Metformin','Null','2023-08-17'),
(10,'High Fever','Ibuprofen','Haprin','2024-01-10'),
(8,'Ear Infection','Tylenol Drops','Nut','2024-01-24')

--Patient_review Table Values
insert into patient_review(app_id,review)
values
(3,'Mr. Miller was wonderful throughout all my appointments, surgery and follow ups'),
(7,Null),
(1,'I have to wait too long for the doctor.'),
(10,Null),
(8,'Doctor was very supportive.He explained the future treatment.'),
(4,Null),
(5,'Dr.Irfan and his team took good care of me  during the Dialysis.'),
(9,'Feeling Positive about my heart Surgery.'),
(2,'Would definitely recommend him.'),
(6,Null),
(11,Null)

--Appointment_archive Table Values
insert into appointment_archive(app_id,pat_id,doc_id,app_date,app_time,app_status)

 --Patient_archive Table Values
insert into patient_archive(pat_id,user_id,first_name,last_name,gender,dob,address,postcode,city,
insurance,phone,email)

--PART 2
--Q2)Add the constraint to check that the appointment date is not in the past
alter table appointment add constraint cons_appointdate_past check (app_date >= getdate())

select * from appointment where app_date >= GETDATE()

--Q3) patient older than 40 and have cancer in diagnosis
select distinct p.first_name, p.last_name,p.dob,mh.diagnosis ,
datediff(year,DOB,getdate()) as age 
from patient p inner join Medical_History mh
on p.Pat_ID=mh.Pat_ID where datediff(year,DOB,getdate())>40  and
mh.Diagnosis like '%cancer%'

--Q4a) Procedure
create procedure FindPrescribedMedicine @Med nvarchar(100)
as
begin
select medicine,prescribed_date from Medical_History 
where medicine like @Med+'%'
order by prescribed_date desc
end

exec FindPrescribedMedicine @Med= 'p%'
exec FindPrescribedMedicine @Med= '%p%'

--Q4b) Function
create function MedRec(@patId int)
returns table as
return(
select a.pat_id,mh.diagnosis, mh.allergies from appointment a 
 join Medical_History mh
on a.Pat_ID=mh.Pat_ID
where mh.pat_id=@patId 
And a.app_date = convert(date, getdate())
)
select * from MedRec('10')

--Q4c)Update Doctor Details

update Doctor 
set last_name =  'Jones'
where doc_id= 10

-- Q4d)Trigger for deleted appointment
create trigger deleted_app
on past_appointment after delete
As begin
insert into appointment_archive(app_id,pat_id,doc_id,app_date,app_time,app_status)
select d.app_id,d.pat_id,d.doc_id,d.app_date,d.app_time,d.app_status
from deleted d
end;

--Q5)create view management
create view management
( dep_name,  doc_first_name, doc_last_name,specialization, current_appointment,
curretn_app_time , past_appointment, past_app_time, review)
As select dp.dep_name, doc.first_name as doc_first_name,doc.last_name as doc_last_name,
doc.specialization, a.app_date as current_appointment,a.app_time as curretn_app_time ,
aa.app_date as past_appointment, aa.app_time as past_app_time,r.review
from department dp inner join doctor doc
on dp.dep_id = doc.dep_id inner join appointment a
on doc.doc_id = a.doc_id  left join Appointment_Archive aa
on doc.doc_id= aa.doc_id  left join patient_review r
on aa.app_id = r.app_id 
where a.app_status <> 3 and a.app_status <> 4

select* from management

--Q6) trigger for cancelled appointment
create trigger trig_cancelled_appt_status
on appointment
after update
as
begin
    if update(app_status)  -- Check if app_status column is updated
    begin
     update a
        set a.app_status = 4
        from appointment a
        inner join inserted i ON a.app_id = i.app_id
        where i.app_status = 3;  -- Update appointment status to 'available' when it's cancelled
    end
end;

--Q7) completed appointments with the specialty of doctors as ‘Gastroenterologists
select doc.first_name, doc.last_name,doc.specialization,aa.app_date,ast.status_name
from doctor doc inner join Appointment_Archive aa
on doc.doc_id= aa.doc_id inner join appointment_status ast
on aa.app_status =ast.status_id
where specialization= 'gastroenterologist'
 
 --Extra Query
-- Trigger for deleted-patient
create trigger deleted_pat
ON patient after delete
As begin
insert into patient_archive(pat_id,user_id,first_name,last_name,gender,dob,address,postcode,city,
insurance,phone,email)
select d.pat_id,d.user_id,d.first_name,d.last_name,d.gender,d.dob,d.address,d.postcode,d.city,
d.insurance,d.phone,d.email
from deleted d
end;

--Apply trigger for patient
delete from patient where pat_id=13
select* from patient
select * from patient_archive

