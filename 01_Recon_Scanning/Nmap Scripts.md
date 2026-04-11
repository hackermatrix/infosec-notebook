
**Nmap Scripting Engine (NSE)**

The **N**map **S**cripting **E**ngine (NSE) is an incredibly powerful addition to Nmap, extending its functionality quite considerably. **NSE Scripts are written in the _Lua_ programming language, and can be used to do a variety of things: from scanning for vulnerabilities, to automating exploits for them**. The NSE is particularly useful for reconnaisance, however, it is well worth bearing in mind how extensive the script library is.

. Some useful categories include:

- `safe`:- **Won't affect the target**
- `intrusive`:- **Not safe: likely to affect the target**  
- `vuln`:- **Scan for vulnerabilities**
- `exploit`:- Attempt to exploit a vulnerability
- `auth`:- **Attempt to bypass authentication for running services (e.g. Log into an FTP server anonymously)**
- `brute`:- **Attempt to bruteforce credentials for running services**
- `discovery`:- Attempt to query running services for further information about the network (e.g. query an SNMP server).



To run a specific script, we would use `--script=<script-name>` , e.g. `--script=http-fileupload-exploiter`.

Multiple scripts can be run simultaneously in this fashion by separating them by a comma. For example: `--script=smb-enum-users,smb-enum-shares`.

Some scripts require arguments (for example, credentials, if they're exploiting an authenticated vulnerability). These can be given with the `--script-args` Nmap switch. An example of this would be with the `http-put` script (used to upload files using the PUT method). This takes two arguments: the URL to upload the file to, and the file's location on disk.  For example:

`nmap -p 80 --script http-put --script-args http-put.url='/dav/shell.php',http-put.file='./shell.php'`

Note that the arguments are separated by commas, and connected to the corresponding script with periods (i.e.  `<script-name>.<argument>`).

A full list of scripts and their corresponding arguments (along with example use cases) can be found

---

Nmap scripts come with built-in help menus, which can be accessed using `nmap --script-help <script-name>`. This tends not to be as extensive as in the link given above, however, it can still be useful when working locally.

**Searching for Scripts**

One way to do is if you know the script name do it through this 

nmap --script-help=<script name>
nmap --script-help=ftp-anon.nse

https://nmap.org/book/nse-usage.html#nse-script-selection
https://nmap.org/nsedoc/scripts/ftp-anon.html

The second is the local storage on your attacking machine. Nmap stores its scripts on Linux at **`/usr/share/nmap/scripts`**. All of the NSE scripts are stored in this directory by default -- this is where Nmap looks for scripts when you specify them.

![[Pasted image 20260404130744.png]]


There are two ways to search for installed scripts. One is by using the `/usr/share/nmap/scripts/script.db` file. Despite the extension, **this isn't actually a database so much as a formatted text file containing filenames and categories for each available script.**

Nmap uses this file to keep track of (and utilise) scripts for the scripting engine; however, we can also _grep_ through it to look for scripts. For example: `grep "ftp" /usr/share/nmap/scripts/script.db`. 


The second way to search for scripts is quite simply to use the `ls` command. For example, we could get the same results as in the previous screenshot by using `ls -l /usr/share/nmap/scripts/*ftp*`:

Note the use of asterisks_ (`*`) _on either side of the search term_

The same techniques can also be used to search for categories of script. For example:  
`grep "safe" /usr/share/nmap/scripts/script.db`


_Installing New Scripts_

We mentioned previously that the Nmap website contains a list of scripts, so, what happens if one of these is missing in the `scripts` directory locally? A standard `sudo apt update && sudo apt install nmap` should fix this; however, it's also possible to install the scripts manually by downloading the script from Nmap

(`sudo wget -O /usr/share/nmap/scripts/<script-name>.nse https://svn.nmap.org/nmap/scripts/<script-name>.nse`). 

This must then be followed up with `nmap --script-updatedb`, which updates the `script.db` file to contain the newly downloaded script.

It's worth noting that you would require the same "updatedb" command if you were to make your own NSE script and add it into Nmap -- a more than manageable task with some basic knowledge of Lua!


If you want to check the dependencies of the script you can do it through 

grep "dependencies" /usr/share/nmap/scripts/<script-name>







