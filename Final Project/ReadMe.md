# HPC Dashboard Project

This project provides a web-based dashboard to visualize CPU and GPU usage statistics for users on the UM6P Simlab HPC cluster. The system consists of three main components: a data collection script, a scheduler, and a web dashboard.

## Prerequisites

- Python 3.7 or higher
- Access to UM6P Simlab cluster
- The following Python packages:
  ```
  dash
  plotly
  pandas
  paramiko
  schedule
  ```

## Project Structure

```
hpc-dashboard/
├── collect_usage.sh      # Bash script to collect HPC usage data
├── co,,ection.py          # Python script to schedule data collection
├── tempCodeRunnerFile.py         # Main dashboard application
└── output.csv           # Generated usage data file
```

## Setup Instructions

### 1. Install Required Packages

```bash
pip install dash plotly pandas paramiko schedule
```

### 2. Set Up Data Collection on Simlab

1. Log in to your Simlab account via SSH:
   ```bash
   ssh your_username@simlab-cluster.um6p.ma
   ```

2. Create the data collection script:
   ```bash
   # Create and edit the collect_usage.sh file
   nano ~/collect_usage.sh
   ```

3. Copy the contents of `collect_usage.sh` provided in this repository into the file. The script will automatically:
   - Calculate CPU and GPU usage for all users
   - Generate output in CSV format
   - Handle date ranges automatically

4. Make the script executable:
   ```bash
   chmod +x ~/collect_usage.sh
   ```

### 3. Configure the connection

1. Open `connection.py` and modify the following credentials:
   ```python
   # Replace these values with your Simlab credentials
   username = "your_username_here"  # Your Simlab username
   password = "your_password_here"  # Your Simlab password
   ```

2. The scheduler is configured to run hourly. You can modify the schedule in `scheduler.py` if needed.

### 4. Set Up the Dashboard

1. Open `dashboard.py` and ensure the admin credentials are properly set:
   ```python
   # Default admin credentials
   # You can modify these values for admin access
   if email == 'admin@um6p.ma' and password == 'admin123':
   ```

## Running the Project

1. First, start the scheduler to collect data:
   ```bash
   python connection.py
   ```
   This will:
   - Run the initial data collection
   - Schedule hourly updates
   - Download the latest data to `output.csv`
   ```python
    # in cas you dont want to wait for the script to run there is an available output.csv'''
2.  start the dashboard:
   ```bash
   python tempCodeRunnerFile.py
   ```
## Accessing the Dashboard

### Regular Users
- Login with your Simlab credentials
- View your personal CPU and GPU usage statistics

### Admin Access
- Email: admin@um6p.ma
- Password: admin123
- View usage statistics for all users


## Contact
If you have any questions about the project, feel free to reach out to any of our team members .

## Team members
Benfellah Ikram : ikram.benfellah@um6p.ma
Boussetta Yassir : yassir.bousseta@um6p.ma
Fadel Fatima zahra : fatimazahra.fadel@um6p.ma
Yeffou Jaafar : jaafar.yeffou@um6p.ma

