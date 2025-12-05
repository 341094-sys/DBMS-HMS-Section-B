 Hospital Management System – DBMS Project

This project represents a structured database model designed to manage and streamline key hospital operations. It demonstrates core DBMS concepts such as entity–relationship modeling, normalization, and relational integrity.

📌Project Overview

The Hospital Management System (HMS) aims to organize hospital data efficiently, reduce redundancy, and provide a centralized system for managing patients, doctors, appointments, treatments, rooms, and billing.
The design supports easy retrieval, updates, and analysis of hospital information.

Key Features

Comprehensive patient and doctor records

Appointment scheduling between patients and doctors

Complete treatment history and diagnosis tracking

Room/ward management with availability status

Billing structure covering treatment, medicine, and room charges

Clear primary–foreign key relationships ensuring data integrity

Well-normalized tables for performance and consistency

ER Diagram – Explained

The ER diagram consists of major entities and their interactions:

Entities

Patient: Stores personal and medical information

Doctor: Contains doctor profiles and specialization

Appointment: Represents scheduled visits between patients and doctors

Treatment: Stores diagnosis details, medications, and treatment dates

Room: Manages room type, status, and patient assignment

Billing: Records service costs and payment details

Relationships

A patient can have multiple appointments and treatments.

A doctor can attend many appointments and provide multiple treatments.

Billing is associated with each patient, with the possibility of multiple bills.

Rooms may be assigned to patients when occupied (optional 1:1 relationship).

The design ensures smooth data flow and clear linkages across hospital activities.

