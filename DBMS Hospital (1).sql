DROP DATABASE IF EXISTS apollo_hospital17;
CREATE DATABASE apollo_hospital17;
USE apollo_hospital17;

-- 1. Hospital branches
CREATE TABLE HospitalBranch (
  branch_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  city VARCHAR(60),
  phone VARCHAR(15),
  established_year YEAR
);

-- 2. Departments
CREATE TABLE Department (
  department_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
  branch_id INT NOT NULL,
  name VARCHAR(80) NOT NULL,
  floor VARCHAR(10),
  FOREIGN KEY (branch_id) REFERENCES HospitalBranch(branch_id)
);

-- 3. Doctors
CREATE TABLE Doctor (
  doctor_id INT AUTO_INCREMENT PRIMARY KEY,
  branch_id INT NOT NULL,
  department_id SMALLINT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50),
  reg_no VARCHAR(30) UNIQUE,
  phone VARCHAR(15),
  email VARCHAR(80),
  experience_years TINYINT,
  FOREIGN KEY (branch_id) REFERENCES HospitalBranch(branch_id),
  FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- 4. Patients
CREATE TABLE Patient (
  patient_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  mrn VARCHAR(40) UNIQUE,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50),
  dob DATE,
  gender ENUM('Male','Female','Other'),
  phone VARCHAR(15),
  email VARCHAR(80),
  address VARCHAR(200)
);

-- 5. Rooms
CREATE TABLE Room (
  room_id INT AUTO_INCREMENT PRIMARY KEY,
  branch_id INT NOT NULL,
  room_number VARCHAR(10) NOT NULL,
  room_type ENUM('General','SemiPrivate','Private','ICU'),
  is_occupied TINYINT(1) DEFAULT 0,
  FOREIGN KEY (branch_id) REFERENCES HospitalBranch(branch_id),
  UNIQUE (branch_id, room_number)
);

-- 6. Appointments
CREATE TABLE Appointment (
  appointment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  patient_id BIGINT NOT NULL,
  doctor_id INT NOT NULL,
  appointment_datetime DATETIME NOT NULL,
  status ENUM('Scheduled','Completed','Cancelled','NoShow') DEFAULT 'Scheduled',
  reason VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
  FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
);

-- 7. Visits
CREATE TABLE Visit (
  visit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  appointment_id BIGINT,
  patient_id BIGINT NOT NULL,
  doctor_id INT NOT NULL,
  branch_id INT NOT NULL,
  visit_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
  visit_type ENUM('Outpatient','Emergency','FollowUp') DEFAULT 'Outpatient',
  notes TEXT,
  FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id),
  FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
  FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
  FOREIGN KEY (branch_id) REFERENCES HospitalBranch(branch_id)
);

-- 8. Admissions
CREATE TABLE Admission (
  admission_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  visit_id BIGINT NOT NULL,
  patient_id BIGINT NOT NULL,
  room_id INT NOT NULL,
  admitted_on DATETIME NOT NULL,
  discharged_on DATETIME,
  status ENUM('Admitted','Discharged','Transferred') DEFAULT 'Admitted',
  admitting_doctor_id INT NOT NULL,
  reason VARCHAR(255),
  FOREIGN KEY (visit_id) REFERENCES Visit(visit_id),
  FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
  FOREIGN KEY (room_id) REFERENCES Room(room_id),
  FOREIGN KEY (admitting_doctor_id) REFERENCES Doctor(doctor_id)
);

-- 9. Medications
CREATE TABLE Medication (
  medication_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  form VARCHAR(30),
  strength VARCHAR(30),
  unit_price DECIMAL(10,2)
);

-- 10. Prescriptions
CREATE TABLE Prescription (
  prescription_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  visit_id BIGINT NOT NULL,
  doctor_id INT NOT NULL,
  prescribed_on DATETIME DEFAULT CURRENT_TIMESTAMP,
  notes VARCHAR(255),
  FOREIGN KEY (visit_id) REFERENCES Visit(visit_id),
  FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
);

-- 11. Prescription Items
CREATE TABLE PrescriptionItem (
  presc_item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  prescription_id BIGINT NOT NULL,
  medication_id INT NOT NULL,
  dosage VARCHAR(100),
  frequency VARCHAR(50),
  duration_days SMALLINT,
  quantity INT,
  FOREIGN KEY (prescription_id) REFERENCES Prescription(prescription_id),
  FOREIGN KEY (medication_id) REFERENCES Medication(medication_id)
);

-- 12. Lab Tests (test catalog)
CREATE TABLE LabTest (
  labtest_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  department_id SMALLINT,
  price DECIMAL(10,2),
  FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- 13. Lab Orders (requested by doctor)
CREATE TABLE LabOrder (
  laborder_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  visit_id BIGINT NOT NULL,
  ordered_by INT NOT NULL,
  ordered_on DATETIME DEFAULT CURRENT_TIMESTAMP,
  status ENUM('Pending','Completed','Cancelled') DEFAULT 'Pending',
  FOREIGN KEY (visit_id) REFERENCES Visit(visit_id),
  FOREIGN KEY (ordered_by) REFERENCES Doctor(doctor_id)
);

-- 14. Lab Order Items (each test inside an order)
CREATE TABLE LabOrderItem (
  lab_item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  laborder_id BIGINT NOT NULL,
  labtest_id INT NOT NULL,
  result_text VARCHAR(500),
  result_date DATETIME,
  FOREIGN KEY (laborder_id) REFERENCES LabOrder(laborder_id),
  FOREIGN KEY (labtest_id) REFERENCES LabTest(labtest_id)
);

-- 15. Invoices
CREATE TABLE Invoice (
  invoice_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  visit_id BIGINT NOT NULL,
  patient_id BIGINT NOT NULL,
  created_on DATETIME DEFAULT CURRENT_TIMESTAMP,
  total_amount DECIMAL(12,2),
  status ENUM('Unpaid','Paid','PartiallyPaid') DEFAULT 'Unpaid',
  FOREIGN KEY (visit_id) REFERENCES Visit(visit_id),
  FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

-- 16. Payments
CREATE TABLE Payment (
  payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  invoice_id BIGINT NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  method ENUM('Cash','Card','UPI','Insurance') DEFAULT 'Cash',
  payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  reference_no VARCHAR(50),
  FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);

-- ===========================
-- INSERT DATA FOR APOLLO HOSPITAL admission
-- ===========================

-- 1. HospitalBranch
INSERT INTO HospitalBranch (name, city, phone, established_year)
VALUES 
('Apollo Chennai', 'Chennai', '044-987654', 1983),
('Apollo Delhi', 'New Delhi', '011-765432', 1991);

-- 2. Department
INSERT INTO Department (branch_id, name, floor)
VALUES
(1, 'Cardiology', '2A'),
(1, 'Orthopedics', '3B'),
(2, 'Neurology', '4A'),
(2, 'Dermatology', '1C');

-- 3. Doctor (REG NO UPDATED SO NO DUPLICATE)
INSERT INTO Doctor (branch_id, department_id, first_name, last_name, reg_no, phone, email, experience_years)
VALUES
(1, 1, 'Ravi', 'Menon', 'REG901', '9876543210', 'ravi.menon@apollo.com', 15),
(1, 2, 'Anita', 'Sharma', 'REG902', '9988776655', 'anita.sharma@apollo.com', 10),
(2, 3, 'Rahul', 'Kapoor', 'REG903', '9911223344', 'rahul.kapoor@apollo.com', 12),
(2, 4, 'Sneha', 'Patel', 'REG904', '9898989898', 'sneha.patel@apollo.com', 8);

-- 4. Patient (MRN NEW)
INSERT INTO Patient (mrn, first_name, last_name, dob, gender, phone, email, address)
VALUES
('MRN2001','Karan','Mehta','1995-05-10','Male','9000011111','karan.mehta@mail.com','Chennai'),
('MRN2002','Seema','Rao','1988-11-22','Female','9000022222','seema.rao@mail.com','Delhi'),
('MRN2003','Raj','Kumar','2001-09-01','Male','9000033333','rajkumar@mail.com','Chennai');

-- 5. Room
INSERT INTO Room (branch_id, room_number, room_type, is_occupied)
VALUES
(1, '101', 'General', 0),
(1, '102', 'Private', 1),
(2, '201', 'ICU', 0);

-- 6. Appointment
INSERT INTO Appointment (patient_id, doctor_id, appointment_datetime, status, reason)
VALUES
(1, 1, '2025-02-10 10:00:00', 'Scheduled', 'Chest Pain'),
(2, 2, '2025-02-10 11:30:00', 'Completed', 'Knee Pain'),
(3, 3, '2025-02-11 09:00:00', 'Scheduled', 'Headache');

-- 7. Visit
INSERT INTO Visit (appointment_id, patient_id, doctor_id, branch_id, visit_datetime, visit_type, notes)
VALUES
(1, 1, 1, 1, '2025-02-10 10:15:00', 'Outpatient', 'Mild chest pain symptoms'),
(2, 2, 2, 1, '2025-02-10 11:45:00', 'Outpatient', 'Knee pain evaluation'),
(3, 3, 3, 2, '2025-02-11 09:10:00', 'Emergency', 'Severe headache and nausea');

-- 8. Admission
INSERT INTO Admission (visit_id, patient_id, room_id, admitted_on, status, admitting_doctor_id, reason)
VALUES
(1, 1, 2, '2025-02-10 12:00:00', 'Admitted', 1, 'Observation for chest pain');

-- 9. Medication
INSERT INTO Medication (name, form, strength, unit_price)
VALUES
('Paracetamol', 'Tablet', '500mg', 5.00),
('Amoxicillin', 'Capsule', '250mg', 12.00),
('Omeprazole', 'Tablet', '20mg', 8.00);

-- 10. Prescription
INSERT INTO Prescription (visit_id, doctor_id, notes)
VALUES
(1, 1, 'Prescribed mild analgesics'),
(3, 3, 'Migraine treatment medications');

-- 11. PrescriptionItem
INSERT INTO PrescriptionItem (prescription_id, medication_id, dosage, frequency, duration_days, quantity)
VALUES
(1, 1, '1 Tablet', '3 times a day', 5, 15),
(2, 3, '1 Tablet', 'Once daily', 7, 7);

-- 12. LabTest
INSERT INTO LabTest (name, department_id, price)
VALUES
('CBC', 1, 300),
('ECG', 1, 500),
('MRI Brain', 3, 3500);

-- 13. LabOrder
INSERT INTO LabOrder (visit_id, ordered_by, status)
VALUES
(1, 1, 'Pending'),
(3, 3, 'Pending');

-- 14. LabOrderItem
INSERT INTO LabOrderItem (laborder_id, labtest_id, result_text, result_date)
VALUES
(1, 1, 'CBC Results Normal', '2025-02-10 14:00:00'),
(2, 3, 'MRI shows sinus pressure', '2025-02-11 12:00:00');

-- 15. Invoice
INSERT INTO Invoice (visit_id, patient_id, total_amount, status)
VALUES
(1, 1, 1800, 'Unpaid'),
(2, 2, 750, 'Paid'),
(3, 3, 4300, 'Unpaid');

-- 16. Payment
INSERT INTO Payment (invoice_id, amount, method, reference_no)
VALUES
(2, 750, 'Cash', 'PAY9001');


