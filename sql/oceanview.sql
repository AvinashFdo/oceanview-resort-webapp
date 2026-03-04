-- Ocean View Resort Reservation System
-- Database Script
-- Tables, triggers, stored procedures and functions

CREATE DATABASE IF NOT EXISTS oceanview_resort
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE oceanview_resort;

-- USERS TABLE
CREATE TABLE IF NOT EXISTS users (
                                     user_id INT AUTO_INCREMENT PRIMARY KEY,
                                     username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('ADMIN','RECEPTIONIST') NOT NULL DEFAULT 'RECEPTIONIST',
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

-- ROOMS TABLE
CREATE TABLE IF NOT EXISTS rooms (
                                     room_id INT AUTO_INCREMENT PRIMARY KEY,
                                     room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type ENUM('STANDARD','DELUXE','SUITE') NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    status ENUM('AVAILABLE','MAINTENANCE') DEFAULT 'AVAILABLE'
    );

-- RESERVATIONS TABLE
CREATE TABLE IF NOT EXISTS reservations (
                                            res_id INT AUTO_INCREMENT PRIMARY KEY,
                                            reservation_no VARCHAR(20) NOT NULL UNIQUE,
    guest_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    contact_no VARCHAR(15) NOT NULL,
    room_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    created_by INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_res_room FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    CONSTRAINT fk_res_user FOREIGN KEY (created_by) REFERENCES users(user_id),

    INDEX idx_dates (check_in, check_out),
    INDEX idx_room (room_id)
    );

-- PAYMENTS TABLE
CREATE TABLE IF NOT EXISTS payments (
                                        payment_id INT AUTO_INCREMENT PRIMARY KEY,
                                        res_id INT NOT NULL,
                                        nights INT NOT NULL,
                                        rate_per_night DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('CASH','CARD') NOT NULL DEFAULT 'CASH',
    paid_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_pay_res FOREIGN KEY (res_id) REFERENCES reservations(res_id)
    );

-- AUDIT LOG
CREATE TABLE IF NOT EXISTS audit_log (
                                         log_id INT AUTO_INCREMENT PRIMARY KEY,
                                         user_id INT NULL,
                                         action VARCHAR(50) NOT NULL,
    details VARCHAR(255) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(user_id)
    );

-- FUNCTION: CALCULATE NUMBER OF NIGHTS
DELIMITER $$

CREATE FUNCTION fn_nights(p_check_in DATE, p_check_out DATE)
    RETURNS INT
    DETERMINISTIC
BEGIN
RETURN DATEDIFF(p_check_out, p_check_in);
END$$

DELIMITER ;

-- TRIGGER: PREVENT INVALID DATE RANGE
DELIMITER $$

CREATE TRIGGER trg_reservation_dates_ins
    BEFORE INSERT ON reservations
    FOR EACH ROW
BEGIN
    IF NEW.check_out <= NEW.check_in THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Check-out date must be after check-in date';
END IF;
END$$

DELIMITER ;

-- STORED PROCEDURE: CREATE RESERVATION WITH CONFLICT CHECK
DELIMITER $$

CREATE PROCEDURE sp_create_reservation (
    IN p_reservation_no VARCHAR(20),
    IN p_guest_name VARCHAR(100),
    IN p_address VARCHAR(255),
    IN p_contact_no VARCHAR(15),
    IN p_room_id INT,
    IN p_check_in DATE,
    IN p_check_out DATE,
    IN p_created_by INT
)
BEGIN

  IF EXISTS (
    SELECT 1
    FROM reservations r
    WHERE r.room_id = p_room_id
      AND NOT (r.check_out <= p_check_in OR r.check_in >= p_check_out)
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Booking conflict: room already reserved for selected dates';
END IF;

INSERT INTO reservations (
    reservation_no, guest_name, address, contact_no,
    room_id, check_in, check_out, created_by
)
VALUES (
           p_reservation_no, p_guest_name, p_address, p_contact_no,
           p_room_id, p_check_in, p_check_out, p_created_by
       );

END$$

DELIMITER ;