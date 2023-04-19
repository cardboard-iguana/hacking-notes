# XXE (XML External Entity) Attacks

The trick with XXE attacks is that the URIs defined in an XML !DOCTYPE directive are basically just includes. This means that when an application is expecting XML input (mostly this is a thing you find over APIs), you can extend the provided DTDs in an ad hoc fashion.

First, an example DTD from TryHackMe:

```dtd
<!DOCTYPE note [
	<!ELEMENT note (to, from, heading, body)>
	<!ELEMENT to (#PCDATA)>
	<!ELEMENT from (#PCDATA)>
	<!ELEMENT heading (#PCDATA)>
	<!ELEMENT body (#PCDATA)>
]>
```

This defines the following XML:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE note SYSTEM "note.dtd">
<note>
    <to>foo</to>
    <from>bar</from>
    <heading>baz</heading>
    <body>etc.</body>
</note>
```

(`#PCDATA` indicates "parsable character data" - an XML-encoded string. The special SYSTEM keyword basically means "this URI/file is hosted by the current system", and can be included in both !DOCTYPE and !ENTITY declarations.) 

There are three basic important XML bits here:

* `!DOCTYPE` defines the document type *and* the root element.
* `!ELEMENT` defines additional elements (so if I understand this correctly, a !DOCTYPE declaration must contain at least one !ELEMENT with the same name).
* `!ENTITY` defines entities like `&gt;` - basically shortcuts for other data. There seems to be a lot more to XML entities than just this though…

Basically, you can think of the bit between the brackets (`[]`) in the DTD as getting slotted into the URI specifying the DTD in the XML !DOCTYPE. In fact, we can insert additional document type definitions into the end of a !DOCTYPE statement in this way; combining this with the SYSTEM declaration can allow us to read any files the webserver has access to.

```xml
<?xml version="1.0"?>
<!DOCTYPE root [
	<!ENTITY read SYSTEM "file:///etc/passwd">
]>
<root>&read;</root>
```

Note that the added !DOCTYPE declaration *doesn't* have to correspond to the !DOCTYPE the server is using (since these definitions are concatenated). So don't spend too much time coming up with a !DOCTYPE in order to define your !ENTITY - any "garbage" !DOCTYPE will do.

This basically strikes me as more-or-less the same thing as an injection attack, just that we're targeting the XML parser rather than the website code.

* [ENTITY Declaration](https://xmlwriter.net/xml_guide/entity_declaration.shtml)

## Remote Code Execution

*If* you're dealing with PHP, and *if* the PHP expect module is loaded, and *if* XML inputs aren't properly sanitized, then defining a SYSTEM entity with the value of `expect://$COMMAND` will get you RCE!
