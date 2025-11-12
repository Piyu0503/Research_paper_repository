# Research Paper Repository Management System

## Overview

A **web-based app** to manage research papers, authors, journals, and conferences. Users can:

* Add new research papers with author details.
* Link papers to a conference or a journal.
* Search papers by title or author name.
* Delete papers if needed.

**Frontend:** Streamlit
**Backend:** MySQL

---

## Setup Instructions

1. **Clone Repo**

```bash
git clone https://github.com/priyankakhatavkar/Research-Paper-Repository.git
cd Research-Paper-Repository
```

2. **Setup Virtual Environment & Install Dependencies**

```bash
python -m venv .venv
# Activate
.venv\Scripts\activate   # Windows
source .venv/bin/activate  # Linux/Mac

pip install streamlit mysql-connector-python pandas
```

3. **Create Database & Tables**
   Use MySQL Workbench or CLI to create `Research_Paper_Repository` and the tables: `Author`, `Conference`, `Journal`, `Research_Paper`, `Paper_Author`, `Reviewer`, `Paper_Reviewer`.

4. **Run the App**

```bash
streamlit run app.py
```

---

## Features

* Add papers with automatic Paper_ID and Author_ID generation.
* Validate DOI uniqueness.
* Search papers by title or author.
* Delete papers.
* User-friendly Streamlit interface.

---
