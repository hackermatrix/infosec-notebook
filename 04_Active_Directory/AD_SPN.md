# Service Principal Names (SPN)

## What are service principal names (SPNs)?

SPNs are used to uniquely identify a service that has registered itself in Active Directory. Each SPN is associated with a specific service account in Active Directory and describes the service type. Some service type examples:

- **Web services:** A web server like IIS might use an SPN such as **HTTP/webserver.domain.com** to authenticate with AD.
- **SQL services:** Microsoft SQL Server instances register an SPN such as **MSSQLSvc/servername.domain.com:1433** to enable Kerberos authentication.
- **File services:** A file server can have an SPN such as **HOST/fileserver.domain.com**.
- **Custom applications:** Enterprises often develop in-house applications that use AD and Kerberos for authentication. These applications might also register their SPNs.

## 1. SPN Structure
The general format of an SPN is:
`<ServiceClass>/<Host>:<Port>/<ServiceName>`

- **ServiceClass**: String identifying the type of service (e.g., `www`, `MSSQLSvc`, `CIFS`).
- **Host**: FQDN of the server running the service.
- **Port**: (Optional) Port number.
- **ServiceName**: (Optional) Name of the service.

**Example**: `MSSQLSvc/sql01.corp.local:1433`

---

## 2. Why SPNs Matter for Pentesting
- **Discovery**: SPNs allowed us to identify which services are running in the network without a noisy port scan.
- **Kerberoasting**: Any service account that has an SPN registered can be targeted for Kerberoasting. Attackers request a TGS for that service and attempt to crack it offline.

---

## 3. SPN Discovery Commands

### Windows Native (`setspn`)
```powershell
# List all SPNs for the current domain
setspn -Q */*

# Find SPNs for a specific user
setspn -L <username>
```

### PowerView
```powershell
# Get all users with SPNs (Kerberoasting targets)
Get-DomainUser -SPN
```

### Impacket (Remotely)
```bash
# GetUserSPNs.py can be used to list and request tickets
GetUserSPNs.py -dc-ip <DC_IP> <DOMAIN>/<USER> -request
```

---

## 4. Key Takeaways
- SPNs are stored in the `servicePrincipalName` attribute of an object.
- If an SPN is assigned to a **User Account**, it is likely vulnerable to Kerberoasting.
- If it's assigned to a **Computer Account**, it's generally considered safe from Kerberoasting as computer passwords are long and complex (though not immune to other attacks).

**Related Topics:**
- [[04_Active_Directory/AD_Objects|AD Objects]]
- [[04_Active_Directory/AuthLevelVulns/Kerberoasting|Kerberoasting]]
