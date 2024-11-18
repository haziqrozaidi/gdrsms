-- Create Database
CREATE DATABASE GDRSMS;
USE GDRSMS;

-- User Supertype Table
CREATE TABLE User (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    contact_no VARCHAR(20),
    faculty VARCHAR(100)
);

-- Student Subtype Table
CREATE TABLE Student (
    user_id INT PRIMARY KEY,
    matric_no VARCHAR(20) UNIQUE NOT NULL,
    program VARCHAR(100),
    semester INT,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

-- Lecturer Subtype Table
CREATE TABLE Lecturer (
    user_id INT PRIMARY KEY,
    staff_no VARCHAR(20) UNIQUE NOT NULL,
    department VARCHAR(100),
    academic_rank VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

-- Admin Subtype Table
CREATE TABLE Admin (
    user_id INT PRIMARY KEY,
    staff_no VARCHAR(20) UNIQUE NOT NULL,
    access_permissions TEXT,
    admin_level VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

-- Category Table
CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Folder Table
CREATE TABLE Folder (
    folder_id INT PRIMARY KEY AUTO_INCREMENT,
    folder_name VARCHAR(100) NOT NULL,
    parent_folder_id INT,
    created_by INT,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    visibility_status ENUM('PUBLIC', 'PRIVATE', 'RESTRICTED') DEFAULT 'PRIVATE',
    access_level ENUM('READ', 'WRITE', 'ADMIN') DEFAULT 'READ',
    FOREIGN KEY (parent_folder_id) REFERENCES Folder(folder_id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES User(user_id) ON DELETE SET NULL
);

-- Resource Table
CREATE TABLE Resource (
    resource_id INT PRIMARY KEY AUTO_INCREMENT,
    folder_id INT,
    user_id INT,
    category_id INT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    google_drive_link VARCHAR(500),
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    file_type VARCHAR(50),
    file_size BIGINT,
    visibility_status ENUM('PUBLIC', 'PRIVATE', 'RESTRICTED') DEFAULT 'PRIVATE',
    FOREIGN KEY (folder_id) REFERENCES Folder(folder_id) ON DELETE SET NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE SET NULL
);

-- Shared Resource Table
CREATE TABLE Shared_Resource (
    share_id INT PRIMARY KEY AUTO_INCREMENT,
    resource_id INT,
    sender_id INT,
    recipient_id INT,
    share_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    permission_level ENUM('VIEW', 'EDIT', 'DOWNLOAD') DEFAULT 'VIEW',
    FOREIGN KEY (resource_id) REFERENCES Resource(resource_id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES User(user_id) ON DELETE SET NULL,
    FOREIGN KEY (recipient_id) REFERENCES User(user_id) ON DELETE SET NULL
);
