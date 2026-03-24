CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    patient_name VARCHAR(50),
    gender VARCHAR(10),
    city VARCHAR(50)
);

CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    doctor_name VARCHAR(50),
    specialization VARCHAR(50)
);

CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    fee INT,

    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE treatments (
    treatment_id SERIAL PRIMARY KEY,
    appointment_id INT,
    treatment_name VARCHAR(50),
    cost INT,

    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);


INSERT INTO patients (patient_name, gender, city) VALUES
('Ali Khan', 'Male', 'Karachi'),
('Sara Ahmed', 'Female', 'Lahore'),
('Usman Tariq', 'Male', 'Karachi'),
('Ayesha Noor', 'Female', 'Islamabad');

INSERT INTO doctors (doctor_name, specialization) VALUES
('Dr. Asif', 'Cardiologist'),
('Dr. Sana', 'Dermatologist'),
('Dr. Ahmed', 'Neurologist');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, fee) VALUES
(1, 1, '2024-01-10', 3000),
(2, 2, '2024-01-12', 2000),
(1, 3, '2024-02-01', 4000),
(3, 1, '2024-02-10', 3500),
(4, 2, '2024-02-15', 2500);

INSERT INTO treatments (appointment_id, treatment_name, cost) VALUES
(1, 'ECG', 1500),
(2, 'Skin Therapy', 1000),
(3, 'MRI', 5000),
(4, 'Heart Checkup', 2000),
(5, 'Facial Treatment', 1200);





-- TASK 11:
-- Patients from KArachi

SELECT *
FROM patients
WHERE city = 'Karachi';

-- TASK 12:
-- Running total per patient

SELECT patient_id,appointment_date,fee,
SUM(fee) OVER(PARTITION BY patient_id
ORDER BY appointment_date) AS running_total
FROM appointments;


-- TASK 13:
-- Avg treatment cost per doctor

SELECT d.doctor_name,
ROUND(AVG(t.cost),2) AS avg_cost
FROM doctors d
JOIN appointments a
ON d.doctor_id = a.doctor_id
JOIN treatments t
ON a.appointment_id = t.appointment_id
GROUP BY d.doctor_name
ORDER BY avg_cost DESC;


-- TASK 14:
-- Top 2 patients by spending

WITH spending AS (
SELECT p.patient_id,p.patient_name,
SUM(a.fee + t.cost) AS total_spent
FROM patients p
JOIN appointments a
ON p.patient_id = a.patient_id
JOIN treatments t
ON a.appointment_id = t.appointment_id
GROUP BY p.patient_id,p.patient_name
)

SELECT *,
RANK() OVER(ORDER BY total_spent DESC) AS rank
FROM spending
WHERE total_spent IS NOT NULL
LIMIT 2;
