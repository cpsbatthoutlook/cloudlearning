### PROMPT:  Write a Python3 flask code of bookmarks app with distinct categories and with sqlite3 backend with features like add, modify and remove bookmarks

###  Steps
* python -c "from app import init_db; init_db()"
* python app.py

###  Steps
python -m venv venv
source venv/bin/activate
pip install Flask
python database.py
python newapp.py

### Prompt 

Prompt: Flask Bookmarks App with Categories and SQLite3 Backend

This prompt provides all the necessary files and instructions to set up and run a simple Flask web application for managing bookmarks. The application allows you to add, view, modify, and delete bookmarks, organized by distinct categories, using a SQLite3 database as the backend.

Features:

Add Bookmarks: Add new bookmarks with a title, URL, category (select existing or add new), and an optional description.
View Bookmarks: Display all bookmarks in a table.
Filter Bookmarks: Filter the displayed bookmarks by category using a dropdown.
Edit Bookmarks: Modify existing bookmark details.
Delete Bookmarks: Remove bookmarks from the database.
Distinct Categories: Organize bookmarks into user-defined categories.
SQLite3 Backend: Persistent storage using a lightweight SQLite database.
Flash Messages: Provides user feedback for successful operations or errors.
