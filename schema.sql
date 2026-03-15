CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

-- ─────────────────────────────────────────
-- TABLE: patients
-- ─────────────────────────────────────────
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    phone VARCHAR(15)
);

-- ─────────────────────────────────────────
-- TABLE: doctors
-- ─────────────────────────────────────────
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    specialization VARCHAR(100)
);

-- ─────────────────────────────────────────
-- TABLE: appointments
-- ─────────────────────────────────────────
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    status VARCHAR(20),

    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- ─────────────────────────────────────────
-- TABLE: treatment_records
-- ─────────────────────────────────────────
CREATE TABLE treatment_records (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    diagnosis TEXT,
    prescription TEXT,
    notes TEXT,

    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- ─────────────────────────────────────────
-- TABLE: users
-- ─────────────────────────────────────────
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    password VARCHAR(50),
    role VARCHAR(20)
);

-- ─────────────────────────────────────────
-- TABLE: diagnosis_master
-- ─────────────────────────────────────────
CREATE TABLE diagnosis_master (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    diagnosis_name VARCHAR(100)
);

-- ─────────────────────────────────────────
-- TABLE: treatment_master
-- ─────────────────────────────────────────
CREATE TABLE treatment_master (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    diagnosis_name VARCHAR(100),
    treatment_name VARCHAR(100)
);

-- ─────────────────────────────────────────
-- ALTER TABLES  (must run BEFORE inserting data)
-- ─────────────────────────────────────────
ALTER TABLE appointments ADD COLUMN date DATE;
ALTER TABLE doctors      ADD COLUMN phone VARCHAR(15);
ALTER TABLE appointments ADD COLUMN appointment_time TIME;

-- ─────────────────────────────────────────
-- SETTINGS
-- ─────────────────────────────────────────
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE doctors  AUTO_INCREMENT = 2600;
ALTER TABLE patients AUTO_INCREMENT = 5000;

-- ─────────────────────────────────────────
-- DATA: diagnosis_master
-- ─────────────────────────────────────────
INSERT INTO diagnosis_master (diagnosis_name) VALUES
('Hypertension'),
('Coronary Artery Disease'),
('Arrhythmia'),
('Acne'),
('Skin Allergy'),
('Dermatitis'),
('Migraine'),
('Epilepsy'),
('Stroke'),
('Fracture'),
('Back Pain'),
('Arthritis'),
('Common Cold'),
('Chickenpox'),
('Pediatric Fever'),
('PCOS'),
('Pregnancy Checkup'),
('Menstrual Disorder'),
('Depression'),
('Anxiety Disorder'),
('Insomnia'),
('Viral Fever'),
('Typhoid'),
('Gastritis');

-- ─────────────────────────────────────────
-- DATA: treatment_master
-- ─────────────────────────────────────────
INSERT INTO treatment_master (diagnosis_name, treatment_name) VALUES
('Hypertension',            'Blood Pressure Medication'),
('Hypertension',            'Low Salt Diet'),
('Coronary Artery Disease', 'Angioplasty'),
('Coronary Artery Disease', 'Beta Blockers'),
('Arrhythmia',              'Pacemaker'),
('Arrhythmia',              'Anti-arrhythmic Medication'),
('Acne',                    'Topical Cream'),
('Acne',                    'Oral Antibiotics'),
('Skin Allergy',            'Antihistamines'),
('Skin Allergy',            'Skin Cream'),
('Dermatitis',              'Steroid Cream'),
('Dermatitis',              'Moisturizer Therapy'),
('Migraine',                'Painkillers'),
('Migraine',                'Rest'),
('Epilepsy',                'Anti-Seizure Medication'),
('Stroke',                  'Clot Dissolving Medication'),
('Stroke',                  'Physiotherapy'),
('Fracture',                'Casting'),
('Fracture',                'Orthopedic Surgery'),
('Back Pain',               'Physiotherapy'),
('Back Pain',               'Painkillers'),
('Arthritis',               'Anti-inflammatory Drugs'),
('Arthritis',               'Joint Therapy'),
('Common Cold',             'Cough Syrup'),
('Common Cold',             'Rest and Fluids'),
('Chickenpox',              'Antiviral Medication'),
('Chickenpox',              'Calamine Lotion'),
('Pediatric Fever',         'Paracetamol'),
('Pediatric Fever',         'Hydration Therapy'),
('PCOS',                    'Hormonal Therapy'),
('PCOS',                    'Lifestyle Management'),
('Pregnancy Checkup',       'Prenatal Vitamins'),
('Pregnancy Checkup',       'Ultrasound Monitoring'),
('Menstrual Disorder',      'Hormone Therapy'),
('Menstrual Disorder',      'Pain Relief Medication'),
('Depression',              'Antidepressants'),
('Depression',              'Psychotherapy'),
('Anxiety Disorder',        'Anti-anxiety Medication'),
('Anxiety Disorder',        'Counseling'),
('Insomnia',                'Sleep Therapy'),
('Insomnia',                'Melatonin Medication'),
('Viral Fever',             'Paracetamol'),
('Viral Fever',             'Rest and Hydration'),
('Typhoid',                 'Antibiotics'),
('Typhoid',                 'Fluid Therapy'),
('Gastritis',               'Antacid Medication'),
('Gastritis',               'Diet Control');

-- ─────────────────────────────────────────
-- DATA: patients  (IDs: 5000 – 5009)
-- ─────────────────────────────────────────
INSERT INTO patients (patient_id, name, age, gender, phone) VALUES
(5000, 'Arjun Sharma',  34, 'Male',   '9831001001'),
(5001, 'Priya Mehta',   28, 'Female', '9831001002'),
(5002, 'Ravi Kumar',    52, 'Male',   '9831001003'),
(5003, 'Sneha Das',     22, 'Female', '9831001004'),
(5004, 'Mohan Patel',   45, 'Male',   '9831001005'),
(5005, 'Anjali Singh',  31, 'Female', '9831001006'),
(5006, 'Suresh Nair',   60, 'Male',   '9831001007'),
(5007, 'Kavitha Reddy', 38, 'Female', '9831001008'),
(5008, 'Deepak Joshi',  27, 'Male',   '9831001009'),
(5009, 'Lakshmi Iyer',  55, 'Female', '9831001010');

-- ─────────────────────────────────────────
-- DATA: doctors  (IDs: 2600 – 2609)
-- ─────────────────────────────────────────
INSERT INTO doctors (doctor_id, name, specialization, phone) VALUES
(2600, 'Dr. Anil Verma',   'Cardiology',       '9900100001'),
(2601, 'Dr. Pooja Kapoor', 'Dermatology',      '9900100002'),
(2602, 'Dr. Ramesh Bose',  'Neurology',        '9900100003'),
(2603, 'Dr. Meena Tiwari', 'Orthopedics',      '9900100004'),
(2604, 'Dr. Sunil Ghosh',  'General Medicine', '9900100005'),
(2605, 'Dr. Nisha Pillai', 'Pediatrics',       '9900100006'),
(2606, 'Dr. Vikram Rao',   'Gynecology',       '9900100007'),
(2607, 'Dr. Sunita Jain',  'Psychiatry',       '9900100008'),
(2608, 'Dr. Harish Menon', 'General Medicine', '9900100009'),
(2609, 'Dr. Rekha Saxena', 'Dermatology',      '9900100010');

-- ─────────────────────────────────────────────────────────────────────────────
-- DATA: users
--
-- Password policy:
--   admin    →  original credentials unchanged
--   patient  →  username = patient_id  | password = firstname(lowercase) + patient_id
--   doctor   →  username = doctor_id   | password = firstname(lowercase) + doctor_id
--                                        ("Dr." prefix is stripped)
--
-- Examples:
--   Patient 5000 Arjun Sharma   → username: 5000  password: arjun5000
--   Doctor  2600 Dr. Anil Verma → username: 2600  password: anil2600
-- ─────────────────────────────────────────────────────────────────────────────
INSERT INTO users (username, password, role) VALUES

-- Admins
('admin1', 'admin123', 'admin'),
('admin2', 'admin456', 'admin'),

-- Patients  (password = firstname lowercase + patient_id)
('5000', 'arjun5000',   'patient'),
('5001', 'priya5001',   'patient'),
('5002', 'ravi5002',    'patient'),
('5003', 'sneha5003',   'patient'),
('5004', 'mohan5004',   'patient'),
('5005', 'anjali5005',  'patient'),
('5006', 'suresh5006',  'patient'),
('5007', 'kavitha5007', 'patient'),
('5008', 'deepak5008',  'patient'),
('5009', 'lakshmi5009', 'patient'),

-- Doctors  (password = firstname lowercase + doctor_id,  "Dr." stripped)
('2600', 'anil2600',   'doctor'),
('2601', 'pooja2601',  'doctor'),
('2602', 'ramesh2602', 'doctor'),
('2603', 'meena2603',  'doctor'),
('2604', 'sunil2604',  'doctor'),
('2605', 'nisha2605',  'doctor'),
('2606', 'vikram2606', 'doctor'),
('2607', 'sunita2607', 'doctor'),
('2608', 'harish2608', 'doctor'),
('2609', 'rekha2609',  'doctor');

-- ─────────────────────────────────────────
-- DATA: appointments  (15 rows)
-- appointment_date is the booked date
-- date is the actual visit date (same for completed, future for scheduled)
-- ─────────────────────────────────────────
INSERT INTO appointments (appointment_id, patient_id, doctor_id, appointment_date, date, appointment_time, status) VALUES
(1,  5000, 2600, '2025-06-01', '2025-06-01', '09:00:00', 'Completed'),
(2,  5001, 2601, '2025-06-02', '2025-06-02', '10:30:00', 'Completed'),
(3,  5002, 2602, '2025-06-03', '2025-06-03', '11:00:00', 'Completed'),
(4,  5003, 2603, '2025-06-04', '2025-06-04', '09:30:00', 'Completed'),
(5,  5004, 2604, '2025-06-05', '2025-06-05', '14:00:00', 'Completed'),
(6,  5005, 2605, '2025-06-06', '2025-06-06', '10:00:00', 'Completed'),
(7,  5006, 2606, '2025-06-07', '2025-06-07', '11:30:00', 'Completed'),
(8,  5007, 2607, '2025-06-08', '2025-06-08', '15:00:00', 'Completed'),
(9,  5008, 2600, '2025-06-09', '2025-06-09', '09:00:00', 'Completed'),
(10, 5009, 2601, '2025-06-10', '2025-06-10', '10:00:00', 'Completed'),
(11, 5000, 2602, '2025-06-11', '2025-06-11', '11:00:00', 'Scheduled'),
(12, 5001, 2603, '2025-06-12', '2025-06-12', '09:30:00', 'Scheduled'),
(13, 5002, 2604, '2025-06-13', '2025-06-13', '14:30:00', 'Cancelled'),
(14, 5003, 2608, '2025-06-14', '2025-06-14', '10:00:00', 'Scheduled'),
(15, 5004, 2609, '2025-06-15', '2025-06-15', '13:00:00', 'Scheduled');

-- ─────────────────────────────────────────
-- DATA: treatment_records  (10 rows — completed appointments only)
-- ─────────────────────────────────────────
INSERT INTO treatment_records (appointment_id, diagnosis, prescription, notes) VALUES
(1,  'Hypertension',            'Blood Pressure Medication, Low Salt Diet',    'BP: 150/95. Advised lifestyle changes.'),
(2,  'Acne',                    'Topical Cream, Oral Antibiotics',              'Moderate acne on face and back.'),
(3,  'Migraine',                'Painkillers, Rest',                            'Recurring migraines, 2x per week.'),
(4,  'Fracture',                'Casting',                                      'Left wrist hairline fracture. X-ray done.'),
(5,  'Gastritis',               'Antacid Medication, Diet Control',             'Advised to avoid spicy food.'),
(6,  'Common Cold',             'Cough Syrup, Rest and Fluids',                 'Mild fever and sore throat present.'),
(7,  'Pregnancy Checkup',       'Prenatal Vitamins, Ultrasound Monitoring',     '12-week checkup. All normal.'),
(8,  'Depression',              'Antidepressants, Psychotherapy',               'Referred for weekly counseling sessions.'),
(9,  'Coronary Artery Disease', 'Beta Blockers',                                'ECG abnormal. Follow-up in 2 weeks.'),
(10, 'Skin Allergy',            'Antihistamines, Skin Cream',                   'Allergic reaction to dust. Avoid triggers.');