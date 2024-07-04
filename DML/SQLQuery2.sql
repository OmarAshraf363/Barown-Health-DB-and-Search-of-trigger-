--1.	SELECT: Retrieve all columns from the Doctor table.
select * from  pre.Doctor
--2.	ORDER BY: List patients in the Patient table in ascending order of their ages.
select * from pre.Patient order by pre.Patient.Age asc
--3.	OFFSET FETCH: Retrieve the first 10 patients from the Patient table, starting from the 5th record.
SELECT * 
FROM pre.Patient
order by Patient.Age
OFFSET 5 ROWS 
FETCH NEXT 10 ROWS ONLY;
--4.	SELECT TOP: Retrieve the top 5 doctors from the Doctor table.
select top (5)* from pre.Doctor 
--5.	SELECT DISTINCT: Get a list of unique address from the Patient table.
select DISTINCT Address  from pre.Patient
--6.	WHERE: Retrieve patients from the Patient table who are aged 25
select * from pre.Patient where Age=25
--7.	NULL: Retrieve patients from the Patient table whose email is not provided
select * from pre.Patient where Email is  null
--8.	AND: Retrieve doctors from the Doctor table who have experience greater than 5 years and specialize in 'Cardiology'.
select * from pre.Doctor where YearsOfExperience>5 and Specialty='eyes'
--9.	IN: Retrieve doctors from the Doctor table whose speciality is either 'Dermatology' or 'Oncology'.
select * from pre.Doctor where Specialty in ('eyes','heart')
--10.	BETWEEN: Retrieve patients from the Patient table whose ages are between 18 and 30.
select * from pre.Patient where Age between 18 and 30
--11.	LIKE: Retrieve doctors from the Doctor table whose names start with 'Dr.'.
select * from pre.Doctor where Name like 'Dr.%'
--12.	Column & Table Aliases: Select the name and email of doctors, aliasing them as 'DoctorName' and 'DoctorEmail'.
select Name as'DoctorName' , Email as 'DoctorEmail' from pre.Doctor
--13.	Joins: Retrieve all prescriptions with corresponding patient names.
select g.TradeName,pr.Date,pr.Quantity,d.Name as 'DoctorName',p.Name as'patientName' from pre.Prescription pr 
join pre.Patient p on pr.PatientID=p.URNumber 
join pre.Doctor d on d.DoctorID=pr.DoctorID 
join pre.Drug g on g.DrugID=pr.DrugID 
--14.	GROUP BY: Retrieve the count of patients grouped by their cities.
select Patient.Address ,count(Patient.URNumber) from pre.Patient
group by Patient.Address

--15.	HAVING: Retrieve cities with more than 3 patients. ==>// address
select Patient.Address ,count(Patient.URNumber) from pre.Patient
group by Patient.Address
having count(Patient.URNumber) >3

--16.	GROUPING SETS: Retrieve counts of patients grouped by cities and ages.
select Patient.Address,patient.Age ,count(Patient.URNumber) from pre.Patient
group by GROUPING sets( Patient.Address ,Patient.Age)  -- Waiting...

--17.	CUBE: Retrieve counts of patients considering all possible combinations of city and age.

select p.Address,p.Age ,COUNT(p.URNumber) from pre.Patient p
group by cube(p.Address,p.Age)
--18.	ROLLUP: Retrieve counts of patients rolled up by city.
select p.Address,count(p.URNumber) from pre.Patient p
group by ROLLUP (p.Address)
--19.	EXISTS: Retrieve patients who have at least one prescription.
select * from pre.Patient p
where exists(
select pr.PatientID , count (pr.PrescriptionID) from pre.Prescription pr where p.URNumber=pr.PatientID
group by pr.PatientID
having count(pr.PrescriptionID)>=1
)
--20.	UNION: Retrieve a combined list of doctors and patients.
select d.Name from pre.Doctor d union select p.Name from pre.Patient p

--21.	Common Table Expression (CTE): --Retrieve patients along with their doctors using a CTE
with Cta_doc_pat As (select p.Name as 'PatientName' ,d.Name as 'DoctorName'  
from pre.Patient p join pre.Patient_Doctor pd  on p.URNumber=pd.PatientID
join pre.Doctor d on d.DoctorID=pd.DoctorID)
select PatientName, DoctorName from Cta_doc_pat

--22.	INSERT: Insert a new doctor into the Doctor table.
insert into pre.Doctor(Name,Email,Phone,Specialty,YearsOfExperience) 
values('Dr.omar','omar@gmail.com','01008670957','heart',5)

--23.	INSERT Multiple Rows: Insert multiple patients into the Patient table.
insert into pre.Patient (Name,Phone,Address,Email,MedicareCard,Age)
values('Omar Ashraf','01025016330','20benhastret','omas@gmail.com','4041372831826',22),
      ('Ahmed Ashraf','01165016330','20benhastret','ahas@gmail.com','4041372815826',25)

--24.	UPDATE: Update the phone number of a doctor
update pre.Doctor set Phone='01026608752' where name='Dr.omar'
--25.	UPDATE JOIN: Update the city of patients who have a prescription from a specific doctor.
update pre.Patient set Address='banha' from pre.Patient p  join pre.Prescription pr on  pr.PatientID=p.URNumber
join pre.Doctor d on pr.DoctorID=d.DoctorID
where d.DoctorID=7
--26.	DELETE: Delete a patient from the Patient table.
delete from pre.Patient where URNumber=26
--27.	Transaction: Insert a new doctor and a patient, ensuring both operations succeed or fail together.
BEGIN TRANSACTION;
insert into pre.Patient (Name,Phone,Address,Email,MedicareCard,Age)
values('Mohamed ibrahem','01022116330','13benhastret','moib@gmail.com','4046472831826',19)

insert into pre.Doctor(Name,Email,Phone,Specialty,YearsOfExperience) 
values('Dr.Fahed','Fahed@gmail.com','01012670957','head',8)
  COMMIT;
--28.	View: Create a view that combines patient and doctor information for easy access.
 select *
 from pre.Patient p join pre.Patient_Doctor pd on p.URNumber=pd.PatientID
 join pre.Doctor d on d.DoctorID=pd.DoctorID --contain All patients that have a doctors only
 --All
 CREATE VIEW pre.Info AS
select
    p.URNumber AS PatientID,
    p.Name AS PatientName,
    p.Phone AS PatientPhone,
    p.Address AS PatientAddress,
    p.Email AS PatientEmail,
    p.MedicareCard AS PatientMedicareCard,
    p.Age AS PatientAge,
    d.DoctorID,
    d.Name AS DoctorName,
    d.Email AS DoctorEmail,
    d.Phone AS DoctorPhone,
    d.Specialty AS DoctorSpecialty,
    d.YearsOfExperience AS DoctorExperience
FROM pre.Patient p 
LEFT JOIN pre.Patient_Doctor pd ON p.URNumber = pd.PatientID
LEFT JOIN pre.Doctor d ON pd.DoctorID = d.DoctorID
select * from pre.Info
--29 CREATE [NONCLUSTERED] INDEX index_name ON table_name(column_list);
CREATE NONCLUSTERED INDEX idx_Phone
ON pre.Patient (Phone);


	


