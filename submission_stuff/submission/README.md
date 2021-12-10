# Application Description
This is a simple application that allows a user to store basic energy usage information
about various properties they may own. This could be used by homeowners, 
commercial property owners, or business owners who may want to track their
properties' energy usage.

Uses MySQL for the database and a Python text based user application.
pymysql is used for the Python to MySQL connection.

# Setup and Running the Application
## Setting up the MySQL database
* Install the latest version of MySQL workbench: https://dev.mysql.com/downloads/workbench/
* Create a server instance and connect to it through MySQL.
* In MySQL workbench, import the database dump filed name energy_app_database_dump.sql by going to Server->Data Import
* Select "Import from Self-Contained File" and then select energy_app_database_dump.sql dump file.
* Click start import.
* This will import the database schema, some example tuples, and will add a user with permissions that is used for the connection between this application and the database.
## Running the User Application
* Install the latest version of Python3: https://www.python.org/downloads/
* Install the latest version of git to get git bash (or install some terminal if you don't have one already): https://git-scm.com/downloads
* Open a terminal in the root of the submission folder.
* Create a virtual environment (venv): >python -m venv ./venv
* Start the virtual environment (venv): >source venv/Scripts/activate or on Mac run: >source venv/bin/activate
* Install project dependencies from the given requirements.txt: >pip install -r requirements.txt
* Run the user application: >python energy_app.py