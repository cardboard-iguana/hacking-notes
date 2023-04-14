# Using "curl" and "jq" with Web APIs

You can query web APIs easily with cURL. If the API endpoint accepts GET requests, then this is as simple as:

```bash
curl "https://web.site/?parameter1=value1&parameter2=value2"
```

(The quotes are important here so that your shell doesn't interpret `&` as a request to background curl!)

For APIs that use GET/POST/PUT/etc. request types, combine the `-d` (data) and `-X` (request type) parameters:

```bash
curl -X POST \
     -d "parameter1=value1&parameter2=value2" \
        "https://web.site/"
```

The `-d` parameter can also be specified multiple times (mostly for readability), in which case you'd normally want to have a single parameter/value pair for each instance.

```bash
curl -X POST \
     -d "parameter1=value1" \
     -d "parameter2=value2" "https://web.site/"
```

By default, cURL sends data with the `Content-Type: application/x-www-form-urlencoded`. If you need to change the content type (for example, you frequently need to send `Content-Type: application/json` with JSON data) or need to specify additional headers (frequently for authentication), then you can use the `-H` (header) parameter.

```bash
curl -X POST \
     -H "User-Token: XXXXXX" \
     -d "parameter1=value1" \
     -d "parameter2=value2" "https://web.site/"
```

Like `-d`, the `-H` parameter can be specified multiple times for multiple headers, and will smartly override cURL's defaults.

```bash
curl -X POST \
     -H "User-Token: XXXXXX" \
     -H "Username: My User" \
     -d "parameter1=value1" \
     -d "parameter2=value2" "https://web.site/"
```

Because responses are often served up in a compact fashion, they're often a bit hard to read. The `jq` command's default filter (`.`) just pretty-prints (and colorizes!) JSON, which can make interpreting the API's response much easier.

```bash
curl -X POST \
     -H "User-Token: XXXXXX" \
     -H "Username: My User" \
     -d "parameter1=value1" \
     -d "parameter2=value2" "https://web.site/" | jq .
```

* [How to perform a POST request using Curl](https://www.educative.io/edpresso/how-to-perform-a-post-request-using-curl)

## Relevant Man Page Excerpts

### cURL

> `-d`, `--data DATA`
> (HTTP)  Sends  the  specified  data in a POST request to the HTTP server, in the same way that a browser does when a user has filled in an HTML form and presses the submit button. This will cause curl to pass the data to the server using the content-type `application/x-www-form-urlencoded`. Compare to `-F`, `--form`.
> 
> `--data-raw` is almost the same but does not have a special interpretation of the @ character. To post data purely binary, you should instead use the `--data-binary` option. To URL-encode the value of a form field you may use `--data-urlencode`.
> 
> If  any  of  these  options  is used more than once on the same command line, the data pieces specified will be merged together with a separating &-symbol. Thus, using `-d name=daniel -d skill=lousy` would generate a post chunk that looks like `name=daniel&skill=lousy`.
> 
> If you start the data with the letter @, the rest should be a file name to read the data from, or - if you want curl to read the data from stdin. Multiple files  can  also be  specified.  Posting data from a file named `foobar` would thus be done with `-d`, `--data @foobar`. When `--data` is told to read from a file like that, carriage returns and newlines will be stripped out. If you don't want the @ character to have a special interpretation use `--data-raw` instead.
> 
> `-H`, `--header HEADER/@FILE`
> (HTTP)  Extra header to include in the request when sending HTTP to a server. You may specify any number of extra headers. Note that if you should add a custom header that has the same name as one of the internal ones curl would use, your externally set header will be used instead of the internal one. This allows you to  make  even  trickier stuff  than  curl  would normally do. You should not replace internally set headers without knowing perfectly well what you're doing. Remove an internal header by giving a replacement without content on the right side of the colon, as in: `-H "Host:"`. If you send the custom header with no-value then its header must be terminated with a  semicolon, such as `-H "X-Custom-Header;"` to send `"X-Custom-Header:"`.
> 
> curl  will  make sure that each header you add/replace is sent with the proper end-of-line marker, you should thus not add that as a part of the header content: do not add newlines or carriage returns, they will only mess things up for you.
> 
> Starting in 7.55.0, this option can take an argument in @filename style, which then adds a header for each line in the input file. Using @- will make curl read the  header file from stdin.
> 
> See also the `-A`, `--user-agent` and `-e`, `--referer` options.
> 
> Starting in 7.37.0, you need `--proxy-header` to send custom headers intended for a proxy.
> 
> Example:
> 
> `curl -H "X-First-Name: Joe" http://example.com/`
> 
> WARNING:  headers set with this option will be set in all requests - even after redirects are followed, like when told with `-L`, `--location`. This can lead to the header being sent to other hosts than the original host, so sensitive headers should be used with caution combined with following redirects.
> 
> This option can be used multiple times to add/replace/remove multiple headers.
> 
> `-X`, `--request COMMAND`
> (HTTP)  Specifies  a  custom request method to use when communicating with the HTTP server.  The specified request method will be used instead of the method otherwise used (which defaults to GET). Read the HTTP 1.1 specification for details and explanations. Common additional HTTP requests include PUT and  DELETE,  but  related  technologies like WebDAV offers PROPFIND, COPY, MOVE and more.
> 
> Normally you don't need this option. All sorts of GET, HEAD, POST and PUT requests are rather invoked by using dedicated command line options.
> 
> This  option only changes the actual word used in the HTTP request, it does not alter the way curl behaves. So for example if you want to make a proper HEAD request, using -X HEAD will not suffice. You need to use the `-I`, `--head` option.
> 
> The method string you set with `-X`, `--request` will be used for all requests, which if you for example use `-L`, `--location` may cause unintended side-effects when curl doesn't change request method according to the HTTP 30x response codes - and similar.

### jq

> BASIC FILTERS
> 
> Identity: `.`
> The absolute simplest filter is `.`. This is a filter that takes its input and produces it unchanged as output. That is, this is the identity operator.
> 
> Since jq by default pretty-prints all output, this trivial program can be a useful way of formatting JSON output from, say, curl.
