-- 1. Create the Database Schema
CREATE DATABASE IF NOT EXISTS sunrise_dental;
USE sunrise_dental;

-- 2. Create User Credentials Table (Admin / Receptionist Authentication)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL -- 'ADMIN' or 'RECEPTIONIST'
);

-- 3. Create Patient Master Table
CREATE TABLE IF NOT EXISTS patients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Create Appointments Processing Table
CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_number VARCHAR(20) UNIQUE NOT NULL,
    patient_id INT NOT NULL,
    dentist_name VARCHAR(100) NOT NULL,
    treatment_type VARCHAR(50) NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    consultation_fee DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING' or 'PAID'
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
);

-- 5. Seed Initial System Testing Users
-- For production, encrypt passwords. For local academic testing, we match standard check strings.
INSERT INTO users (username, password, role) VALUES 
('admin01', 'admin123', 'ADMIN'),
('staff01', 'staff123', 'RECEPTIONIST')
ON DUPLICATE KEY UPDATE username=username;



-- 6. Treatment information table

CREATE TABLE IF NOT EXISTS treatments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    treatment_name VARCHAR(100) NOT NULL UNIQUE,
    base_price DECIMAL(10, 2) NOT NULL
);

-- Pre-populate the table with your baseline values
INSERT INTO treatments (treatment_name, base_price) VALUES 
('Cleaning', 2500.00),
('Filling', 4000.00),
('Nerve Treatment', 12000.00)
ON DUPLICATE KEY UPDATE base_price=VALUES(base_price);


------- 2nd change i made --------------------------------------


-- Step A: Add column with a temporary default value so existing rows aren't NULL
ALTER TABLE patients 
ADD COLUMN address VARCHAR(255) NOT NULL DEFAULT 'Not Provided';



-----------------------3 rd change i made -----------------------------------------


USE sunrise_dental;

-- 1. Create Doctors Master Table (Managed exclusively by Admin)
CREATE TABLE IF NOT EXISTS doctors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL UNIQUE,
    specialization VARCHAR(100) DEFAULT 'General Dental Surgeon',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create Doctor-Treatment Mapping Table (Admin controls which treatments doctors perform)
CREATE TABLE IF NOT EXISTS doctor_treatments (
    doctor_id INT NOT NULL,
    treatment_id INT NOT NULL,
    PRIMARY KEY (doctor_id, treatment_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
    FOREIGN KEY (treatment_id) REFERENCES treatments(id) ON DELETE CASCADE
);

-- 3. Seed initial sample doctors
INSERT INTO doctors (doctor_name, specialization, is_active) VALUES 
('Dr. Perera', 'Orthodontist', TRUE),
('Dr. Silva', 'Endodontist', TRUE)
ON DUPLICATE KEY UPDATE doctor_name=VALUES(doctor_name);


------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS appointment_addons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    addon_name VARCHAR(150) NOT NULL,
    addon_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE
);