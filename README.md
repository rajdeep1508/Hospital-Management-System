[README.md](https://github.com/user-attachments/files/26161324/README.md)
<div align="center">

<br>

```
██╗  ██╗███╗   ███╗███████╗
██║  ██║████╗ ████║██╔════╝
███████║██╔████╔██║███████╗
██╔══██║██║╚██╔╝██║╚════██║
██║  ██║██║ ╚═╝ ██║███████║
╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
```

# 🏥 Hospital Management System

**A full-stack web application for managing hospital operations — patients, doctors, and appointments — deployed live on Render.**

<br>

[![Live Demo](https://img.shields.io/badge/🚀%20LIVE%20DEMO-Visit%20Now-4F46E5?style=for-the-badge&labelColor=1e1b4b)](https://hospital-management-system-jspw.onrender.com)

<br>

![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=flat-square&logo=flask&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)
![Jinja2](https://img.shields.io/badge/Jinja2-B41717?style=flat-square&logo=jinja&logoColor=white)
![Render](https://img.shields.io/badge/Deployed%20on-Render-46E3B7?style=flat-square&logo=render&logoColor=white)
![Railway](https://img.shields.io/badge/Database-Railway-0B0D0E?style=flat-square&logo=railway&logoColor=white)

</div>

---

## 🌐 Live Application

<div align="center">

### 👉 [https://hospital-management-system-jspw.onrender.com](https://hospital-management-system-jspw.onrender.com)

*Hosted on **Render** · Database on **Railway** · Always available*

</div>

---

## ✨ Features

| Module | Capabilities |
|--------|-------------|
| 🧑‍⚕️ **Patients** | Add, view, edit, and delete patient records |
| 👨‍⚕️ **Doctors** | Manage doctor profiles with specializations |
| 📅 **Appointments** | Schedule and track appointments |
| 💊 **Treatment Records** | Log and manage treatments per appointment |
| 🔐 **Role-Based Access** | Admin vs. regular user permissions |

---

## 🗂️ Project Structure

```
hospital-management-system/
│
├── app.py                  # Main Flask application & all routes
├── requirements.txt        # Python dependencies
│
├── templates/
│   ├── base.html           # Base layout template
│   ├── view_patients.html  # Patient listing
│   ├── edit_patient.html   # Edit patient form
│   ├── delete_patient.html # Delete patient confirmation
│   ├── view_doctors.html   # Doctor listing
│   ├── edit_doctor.html    # Edit doctor form
│   ├── delete_doctor.html  # Delete doctor confirmation
│   └── ...
│
└── static/                 # CSS, JS, images
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Backend** | Python, Flask |
| **Frontend** | HTML5, Jinja2 Templates, CSS |
| **Database** | MySQL (hosted on Railway) |
| **Hosting** | Render (Web Service) |
| **Session** | Flask session with role management |

---

## 🚀 Running Locally

### 1. Clone the repository

```bash
git clone https://github.com/your-username/hospital-management-system.git
cd hospital-management-system
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

### 3. Configure your database

Create a `.env` file or set environment variables:

```env
DB_HOST=your_mysql_host
DB_USER=your_mysql_user
DB_PASSWORD=your_mysql_password
DB_NAME=your_database_name
```

### 4. Run the app

```bash
python app.py
```

Visit `http://localhost:5000` in your browser.

---

## 🗄️ Database Schema

```sql
patients       → patient_id, name, age, gender, phone
doctors        → doctor_id, name, specialization, phone, email
appointments   → appointment_id, patient_id (FK), doctor_id (FK), date, time
treatment_records → record_id, appointment_id (FK), notes, medication
```

> Cascaded deletes are handled at the **application layer** — deleting a doctor or patient also removes their appointments and treatment records in the correct order to avoid integrity errors.

---

## 🔐 Role-Based Access

| Action | Admin | User |
|--------|-------|------|
| View patients/doctors | ✅ | ✅ |
| Add records | ✅ | ❌ |
| Edit records | ✅ | ❌ |
| Delete records | ✅ | ❌ |

---

## ☁️ Deployment

This app is deployed using two cloud services:

- **[Render](https://render.com)** — hosts the Flask web application
- **[Railway](https://railway.app)** — hosts the MySQL database

The live URL is:
```
https://hospital-management-system-jspw.onrender.com
```

> ⚠️ The app is on Render's free tier — it may take **30–60 seconds** to spin up after a period of inactivity.

---

## 📸 Screenshots

> *Add screenshots of your app here for a better first impression!*

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<div align="center">

Made with ❤️ using Flask & deployed on Render

[![Live Demo](https://img.shields.io/badge/🏥%20Try%20the%20App-hospital--management--system-4F46E5?style=for-the-badge)](https://hospital-management-system-jspw.onrender.com)

</div>
