# Enterprise Virtual Infrastructure & Active Directory Identity Lab

![PowerShell](https://img.shields.io/badge/PowerShell-100%25-blue.svg) ![Windows Server](https://img.shields.io/badge/Windows%20Server-2022-red.svg) ![Hypervisor](https://img.shields.io/badge/VMware-Workstation-orange.svg)

A hands-on, virtualized enterprise infrastructure built on **Windows Server 2022** designed to simulate real-world Active Directory Domain Services (AD DS) management and automated user lifecycle provisioning using custom PowerShell scripting.

---

## 📌 Project Overview

Managing enterprise identities manually across multiple departments leads to high operational overhead and human error. This lab demonstrates an end-to-end operational solution for enterprise access management:

* **Infrastructure Setup:** Designing a multi-departmental Active Directory domain structure from scratch (`franclab.org`) on Windows Server 2022.
* **GUI Baseline Provisioning:** Manually configuring baseline Organizational Units (OUs), core administrative accounts, and initial Security Groups using the Active Directory Users and Computers (ADUC) GUI interface.
* **Automated Provisioning Pipeline:** Developing a modular PowerShell script to replace manual GUI workflows—ingesting structured CSV data, validating attributes, creating AD accounts, and automatically routing users to designated OUs and Security Groups.

---
## 🛠️ Environment & Tools

| Component | Technical Details |
| :--- | :--- |
| **Hypervisor** | VMware Workstation |
| **Server OS** | Windows Server 2022 |
| **Domain Services** | `franclab.org` |
| **Core Services** | Active Directory Domain Services (AD DS), DNS, DHCP |
| **Automation** | PowerShell, RSAT (`ActiveDirectory` module) |
| **Data Ingestion** | Structured CSV (`newUsers.csv`) |

---

## 📂 Repository Structure

```text
Enterprise-Virtual-Lab/
├── README.md                 # Project documentation & execution guide
├── Automated-Users.ps1       # Core PowerShell bulk user provisioning script
├── newUsers.csv              # Structured CSV dataset for user identity ingestion
└── images/                   # Proof of concept verification screenshots
```
---

## ⚙️ The Automation Pipeline

To streamline user lifecycle operations, the custom PowerShell script ingests a CSV file and fully automates account creation.

### 1. Data Source Format (`newUsers.csv`)
The script reads from `C:\lab-assets\newUsers.csv`. The input file must be formatted with the following headers to ensure accurate OU routing and attribute mapping:

```
FirstName, LastName, Department, PrimaryGroup, SubGroup
James, Bond, IT, All-IT, IT-Admins
David, Jordan, Finance, All-Finance, Account-Payable
Lupe, Montero, Sales, All-Sales, Sales-East
Veronica, Garcia, HR, All-HR,HR-East
John, Smith, Sales,All-Sales, Sales-West
Martin, Smith, Sales, All-Sales,Sales-West
Jane, Doe, IT,All-IT, IT-Helpdesk
Jessica, Kim, IT,All-IT, IT-Helpdesk
Charlie, Brown, Finance, All-Finance, Payroll
```

### 2. Automated Logic & Execution Steps

When executed, the provisioning script processes records sequentially and performs the following tasks:

1. **Account Attribute Generation:** Dynamically constructs `samAccountName` (e.g., `john.doe`) and the User Principal Name (`john.doe@franclab.org`).
    
2. **Dynamic OU Routing:** Identifies the user's target department and provisions the user object into the corresponding Organizational Unit (e.g., `OU=IT,DC=franclab,DC=org`).
    
3. **Security Compliance Enforcement:** Assigns a temporary baseline password (`TempPass123!`) and flags the account to enforce **"User Must Change Password at Next Logon"**.
    
4. **Role-Based Access Control (RBAC):** Automatically adds the user to primary departmental groups (e.g., `All-IT`) and granular sub-groups (e.g., `IT-Admins`) based on the CSV parameters.
    
5. **Error Handling & Logging:** Uses `Try/Catch` exception handling to log errors per record without interrupting the bulk creation process.

## Usage & Deployment Instructions

### Prerequisites

- Windows Server 2022 configured as a Domain Controller for `franclab.org`.
    
- Remote Server Administration Tools (RSAT) installed with administrative privileges.
    
- Execution Policy configured to run local scripts (`Set-ExecutionPolicy RemoteSigned`).
    

### Step-by-Step Execution

1. Place the target CSV file in `C:\lab-assets\newUsers.csv`.
    
2. Open PowerShell as an **Administrator**.
    
3. Run the provisioning script:

```powerShell  
# Execute provisioning script with verbose logging
.\Automated-Users.ps1 -CSVPath "C:\lab-assets\newUsers.csv" -Verbose
```


## 📸 Proof of Concept & Verification

### Active Directory Provisioning Verification

Below is a comparison of departmental Organizational Units within Active Directory, demonstrating manual base setup alongside accounts dynamically generated and mapped by the PowerShell pipeline:

<details>
<summary><b>💼 Sales Department</b></summary>

| Manual Base Setup | Automated Bulk Provisioning |
|---|---|

| <img src="images/active-directory/sales-manual.png" width="500"> | <img src="images/active-directory/sales-automated.png" width="400"> |

</details>

<details>
<summary><b>👥 Human Resources (HR)</b></summary>

| Manual Base Setup | Automated Bulk Provisioning |
|---|---|

| <img src="images/active-directory/hr-manual.png" width="500"> | <img src="images/active-directory/hr-automated.png" width="400"> |

</details>

<details>
<summary><b>💻 Information Technology (IT)</b></summary>

| Manual Base Setup | Automated Bulk Provisioning |
|---|---|
| <img src="images/active-directory/it-manual.png" width="500"> | <img src="images/active-directory/it-automated.png" width="400"> |

</details>

<details>
<summary><b>📊 Finance Department</b></summary>

| Manual Base Setup | Automated Bulk Provisioning |
|---|---|
| <img src="images/active-directory/finance-manual.png" width="500"> | <img src="images/active-directory/finance-automated.png" width="400"> |

</details>
