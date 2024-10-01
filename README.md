**Wasp** is a payload generator and deployment tool for "disableing windows security fetures for ease spread of malware". It uses Metasploit Framework to create and deploy payloads, and Apache server to host the payloads.

#### **Files**:
* `requirements.txt`: a batch script that sets up the payload on the victim's machine.
* `metapreter.rc`: a Metasploit resource file that configures the payload handler.
* `builder.sh`: a bash script that generates the payloads, sets up the Apache server, and deploys the payloads.

#### **Usage**:
* execute the `builder.sh` file and answer the prompts it asks:

#### **extra**:
1. The script will generate the payloads, set up the Apache server, and deploy the payloads.
2. The payload link will be displayed at the end of the script. Send this link to the victim to execute the payload.

#### **Warning**:
> This software is intended for penetration, malware spread, and not ethical hacking purposes. It should "not" be used to harm or exploit others without their consent.

#### **Licence**:
> This software is licensed under the **GNU General Public License (GPL) version 3.0.**

