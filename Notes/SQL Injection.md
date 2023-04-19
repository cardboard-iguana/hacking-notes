# SQL Injection

SQL injection is *most* common in PHP-based apps (though other languages are also vulnerable).

The canonical SQL injection "test" is to input a single quote and see if that generates an error. Remember, though, that there are *three* different kinds of quotes you may need to test!

When injecting code, you'll *often* want to end with a trailing "` -- `" (space-dash-dash-space) in order to *comment out* the remainder or the line you're injecting into. Generally "` --+`", "` --%20`", or "` -- -`" will be needed in practice to prevent the trailing space from being eaten. On some flavors of SQL, "`# `" (and variants of the trailing space) will work too. (And sometimes you don't even need the trailing comment, if the value you're injecting into is at the end of a statement…)

You don't necessarily know *how* user inputs are going to be processed on the backend. Sometimes its one query. Sometimes it's multiple queries. This means that you sometimes need to inject SQL into *multiple* fields (particularly when trying to subvert a login).

Similarly, sometimes a developer might get "clever" and try to error out on trailing comments. If you suspect that's happening, just add something after the trailing "` -- `" — it's all a comment, after all!

It's common to also test that login queries only return a single result. So sometimes you need to tack on `LIMIT 1` to achieve a login bypass.

## Types of SQLi

### Error-Based

Error-based SQLi retrieves data from the backend by abusing error messages. This obviously requires that error messages are shown to the end user, and is limited to information gathering.

### Boolean-Based

Boolean-based SQLi involves monitoring changes in responses to see if a query has executed or failed. The only reason you'd generally do this is if you're doing SQLi blind (where you don't get any output, or the output you do get isn't strongly coupled with the input query).

Obviously, this requires that either the HTTP response code or payload changes depending on the results of the injection… (Some frameworks try to make blind SQLi difficult by using redirects, but it's possible — though a pain — to get around this with Burp Suite).

One way this can be useful more generally is by using something like `AND (SELECT COUNT(*) FROM table_name) > 0` to probe for the existence/use of `table_name`.

* [Using Burp Suite](./Using%20Burp%20Suite.md)

### Time-Based

This is basically boolean-based SQLi, except that we're not even getting back true/false information anymore. However, we can introduce a timing attack by replacing a column with `sleep()` (which sleeps the connection for the specified number of seconds). If the query fails we'll get a return immediately, but if it succeeds then we'll experience the programmed pause.

### Union-Based

Union-based SQLi is basically just abusing the SQL UNION keyword.

To determine the number of columns in a table you'll need to use a sequence of UNION clauses until you run into and error.

* `' UNION SELECT NULL -- `
* `' UNION SELECT NULL, NULL -- `
* `' UNION SELECT NULL, NULL, NULL -- `
* …and so on until there's an error…

A similar approach can be used to detect column types.

* `' UNION SELECT 'a', NULL, NULL -- `
* `' UNION SELECT NULL, 'a', NULL -- `
* `' UNION SELECT NULL, NULL, 'a' -- `
* …and so on…

The generalization to other data types is straight-forward.

Useful MySQL keywords:

* `database()`
* `user()` and `current_user()`
* `version()` or `@@version`

The `GROUP_CONCAT()` function can be useful here: It concatenates fields (and arbitrary strings) in a row, and then further groups rows separated by commas (or by a string specified using SEPARATOR). `CONCAT()` also works for this (use `0x3a` to insert ":" characters as separators). 

It's worth checking out the Jurassic Park CTF for an example of how to use union-based SQLi (it's a little hard to summarize).

### Authentication Bypasses

The trick here is that most login forms use the backing database for authentication, so all we need to do is return a "true" result - we don't really need to guess anyone's password. Sometimes we don't even need to know a username (though I suspect that in practice this may lead to weird authorization problems).

### Out-of-Band

Out-of-band SQLi only works if the application or database makes external calls (preferably to a system we control!) based on the results of a database query (that we can inject into). Thus, there are always two channels - an attack channel and a data channel.

DNS is a popular data channel for out-of-band SQLi attacks.

## Defense

There are two main strategies for defending against SQLi:

* Get your encoding right. User-generated code that's passed off to SQL needs to be SQL-escaped first. Know what the context is of your data, and escape/unescape appropriately when writing data from one context to another!
* User prepared queries (in code) and stored procedures (in the database) to limit the ability of user-generated code to influence the surrounding SQL.
