# Windows Event Logs

## Windows Logs

* Application - Contains events logged by applications. For example, a database application might record a file error. The application developer decides which events to record.
* Security - Contains events such as valid and invalid logon attempts, as well as events related to resource use such as creating, opening, or deleting files or other objects. An administrator can start auditing to record events in the security log.
* System - Contains events logged by system components, such as the failure of a driver or other system component to load during startup.
* [CustomLog] - Contains events logged by applications that create a custom log. Using a custom log enables an application to control the size of the log or attach ACLs for security purposes without affecting other applications.

## Log Fields

* Type - Warning, error, information, etc.
* Time - Date/time for the computer *sending* the log
* Computer - Computer name
* Provider Type - The facility that generated the event (generally the Windows Event Log)
* Provider Name - The name of the log (Application, Security, etc.)
* Source - Application
* Event ID - Standardized (*not* unique!) identifier
* Description - Self-explanatory

Microsoft has more detailed documentation.

* [Eventlog Key](https://docs.microsoft.com/en-us/windows/win32/eventlog/eventlog-key)

## Event Types

* Error - An event that indicates a significant problem such as loss of data or loss of functionality. For example, if a service fails to load during startup, an Error event is logged.
* Warning - An event that is not necessarily significant, but may indicate a possible future problem. For example, when disk space is low, a Warning event is logged. If an application can recover from an event without loss of functionality or data, it can generally classify the event as a Warning event.
* Information - An event that describes the successful operation of an application, driver, or service. For example, when a network driver loads successfully, it may be appropriate to log an Information event. Note that it is generally inappropriate for a desktop application to log an event each time it starts.
* Success Audit - An event that records an audited security access attempt that is successful. For example, a user's successful attempt to log on to the system is logged as a Success Audit event.
* Failure Audit - An event that records an audited security access attempt that fails. For example, if a user tries to access a network drive and fails, the attempt is logged as a Failure Audit event.

Microsoft has more detailed documentation.

* [Event Types](https://docs.microsoft.com/en-us/windows/win32/eventlog/event-types)

## Event IDs

* 104 - Event log was cleared
* 1102 - Audit log was cleared (517 on Windows 2003 and earlier)

It's hard to find documentation about event ID, and the meaning seems to shift between versions of Windows.

* [How to find out who deleted Event Viewer logs](https://serverfault.com/questions/743575/how-to-find-out-who-deleted-event-viewer-logs)
* [Windows Security Event Log Cleared](https://support.alertlogic.com/hc/articles/115004121423-Windows-Security-Event-Log-Cleared)
