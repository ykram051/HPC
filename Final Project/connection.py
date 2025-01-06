import paramiko
import schedule
import time
import csv
import datetime

def run_hpc_script():
    """
    Connects to the Simlab HPC environment via SSH,
    runs 'collect_usage.sh',
    then downloads output.csv to the local machine.
    """
    #---------------------------------------
    # Step 1: Connect to the HPC environment (Simlab) via SSH with a password
    #---------------------------------------
    hostname = "simlab-cluster.um6p.ma"
    username = "your_username_here"  # Replace with your Simlab username
    password = "your_password_here"  # Replace with your Simlab password

    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname, username=username, password=password)

    #---------------------------------------
    # Step 2: Run the Bash Script Remotely
    #---------------------------------------
    bash_script_path = f"/home/{username}/collect_usage.sh"  # Adjust path for the current user

    stdin, stdout, stderr = ssh.exec_command(f"bash {bash_script_path}")
    exit_status = stdout.channel.recv_exit_status()

    if exit_status != 0:
        error_output = stderr.read().decode('utf-8')
        print("Error running the script:", error_output)
        ssh.close()
        return  # Exit the function gracefully without raising an exception

    #---------------------------------------
    # Step 3: Retrieve the output.csv file locally
    #---------------------------------------
    sftp = ssh.open_sftp()
    remote_csv_path = f"/home/{username}/output.csv"  # Adjust path for the current user
    local_csv_path = "output.csv"
    sftp.get(remote_csv_path, local_csv_path)
    sftp.close()
    ssh.close()

    print(f"[{datetime.datetime.now()}] Script ran successfully. output.csv updated.")

if __name__ == "__main__":
    # Run the script immediately once at startup
    run_hpc_script()

    # Schedule it to run every hour
    schedule.every().hour.do(run_hpc_script)

    # Keep running forever
    while True:
        schedule.run_pending()
        time.sleep(3600)
