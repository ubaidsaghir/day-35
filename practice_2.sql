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


-- TASK 6:
-- Monthly hospital earnings (CTE)

WITH monthly AS(
SELECT DATE_TRUNC('month', appointment_date) AS month,
SUM(fee) AS total_fee
FROM appointments
GROUP BY month
)
SELECT *
FROM monthly
ORDER BY total_fee DESC;


-- TASK 7:
-- Highest earning doctor per specialization


WITH doc_rev AS(
SELECT d.doctor_name,d.specialization,
SUM(fee) AS revenue
FROM doctors d
JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name,d.specialization
)
SELECT *,
RANK() OVER(PARTITION BY specialization
ORDER BY revenue DESC) AS rank
FROM doc_rev;


-- TASK 8:
-- Patients spending between 3000-10000

SELECT p.patient_name,
SUM(a.fee + t.cost) AS total_spent 
FROM patients p
JOIN appointments a
ON p.patient_id = a.patient_id
JOIN treatments t
ON a.appointment_id = t.appointment_id
GROUP BY p.patient_name
HAVING SUM(a.fee + t.cost) BETWEEN 3000 AND 10000
ORDER BY total_spent DESC;


-- TASK 9:
-- Treatment revenue

SELECT treatment_name,
SUM(cost) AS total
FROM treatments
GROUP BY treatment_name
ORDER BY total DESC;




-- TASK 10:
-- EXTRACT first name

SELECT patient_name,
SPLIT_PART(patient_name, ' ',1) AS first_name
FROM patients;


